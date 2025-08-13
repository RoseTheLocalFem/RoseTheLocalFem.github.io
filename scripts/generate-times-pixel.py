#!/usr/bin/env python3
"""
Generate pixel-style Times-like fonts with FontForge.
This script is invoked by generate-times-pixel.ps1 via FontForge:
  fontforge -lang=py -script scripts/generate-times-pixel.py -- --in input.ttf --outBase assets/fonts/TimesPixel-Regular --family TimesPixelLocal --style Regular

It will:
- Open the input TTF
- Add bitmap strikes at 16px and 80px (to help autotrace behave like low-DPI rendering)
- Remove existing outlines if needed and autotrace bitmaps (requires potrace configured in FontForge)
- Generate WOFF2 and WOFF outputs at outBase.(woff2|woff)

Notes:
- Ensure FontForge has potrace configured for Autotrace (Preferences > Import > Autotrace). If not, it will still try, but results may vary.
- Use open fonts (Liberation Serif, TeX Gyre Termes) or system Times for personal/local use only and do not commit proprietary outputs.
"""
import sys, argparse

try:
    import fontforge
    import psMat
except Exception as e:
    sys.stderr.write("This script must be run inside FontForge (fontforge -lang=py -script ...).\n")
    sys.exit(2)

parser = argparse.ArgumentParser()
parser.add_argument('--in', dest='inp')
parser.add_argument('--outBase', dest='outbase')
parser.add_argument('--family', dest='family', default=None)
parser.add_argument('--style', dest='style', default=None)
args, unknown = parser.parse_known_args()

import os
src = args.inp or os.environ.get('INPUT_TTF')
outbase = args.outbase or os.environ.get('OUTPUT_BASE')
family = args.family or os.environ.get('FAMILY_NAME') or 'TimesPixelLocal'
style = args.style or os.environ.get('STYLE_NAME') or 'Regular'

if not src or not outbase:
    sys.stderr.write('Missing required args: --in/INPUT_TTF and --outBase/OUTPUT_BASE\n')
    sys.exit(2)

# Open font
f = fontforge.open(src)

# Set names
f.familyname = family
f.fullname = f"{family} {style}"
# Map style to weight/style
weight = 'Book'
italic = False
if style.lower() == 'italic':
    italic = True
elif style.lower() == 'bold':
    weight = 'Bold'
elif style.lower() == 'bolditalic':
    weight = 'Bold'
    italic = True

f.weight = weight
f.italicangle = -12 if italic else 0

# Add bitmap strikes at 16px and 80px (nearest-neighbour)
f.selection.none()
try:
    f.bitmapSizes = ()
    f.addLookup("gsub", "gsub_single", (), ((),))
except Exception:
    pass
try:
    f.generateBitmaps(".ttf", (16, 80))
except Exception:
    # Older FF: through Bitmap Strikes Available API
    try:
        f.selection.all()
        f.autoHint()
    except Exception:
        pass

# Autotrace from bitmaps
try:
    f.autoTrace()
except Exception:
    # Fallback: try to remove overlap and round, even if not traced
    try:
        f.removeOverlap()
        f.round()
    except Exception:
        pass

# Cleanup
try:
    f.removeOverlap()
    f.round()
except Exception:
    pass

# Generate outputs
try:
    f.generate(outbase + '.woff2')
except Exception as e:
    sys.stderr.write('WOFF2 generate failed: %s\n' % e)
try:
    f.generate(outbase + '.woff')
except Exception as e:
    sys.stderr.write('WOFF generate failed: %s\n' % e)

f.close()
print("Generated:", outbase + '.woff2', outbase + '.woff')

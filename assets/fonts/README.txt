Local pixel serif font instructions

Goal: Pixelated Times-style serif under an open license.

Recommended base fonts (OFL-compatible):
- TeX Gyre Termes (Times-like)  — License: GUST Font License (OFL-compatible)
- Liberation Serif               — License: SIL Open Font License

Approach A: Use pre-made pixel variants (if you have them)
- Place files with these exact names into this folder (single-size):
   TimesPixel-Regular.woff2 / .woff
   TimesPixel-Italic.woff2   / .woff
   TimesPixel-Bold.woff2     / .woff
   TimesPixel-BoldItalic.woff2 / .woff
- Or multi-size (recommended):
   TimesPixel-16-Regular.woff2/.woff, TimesPixel-24-Regular.woff2/.woff, TimesPixel-32-Regular.woff2/.woff
   TimesPixel-16-Italic.woff2/.woff, TimesPixel-24-Italic.woff2/.woff, TimesPixel-32-Italic.woff2/.woff
   TimesPixel-16-Bold.woff2/.woff, TimesPixel-24-Bold.woff2/.woff, TimesPixel-32-Bold.woff2/.woff
   TimesPixel-16-BoldItalic.woff2/.woff, TimesPixel-24-BoldItalic.woff2/.woff, TimesPixel-32-BoldItalic.woff2/.woff
- The CSS maps 16px to body, 24px to h2/h3, 32px to h1.

Approach B: Generate your own pixel variant (FontForge pipeline)
1) Install FontForge and potrace.
2) Start with Liberation Serif or TeX Gyre Termes TTFs (open-licensed).
3) In FontForge:
   - Open the TTF
   - Element > Bitmap Strikes Available… > Add 16 px and 80 px (for tracing)
   - View at 200% with nearest-neighbour; verify pixel look at 16 px
   - Element > Autotrace… (configure to use potrace)
   - Remove original outlines if needed; keep traced outlines
   - Generate Font… choose WOFF2/WOFF outputs
4) Export Regular/Bold/Italic/BoldItalic as single-size or multi-size:
   Single-size: TimesPixel-<Style>.woff2/.woff
   Multi-size: TimesPixel-<PX>-<Style>.woff2/.woff (e.g., TimesPixel-24-Bold.woff2)
5) Drop them here; rebuild site. Pixel Mode will pick them up.

Notes:
- Don’t use original proprietary Times New Roman files; use open clones (Liberation/TeX Gyre).
- The site defaults to Pixel Mode ON but users can opt out. Normal stack still uses Times-like system fonts.

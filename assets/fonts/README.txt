Local pixel serif font instructions

Goal: Pixelated Times-style serif under an open license.

Recommended base fonts (OFL-compatible):
- TeX Gyre Termes (Times-like)  — License: GUST Font License (OFL-compatible)
- Liberation Serif               — License: SIL Open Font License

Approach A: Use pre-made pixel variants (if you have them)
- Place files with these exact names into this folder:
  TimesPixel-Regular.woff2 / .woff
  TimesPixel-Italic.woff2   / .woff
  TimesPixel-Bold.woff2     / .woff
  TimesPixel-BoldItalic.woff2 / .woff
- The CSS already maps them via @font-face as "TimesPixelLocal".

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
4) Export Regular/Bold/Italic/BoldItalic as:
   TimesPixel-Regular.woff2/.woff
   TimesPixel-Italic.woff2/.woff
   TimesPixel-Bold.woff2/.woff
   TimesPixel-BoldItalic.woff2/.woff
5) Drop them here; rebuild site. Pixel Mode will pick them up.

Notes:
- Don’t use original proprietary Times New Roman files; use open clones (Liberation/TeX Gyre).
- The site defaults to Pixel Mode ON but users can opt out. Normal stack still uses Times-like system fonts.

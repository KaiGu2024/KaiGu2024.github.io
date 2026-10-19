# Gallery validation

Checked 2026-10-19. All examples use original illustrative data or fictional relationships; no PaperBanana figure or benchmark code was copied.

- Ran all five R scripts with R 4.6.1. Each produced one single-page PDF with vector artwork (no embedded raster images), at its declared 7.2-inch width. The short data checks in each script passed.
- Rendered PDFs with pdftoppm at 120 DPI and inspected them. Corrected clipped coefficient/grouped-comparison axis titles and increased time-series boundary clearance; rerendered and inspected affected files.
- Parsed the conceptual SVG as XML and rendered it with rsvg at 1600 pixels wide. Checked four nodes and three relationships against the intended list in the gallery, including connector endpoints and measurement links.
- Inspected grayscale, protanopia, deuteranopia, and tritanopia simulations made with R colorspace for all six examples. Labels, line/shape distinctions, and cell values retain their meanings.
- These are standalone examples. No manuscript or slide placement was assessed. Their small embedded browser views do not establish readability at a smaller publication size.

Disposable raster inspection files are under the ignored `exploratory/previews/skill-gallery/`; the gallery delivers PDF examples and the editable SVG. Source scripts share `_setup.R` and the canonical theme instead of duplicating styling functions.

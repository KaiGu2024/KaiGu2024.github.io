# Gallery validation

Checked 2026-10-19. All examples use original illustrative data or fictional relationships; no PaperBanana figure or benchmark code was copied.

- Ran all five R scripts with R 4.6.1. Each produced one single-page PDF with vector artwork (no embedded raster images), at its declared 7.2-inch width. The short data checks in each script passed.
- Rendered PDFs with pdftoppm at 120 DPI and inspected them. Corrected clipped coefficient/grouped-comparison axis titles and increased time-series boundary clearance; rerendered and inspected affected files.
- Parsed the conceptual SVG as XML and rendered it with rsvg at 1600 pixels wide. Checked four nodes and three relationships against the intended list in the gallery, including connector endpoints and measurement links.
- Inspected grayscale, protanopia, deuteranopia, and tritanopia simulations made with R colorspace for all six examples. Labels, line/shape distinctions, and cell values retain their meanings.
- These are standalone examples. No manuscript or slide placement was assessed. Their small embedded browser views do not establish readability at a smaller publication size.

Disposable raster inspection files are under the ignored `exploratory/previews/skill-gallery/`; the gallery delivers PDF examples and the editable SVG. Source scripts share `_setup.R` and the canonical theme instead of duplicating styling functions.

## Palette revision, 2026-10-19

- Updated event-study, coefficient and time-series examples to use the deeper small-mark palette. Reran all three scripts and inspected their rendered PDFs at the declared width; their data, labels, intervals and geometry are unchanged.
- Checked the default color and fill scales through `ggplot_build()` for one through five groups, and checked the palette helper's group limits. Existing broad-area fills and named subject colors are preserved.
- Inspected palette swatches in original color, grayscale and three color-vision simulations. Inspected all four transformed versions of the two-series example: its shapes, line patterns and direct labels preserve group identity where hues become similar. Palette choice alone does not establish distinguishability.
- Small-mark blue/green come from Paul Tol's bright scheme; the five-color group option selects non-pale members of his muted scheme; the optional high-contrast trio is unchanged from [Tol's specification](https://sronpersonalpages.nl/~pault/). These are house selections, not a new validated palette.
- Inspection rasters for this revision are in ignored `exploratory/previews/palette-revision/`. The heatmap retains its original orientation, now stated in the gallery. Diagram colors are governed solely by the conceptual-framework visual specification.

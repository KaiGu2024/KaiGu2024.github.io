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

## Discrete-estimate style revision, 2026-10-22

- Inspected the user-provided `reading_full_acs_capped_search.pdf` and its project source, `code/Gemini_Ctrl/reading_setup.R`. The saved PDF is 7.194 inches wide; `code/Gemini_Ctrl/twfe/reading-package.tex` places it at 7.2 inches. Source settings are navy `#1F3A5F`, points 2.6, interval width 0.65, gray references 0.4, axes 0.65 and ticks 0.55. These are ggplot settings, not measurements of font size. The reference illustrates the requested preference; its empirical results were not audited or copied into the gallery.
- Promoted fine dots and individual intervals to the event-study/coefficient default. Replaced smoothness-based ribbon selection and oversized/open/tangent-circle variants with one recipe. Added an estimate profile to the shared theme, preserving 20/16 pt typography and existing descriptive-series behavior.
- Rebuilt the two estimate gallery examples at their existing 7.2 × 4.8-inch geometry. Original-versus-revised checks preserve data, labels, every interval endpoint and normalization: eight estimated periods plus one hollow reference for the event study; four estimates for the coefficient plot. No connecting line or ribbon is present. The Markdown recipe also executes and retains all supplied intervals.
- Checked both theme profiles, the accepted equal-width geometry, rejection of a 5.46-inch export at 3.26-inch placement, and 78 local file/heading links. Inspection and check files are under ignored `exploratory/previews/event-study-style/`.
- Independent Critic acceptance: both exact saved PDFs passed source-content, layout, vector-output and grayscale checks at approximately 7.2-inch width. Event-study SHA-256: `0aec6db2186087958aa9bb2177d8ce3a8f116885d24654ac1e792a118fee6961`; coefficient SHA-256: `f037c353807c3bd9f3877b7885715b576b49ac33f3d253f2e53625f408515991`. Clarified that using one navy swatch as constant ink does not map a rank ramp. Standalone gallery review only; no host manuscript was produced.

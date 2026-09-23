# Visual acceptance audit for conceptual diagrams

Run this audit before delivery. When the `visualization` skill is available, consult its applicable layout, annotation, and palette standards as well. This reference keeps the audit usable without that skill installed. Report this as a **diagram-specific visualization audit**, not blanket compliance with an R/ggplot publication workflow.

## Scope and placement

Declare the intended use and placement size before drawing: screen, slide, or manuscript. Follow the user's dimensions. If unspecified, default to a standalone screen figure inspected at 1600 CSS pixels wide; state this assumption in the source note. Screen acceptance does not establish readability when reduced into a slide or manuscript column.

For screen delivery, preserve readable text at the declared width (normally at least 16 px for supporting labels and 22 px for primary node labels). For manuscript or publication output, declare physical dimensions and target type sizes, keep export and placement widths within 10%, and provide vector output plus a 600-DPI raster at those physical dimensions when requested. Pixel count or “2×” alone is not a DPI or print-readability claim.

## Checks that block acceptance

1. **Source and meaning:** all constructs, measures, arrow directions, signs, units, levels, and captions agree with the evidence map. Color identifies construct versus measurement type; it must not simultaneously encode a different property such as randomization or effect size.
2. **Direct labels and grouping:** every node and consequential relation is identifiable without guessing. Keep the semantic legend compact; use direct labels for moderation, covariance, measurement direction, and important status distinctions. Proximity and connections must not imply unsupported groupings or causal paths.
3. **Geometry:** open the saved SVG render/PNG at the declared placement width. Check labels against other text, node interiors/boundaries, connectors, and canvas edges. Inspect both heads of a bidirected edge and every reflective/formative direction. A text-bounds check alone cannot detect a label hidden behind an interior node.
4. **Color accessibility:** inspect the actual figure in grayscale and simulations of protanopia, deuteranopia, and tritanopia using an available tool (for example Color Oracle or browser vision-deficiency emulation). Shape, labels, and line conventions must preserve interpretation when hues converge. Record the tool and modes actually checked; simulations are not a universal accessibility guarantee.
5. **Exports:** confirm SVG validity, editable text, correct raster dimensions, and consistency across formats. If PDF or a host slide/manuscript is produced, inspect every final PDF page or the placed figure at actual size as well.

Reject and repair overlap, clipping, hidden arrowheads, unreadable text, misleading encodings, or unresolved source inconsistencies. Shorten/wrap labels, reroute edges, increase spacing, or split panels before shrinking type. Re-export and inspect after repairs. If a check cannot be performed, state exactly what remains unverified rather than marking the audit passed.

## Diagram-specific adaptations

- Editable SVG is the master for a relationship diagram. R/ggplot is not a prerequisite for drawing semantic nodes and edges.
- A minimal arrow/shape legend explains a graphical language, so it is retained when necessary. It should not replace direct labels.
- Standalone explanatory diagrams may include compact titles, source lines, panel labels, and design qualifications. For a manuscript-ready variant, place long captions and contextual prose in the host document and simplify the artwork.
- Axes, sorted categories, treatment-minus-control plots, aggregation routines, and uncertainty intervals apply only when actual quantitative results are displayed. Do not invent numerical evidence to satisfy a plotting checklist.
- Shared panels may clarify complementary conceptual frameworks or separate structural and measurement models. Keep their identities explicit and split them when placement readability requires it.

Record pass/fail/unverified for placement readability, geometry, semantics, color simulations, and exports in the source note. State which adaptations apply; do not call a screen-oriented SVG/PNG a fully audited publication figure.

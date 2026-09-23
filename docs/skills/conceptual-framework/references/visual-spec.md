# Figure construction and export

Use native, editable SVG as the default master. Adapt layout to the paper rather than forcing a fixed template.

## Visual vocabulary

| Element | Shape and appearance |
|---|---|
| Theoretical construct | Oval; blue stroke `#234E96`, pale blue fill `#EEF3FB`, dark text |
| Observed measure or manipulation | Rectangle with modest corner radius; green stroke `#0E6E5A`, pale green fill `#EAF5F0`; explicit measure/manipulation label |
| Unobserved common cause, error, or contextual note | Neutral outline or bracket, explicitly named and marked “unobserved” when applicable |
| Structural relationship | Solid dark blue or charcoal path with semantic arrowheads |
| Generic measurement correspondence | Dashed gray path, no arrowheads, labeled “measured by” or “operationalized by” |
| Moderation connector | Solid connector labeled “moderates,” ending at the focal path rather than at the outcome node |

Color is redundant with shape and labels so the figure remains interpretable in grayscale. If an observed variable is also the substantive construct, show its theoretical definition and empirical operationalization in separate layers only when useful; explain the direct observation rather than inventing a latent scale. Neutral nodes do not imply excluded or statistically controlled variables.

Use white background, a commonly available sans-serif font, and one consistent type hierarchy. Avoid gradients, shadows, decorative icons, and boxes around every annotation. A 1600×1000 viewBox is a starting point, not a requirement. Keep primary labels around 24–32 SVG units and supporting labels around 18–22 at that size; adjust the canvas or split panels before reducing text to unreadable size.

Place the substantive flow left-to-right, measures near their constructs, and confounders/moderators where their edges stay clear. Add labeled panels if theory and empirical design cannot fit without clutter. Put a compact legend and source line inside the figure, with detailed locators and qualifications in the accompanying Markdown.

## SVG implementation details

- Set `xmlns`, width/height, and viewBox. Include `<title>` and `<desc>` for accessibility.
- Use native `<text>` and `<tspan>` with explicit wrapping and line heights. Escape `&`, `<`, and `>` in labels. Avoid `<foreignObject>`, remote assets, external CSS, and embedded scripts for portable scientific output.
- Draw connectors before nodes; trim endpoints to node boundaries so arrowheads remain visible. Route links through whitespace, not through nodes or labels.
- Define marker arrowheads with `orient="auto-start-reverse"` when supported. For a bidirected curve, check that the start head points toward its start node and the end head toward its end node. Two attached heads that point in the same direction are a rendering error.
- A modulation/interaction connector needs a labeled target on the focal relationship. It must not look like an unlabeled direct effect on the outcome.
- Use text tags such as “hypothesis,” “observed,” “unmeasured mediator,” and “reader reconstruction” for epistemic status. Do not use dashed structural edges for uncertainty when dashes already mean measurement correspondence.

## Exports and inspection

Render the actual SVG with an available renderer; do not create a visually unrelated PNG. Default to a PNG at 2× nominal dimensions. Use explicit dimensions/background and preserve the complete bounds, including legends and source notes. Keep the editable SVG even when PNG is the requested presentation format.

For requested PDF, use vector export through a tool such as Inkscape or browser printing of an SVG sized to one page; verify that print margins do not crop the figure or add unwanted pages. Report any raster-only PDF fallback accurately.

Inspect every output panel at intended placement size. Confirm full labels, legible sources, distinguishable colors/shapes, no overlap or cropping, and correct arrows. Parse SVG as XML and check actual PNG dimensions as lightweight structural checks. Visual inspection remains necessary even when parsing succeeds.

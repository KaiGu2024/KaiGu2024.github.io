# Palettes and identity encoding

Use this reference after naming the color job in `../SKILL.md` §3. Palette definitions and helper functions live in `../scripts/theme_pub.R`; do not duplicate them in project code.

## Contents

1. [Available palette slots](#available-palette-slots)
2. [Categorical comparisons](#categorical-comparisons)
3. [Multi-series lines](#multi-series-lines)
4. [Locked subject identity](#locked-subject-identity)
5. [Sequential magnitude](#sequential-magnitude)
6. [Diverging scales](#diverging-scales)
7. [Conceptual diagrams and CVD checks](#conceptual-diagrams-and-cvd-checks)

## Available palette slots

```r
marks$primary    # deeper blue — lines, points, intervals and data labels
marks$secondary  # deeper green — second series of small marks
brand$primary    # dusty blue — first broad fill, such as a bar or ribbon
brand$secondary  # sage — second broad fill
brand$neutral    # optional neutral area; publication canvas stays white
brand$dark       # near-black — raw observations and axis text
brand$accent     # Hokusai crimson — rare, high emphasis

brand_blues      # Prussian sequential ramp, dark = high; ordered rank only
brand_shapes     # c(21, 24, 22, 23, 25); redundant series identity, max five
series_palette() # choose by group count, geometry and optional contrast scheme
series_muted     # five non-pale colors selected from Paul Tol's muted scheme
series_high_contrast # Paul Tol's three-color scheme for stronger grayscale separation
subject_palette  # eight fixed candidates for recurring subject identity
subject_families # candidates grouped into blue, green, warm, and rose families
subject_ramp()   # subject-anchored rank ramp for one-subject figures
```

## Categorical comparisons

Choose by the area the color occupies. Use `marks$primary` for a single line, coefficient plot or event study, and `brand$primary` for a bar or uncertainty ribbon. Filled point symbols are small marks, despite using the `fill` aesthetic. Keep text on pale fills dark.

For two groups, `series_palette(2, "marks")` gives deeper blue/green; `series_palette(2, "areas")` gives dusty blue/sage. For three to five groups, either geometry selects `series_muted`. Use `series_palette(n, scheme = "high_contrast")` for up to three groups when grayscale separation is especially useful. The stronger categorical colors serve identification; they are not decorative fills. Keep redundant shapes or line patterns, even with these palettes.

The small-mark pair comes from [Paul Tol's bright scheme](https://sronpersonalpages.nl/~pault/); the multi-group palette selects five non-pale members of his muted scheme, and the high-contrast option retains his complete trio. These schemes address color-vision differences and print reproduction. The geometry choices and five-color subset are our house defaults; inspect the actual output rather than treating the palette name as an accessibility pass. Exact values and selection order live only in `theme_pub.R`.

```r
geom_col(fill = brand$primary)
geom_col(aes(fill = group), colour = NA)
geom_line(colour = marks$primary, linewidth = 2.8)
geom_point(colour = marks$primary, size = 9)
```

The shared theme sets discrete `colour` defaults for marks and discrete `fill` defaults for areas. Override `fill` for point symbols to match their lines, as below. For recurring groups, save one named mapping in the project setup and reuse it across figures; do not regenerate assignments from each panel's subset or factor order. Past five series, facet or use layer-and-highlight.

## Multi-series lines

Map the same grouping variable to `colour`, `fill`, and `shape`; the shape is redundant and does not spend another information channel. Use the filled `brand_shapes` set from `theme_pub.R`.

```r
pal <- setNames(series_palette(3, "marks"), c("A", "B", "C"))

geom_line(aes(colour = group), linewidth = 2.8) +
geom_point(aes(fill = group, shape = group),
           size = 9, stroke = 1.0, colour = "white") +
scale_colour_manual(values = pal) +
scale_fill_manual(values = pal) +
scale_shape_manual(values = brand_shapes)
```

For monthly or sparser series, show every marker at `size = 9` on a `2.8` line. For weekly data, use `size = 7` on a `2.4` line and thin markers to every fourth observation plus the last point. At higher cadence, drop markers and distinguish lines with color plus linetype, or facet. See `recipes.md` for complete patterns.

## Locked subject identity

When named entities recur across figures, assign each one a fixed color and redundant shape once per project. Reuse the exact mapping so the reader learns one identity system and the same subject does not drift between colors.

Draw colors from `subject_palette`; do not hand-pick arbitrary hex values. Store the project-specific named mapping in the one shared project setup sourced after `theme_pub.R`.

Existing subject mappings take precedence over new defaults. Do not recolor an established subject when switching from lines to bars or when a panel contains fewer subjects. Inspect light identity colors on white; use a darker outline or redundant shape when needed.

Use fixed colors primarily for highlighted subjects. Keep non-focal series at `grey80` with `grey50` labels. When a figure highlights several subjects, choose one color from each `subject_families` group so hue, rather than a subtle saturation difference, separates them. Saturated colors are allowed for subject identity, but keep decorative and non-subject fills on the muted brand palette.

## Sequential magnitude

Use `brand_blues`, dark = high, for ordered bins where readers compare rank rather than extract precise values.

```r
scale_fill_gradientn(colours = rev(brand_blues))
scale_fill_manual(values = brand_blues)
```

For a rank display about one recurring subject, use `subject_ramp(subject_hex, n)`. It derives dark and light endpoints from that subject's color; check the resulting lightness order and color-vision simulations.

```r
scale_fill_manual(values = subject_ramp(subject_hex, k))
scale_fill_gradientn(colours = rev(subject_ramp(subject_hex)))
```

Do not use a subject ramp for precise magnitude or for a value scale spanning several subjects. Use viridis or cividis for precise magnitude such as heatmaps, choropleths, and density displays; use one neutral ramp for multi-subject values.

```r
scale_fill_viridis_c(option = "viridis", direction = -1)
scale_fill_viridis_c(option = "cividis", direction = -1)
```

Use higher = darker unless the domain requires otherwise. Viridis/cividis default to higher = lighter, so set `direction = -1` for the house orientation. An established figure may retain its disclosed orientation; do not reverse an existing scale silently.

## Diverging scales

Use a diverging scale only for signed coefficients, change from baseline, residuals, or another quantity with a meaningful midpoint. Center white on the meaningful zero and make limits symmetric.

```r
scale_fill_gradient2(
  low = brand_blues[1], mid = "white", high = brand$accent,
  midpoint = 0, limits = c(-x, x)
)
```

Never center the scale on the observed data midpoint when zero is the substantive reference.

## Conceptual diagrams and CVD checks

For conceptual diagrams, use the [conceptual-framework visual specification](../../conceptual-framework/references/visual-spec.md). It owns the semantic shapes, pale fills, darker outlines and text colors. Do not substitute the statistical-series palette for construct/measurement meanings.

Inspect the rendered output in grayscale and under protanopia, deuteranopia, and tritanopia, using [Color Oracle](https://colororacle.org/) or `colorspace` simulations. Convert the actual colors, including fills, outlines and labels; `scale_colour_grey()` replaces the palette and therefore does not test how the original survives grayscale. For multi-series plots, pair color with redundant shape for line-plus-point figures or redundant linetype for line-only figures.

```r
aes(colour = group, fill = group, shape = group)
scale_shape_manual(values = brand_shapes)

aes(colour = group, linetype = group)
scale_linetype_manual(values = c("solid", "dashed", "dotted"))
```

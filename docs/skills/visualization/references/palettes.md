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
brand$primary    # "#6B89A8"  Monet dusty blue — default series
brand$secondary  # "#9CAF88"  Monet sage — second series in a binary comparison
brand$neutral    # "#EFE6D2"  warm cream — backgrounds and neutral areas
brand$dark       # "#1A1A1A"  near-black — raw observations and axis text
brand$accent     # "#A03830"  Hokusai crimson — rare, high emphasis

brand_blues      # Prussian sequential ramp, dark = high; ordered rank only
brand_shapes     # c(21, 24, 22, 23, 25); redundant series identity, max five
subject_palette  # eight fixed candidates for recurring subject identity
subject_families # candidates grouped into blue, green, warm, and rose families
subject_ramp()   # subject-anchored rank ramp for one-subject figures
```

## Categorical comparisons

Use `brand$primary` for a single series. Use the dusty-blue/sage pair for treatment versus control, before versus after, or another binary comparison. Their luminance difference helps the pair survive grayscale and common color-vision deficiencies.

```r
geom_col(fill = brand$primary)
geom_col(aes(fill = group), colour = NA)
geom_line(aes(colour = group), linewidth = 2.8)
geom_point(aes(fill = group, colour = group), shape = 21, size = 9)
```

For three to five equal-weight series, use distinct colors plus redundant shapes. If color would encode a second variable on top of an existing position comparison, facet instead. Past five series, facet or use layer-and-highlight rather than adding another color.

## Multi-series lines

Map the same grouping variable to `colour`, `fill`, and `shape`; the shape is redundant and does not spend another information channel. Use the filled `brand_shapes` set from `theme_pub.R`.

```r
pal <- c(A = brand$primary, B = brand$secondary, C = brand$dark)

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

Use fixed colors primarily for highlighted subjects. Keep non-focal series at `grey80` with `grey50` labels. When a figure highlights several subjects, choose one color from each `subject_families` group so hue, rather than a subtle saturation difference, separates them. Saturated colors are allowed for subject identity, but keep decorative and non-subject fills on the muted brand palette.

## Sequential magnitude

Use `brand_blues`, dark = high, for ordered bins where readers compare rank rather than extract precise values.

```r
scale_fill_gradientn(colours = rev(brand_blues))
scale_fill_manual(values = brand_blues)
```

For a rank display about one recurring subject, use `subject_ramp(subject_hex, n)`. Its vivid identity color anchors a monotonic dark-to-light ramp.

```r
scale_fill_manual(values = subject_ramp(subject_hex, k))
scale_fill_gradientn(colours = rev(subject_ramp(subject_hex)))
```

Do not use a subject ramp for precise magnitude or for a value scale spanning several subjects. Use viridis or cividis for precise magnitude such as heatmaps, choropleths, and density displays; use one neutral ramp for multi-subject values.

```r
scale_fill_viridis_c(option = "viridis")
scale_fill_viridis_c(option = "cividis")
```

Keep the default orientation, higher = darker, unless the domain requires otherwise.

## Diverging scales

Use a diverging scale only for signed coefficients, change from baseline, residuals, or another quantity with a meaningful midpoint. Center white on the meaningful zero and make limits symmetric.

```r
scale_fill_gradient2(
  low = brand$primary, mid = "white", high = brand$secondary,
  midpoint = 0, limits = c(-x, x)
)

scale_fill_gradient2(
  low = "#1F3A5F", mid = "white", high = brand$accent,
  midpoint = 0, limits = c(-x, x)
)
```

Never center the scale on the observed data midpoint when zero is the substantive reference.

## Conceptual diagrams and CVD checks

Use the same brand colors for diagrams. Set box fill to `scales::alpha(brand$primary, 0.3)`, strokes or headers to the full hex with white text, arrows to `grey30`, and only emphasized arrows to `brand$accent`. Cap diagrams at primary plus secondary; distinguish three or more stages by position and labels.

Check live output with [Color Oracle](https://colororacle.org/) under protanopia, deuteranopia, and tritanopia. Check grayscale with `p + scale_colour_grey()`. For three or more line series, pair color with redundant shape for line-plus-point figures or redundant linetype for line-only figures.

```r
aes(colour = group, fill = group, shape = group)
scale_shape_manual(values = brand_shapes)

aes(colour = group, linetype = group)
scale_linetype_manual(values = c("solid", "dashed", "dotted"))
```

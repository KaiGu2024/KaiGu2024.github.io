# Agent Skill: Data Visualization

Principles and code patterns for publication-ready figures in R / ggplot2.

References: [Data Visualization: A Practical Introduction — Kieran Healy](https://socviz.co/) · [Lecture Slides — Yiqing Xu](https://yiqingxu.org/teachings/resources/data_visual.pdf)

---

## Core Principles

1. **Choose the right chart type** for the data relationship (see guide below)
2. **Label directly** — annotate lines/points in place; never add a separate legend box
3. **Use color purposefully** — categorical vs. sequential vs. diverging; always colorblind-safe
4. **Show uncertainty** — always include confidence intervals or error bars
5. **Maximize data-ink ratio** — remove gridlines, borders, and tick marks that add no information
6. **Y-axis starts at baseline** — always begin at 0 (or 100% for indexed series); a truncated axis exaggerates effects

---

## Personal Figure Standards

These rules apply to all figures produced for research:

1. **Tool: R + ggplot2.** Default to ggplot2 for every figure. The grammar-of-graphics composability, `fct_reorder()` for factor axes, ggrepel for non-overlapping labels, and patchwork for multi-panel layouts are non-negotiable for production figures. Do not reach for matplotlib/seaborn unless the figure genuinely cannot be made in ggplot2.
2. **Always sort when ordering is possible.** If a categorical axis has no inherent order (countries, brands, domains, models, conditions), sort by the value being plotted, or by the metric of interest if there are multiple panels. Use `fct_reorder(var, value)` (descending: `fct_reorder(var, value, .desc = TRUE)`). Alphabetical default ordering wastes the strongest pre-attentive channel — position. The only exceptions: time, naturally-ordered categories (Likert scales, age bins), or when a fixed external ordering is the comparison's whole point.
3. **Y-axis baseline**: Start at 0 (or 100 for indexed/normalized series). Only deviate if the entire range of the data is far from zero AND the deviation within the data is the primary story — and always disclose this explicitly.
4. **Direct annotation, no legends**: Label each line or group at its endpoint or most legible point along the curve. A legend box forces the reader's eye to travel; annotation keeps meaning at the data. When mapping a variable to both `x` and `fill`/`color`, suppress the redundant legend with `guides(fill = "none")`.
5. **High DPI**: Save at `dpi = 600` (or as PDF vector). This is the *Science*/*Nature* minimum for revised manuscript submission.
6. **Enlarged components for high DPI**: At 600 DPI, default ggplot font sizes (≈11 pt) and line weights (≈0.5 pt) render too small/thin in print. Bias every visual component upward:
   - Axis titles: 18–20 pt
   - Tick labels: 15–17 pt
   - Inline annotations / direct labels: 14–16 pt
   - Panel title (if needed): 20–22 pt
   - Panel tag (A/B/C): 16–18 pt bold
   - Data lines: 1.0–1.4 pt (`linewidth = 1.0` to `1.4`); reference/zero lines 0.5–0.7 pt
   - Points: `size = 2.5–3.5`
   - Axis lines: `linewidth = 0.6` (not the ggplot default ~0.3)
   - Error-bar / ribbon line: 0.7–0.9 pt; ribbon `alpha = 0.18–0.22`

   When in doubt, go bigger — under-sized text and hairlines are the single most common reason a figure fails review at print resolution.
7. **Thin out dense axis ticks.** When tick labels crowd or overlap, do not shrink the font — drop ticks. Show every 3rd or 6th month for monthly time series, every 5 or 10 years for long horizons, integer years only for daily data, every other category for long ordinal axes. The reader does not need every tick labeled to read the trend; they need the labels they *do* see to be legible.
   - Date axis: `scale_x_date(date_breaks = "3 months", date_labels = "%Y-%m")` (or `"6 months"`, `"1 year"`).
   - Numeric axis: `scale_x_continuous(breaks = scales::pretty_breaks(n = 6))` or an explicit `breaks = seq(min, max, by = 5)`.
   - Categorical axis with many levels: keep all bars, but label only every other one via `scale_x_discrete(breaks = levels[c(TRUE, FALSE)])`, or rotate to horizontal layout so labels have room.
   - Rotation is a last resort: prefer fewer ticks over `angle = 45`. If you must rotate, use `angle = 30` and `hjust = 1`.
8. **Comparisons: plot differences, not raw values, sorted by diff**: When the point is to compare groups or conditions, compute the gap and display it as a single value (e.g., treatment minus control). Sort by the difference so the reader sees the ranking immediately. Showing two bars side by side forces the reader to subtract mentally; showing the diff makes the comparison explicit.
9. **Calculate before you graph.** Pre-aggregate with dplyr, then plot with `stat = "identity"` (`geom_col()`, `geom_line()` on summarized data). Do not rely on geom-side stats (`after_stat(prop)`, `stat_summary`) for anything beyond a quick exploratory pass — they fail in surprising ways with grouped/multi-variable aggregation, and the summary table is itself a useful artifact.

---

## Perception Fundamentals (from socviz.co Ch. 1)

Internalize these once; they decide chart-type choices automatically.

### Cleveland-McGill ranking — accuracy of perceptual tasks (best → worst)

1. Position on a common scale (bar/dot plots with shared baseline)
2. Position on non-aligned scales (small multiples)
3. Length (without baseline)
4. Angle / slope (pie chart, dual-axis)
5. Area (bubble, treemap)
6. Color luminance / saturation
7. Color hue
8. Volume / 3D

**Rule of thumb**: for any quantitative comparison, the encoding should be as high on this list as the data structure allows. Default to bars or dot plots. Never use pie, donut, or 3D for quantitative comparison. Only use area when the message is "rough magnitude" not "precise comparison."

### Channels for unordered categories (best → worst)

Spatial region (facet) → color hue → motion → shape. Reserve hue for categorical distinction; reserve shape only when also using hue (redundant encoding for grayscale fallback).

### Gestalt principles (auto-applied by the viewer's visual system)

Proximity, similarity, connection, continuity, closure, figure/ground, common fate. **Connection and proximity dominate color similarity** — items linked by a line read as a group even if differently colored. Use this deliberately (group structure via spacing/lines) and avoid it accidentally (don't let layout suggest groupings the data doesn't support).

### Pre-attentive channels and channel budget

Color hue and luminance "pop out" before conscious attention; shape, angle, size do not. Search performance collapses when two channels encode information at once. **Hard rule: at most one channel encoding per plot beyond position.** If you find yourself mapping color, shape, and size simultaneously, facet instead.

### The layer-and-highlight pattern

For "this country / domain / firm vs. all others" comparisons:

1. Plot all data in light gray as background.
2. Plot the focal subset on top, in a saturated color.
3. Label only the focal subset.

This is more effective than a 20-color rainbow and survives B&W printing.

---

## Chart Type Guide

| Relationship                  | Chart                            |
|-------------------------------|----------------------------------|
| Distribution (one var)        | Histogram, density, violin       |
| Distribution (compare groups) | Ridge plot, overlaid density     |
| Two continuous vars           | Scatter, hexbin (large N)        |
| Category vs. continuous       | Bar/dot (mean ± CI), strip + box |
| Time series                   | Line with shaded CI              |
| Correlation matrix            | Heatmap                          |
| Causal estimate               | Coefficient plot (dot + CI)      |
| Geographic                    | Choropleth                       |

---

## ggplot2 Setup (600 DPI Standard)

```r
library(ggplot2)
library(dplyr)
library(forcats)
library(ggrepel)
library(patchwork)
library(scales)

theme_pub <- function(base_size = 16) {
  theme_minimal(base_size = base_size, base_family = "Helvetica") +
    theme(
      axis.title       = element_text(size = 19),
      axis.text        = element_text(size = 16),
      plot.title       = element_text(size = 21, face = "bold"),
      plot.tag         = element_text(size = 17, face = "bold"),
      panel.grid.minor = element_blank(),
      panel.grid.major = element_line(linewidth = 0.4, colour = "grey85"),
      panel.border     = element_blank(),
      axis.line        = element_line(linewidth = 0.6, colour = "grey20"),
      axis.ticks       = element_line(linewidth = 0.5, colour = "grey20"),
      strip.text       = element_text(size = 16, face = "bold"),
      legend.position  = "none"   # direct annotation by default
    )
}
theme_set(theme_pub())

# Okabe-Ito colorblind-safe palette
okabe_ito <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442",
               "#0072B2", "#D55E00", "#CC79A7", "#000000")
options(ggplot2.discrete.colour = okabe_ito,
        ggplot2.discrete.fill   = okabe_ito)
```

---

## Sorting Categorical Axes (always)

```r
# Bar/dot plot sorted by value, horizontal for long labels
df |>
  mutate(domain = fct_reorder(domain, share)) |>
  ggplot(aes(x = share, y = domain)) +
  geom_col(fill = "#0072B2") +
  scale_x_continuous(labels = label_percent(accuracy = 1),
                     expand = expansion(mult = c(0, 0.05))) +
  labs(x = "Referral share", y = NULL)

# Faceted: order facets by an aggregate, order bars within facet by value
df |>
  mutate(
    platform = fct_reorder(platform, value, .fun = sum, .desc = TRUE),
    domain   = reorder_within(domain, value, platform)   # tidytext::reorder_within
  ) |>
  ggplot(aes(x = value, y = domain)) +
  geom_col() +
  facet_wrap(~ platform, scales = "free_y") +
  tidytext::scale_y_reordered()
```

---

## Thinning Dense Axes

```r
# Time series — show one tick per quarter or half-year, not every month
ggplot(df, aes(x = date, y = value)) +
  geom_line(linewidth = 1.2) +
  scale_x_date(date_breaks = "3 months", date_labels = "%Y-%m",
               expand = expansion(mult = c(0.02, 0.05)))

# Long horizon — every 5 years
scale_x_date(date_breaks = "5 years", date_labels = "%Y")

# Numeric — pretty breaks targeting ~6 ticks
scale_x_continuous(breaks = scales::pretty_breaks(n = 6))

# Categorical — label every other level when there are many
lv <- levels(df$category)
scale_x_discrete(breaks = lv[c(TRUE, FALSE)])
```

If labels still overlap after thinning, prefer flipping to a horizontal bar layout (`coord_flip()` or swap `x`/`y` aesthetics) over rotating axis text.

---

## Direct Line Annotation (no legend)

```r
library(ggrepel)

# Pick label position per group: usually the rightmost x
labels <- df |>
  group_by(group) |>
  slice_max(year, n = 1) |>
  ungroup()

ggplot(df, aes(x = year, y = outcome, colour = group)) +
  geom_line(linewidth = 0.9) +
  geom_text_repel(
    data           = labels,
    aes(label = group),
    hjust          = 0,
    nudge_x        = 0.2,
    direction      = "y",
    segment.colour = NA,
    size           = 4
  ) +
  scale_y_continuous(labels = label_percent(accuracy = 1)) +
  scale_x_continuous(expand = expansion(mult = c(0.02, 0.15))) +
  labs(x = "Year", y = "Outcome")
```

---

## Coefficient / Event-Study Plot

```r
es <- tibble(
  period = -4:4,
  coef   = c(...),
  lo     = c(...),
  hi     = c(...)
)

ggplot(es, aes(x = period, y = coef)) +
  geom_hline(yintercept = 0, linewidth = 0.4) +
  geom_vline(xintercept = -0.5, linetype = "dashed",
             colour = "#D55E00", linewidth = 0.4) +
  annotate("text", x = -0.5 + 0.1, y = Inf, vjust = 1.3,
           label = "Event", colour = "#D55E00", size = 3.5, hjust = 0) +
  geom_ribbon(aes(ymin = lo, ymax = hi), alpha = 0.18, fill = "#0072B2") +
  geom_line(linewidth = 0.8, colour = "#0072B2") +
  geom_point(size = 2.2, colour = "#0072B2") +
  labs(x = "Periods relative to treatment", y = "Estimated effect")
```

---

## Distribution Comparisons (ridge plot)

```r
library(ggridges)

df |>
  mutate(group = fct_reorder(group, value, median)) |>
  ggplot(aes(x = value, y = group, fill = group)) +
  geom_density_ridges(alpha = 0.7, scale = 1.0,
                      rel_min_height = 0.01, colour = "white") +
  labs(x = "Value", y = NULL) +
  guides(fill = "none")
```

---

## Layer-and-Highlight (focal comparison)

```r
focal <- c("ChatGPT", "Claude")

ggplot(df, aes(x = week, y = visits, group = platform)) +
  geom_line(data = filter(df, !platform %in% focal),
            colour = "grey80", linewidth = 0.4) +
  geom_line(data = filter(df,  platform %in% focal),
            aes(colour = platform), linewidth = 1.0) +
  geom_text_repel(
    data = filter(df, platform %in% focal) |>
             group_by(platform) |> slice_max(week, n = 1),
    aes(label = platform, colour = platform),
    hjust = 0, nudge_x = 1, direction = "y", segment.colour = NA
  ) +
  scale_x_continuous(expand = expansion(mult = c(0.02, 0.12))) +
  labs(x = "Week", y = "Visits")
```

---

## Color Palettes

```r
# Categorical (Okabe-Ito, set globally above)
scale_colour_manual(values = okabe_ito)

# Sequential — for ordered/continuous magnitudes
scale_fill_viridis_c(option = "viridis")
scale_fill_distiller(palette = "Blues", direction = 1)

# Diverging — only when the variable has a meaningful midpoint (e.g., 0)
scale_fill_distiller(palette = "RdBu", direction = -1, limits = c(-x, x))

# Warm accent palette (Anthropic-style)
WARM <- c("#c96442", "#e8b89a", "#1a1a1a", "#7a706b", "#e6ddd6")
```

**Critical rule** (Healy): match the palette's structure to the variable's structure. Never map a sequential variable to a categorical palette, or use a diverging palette for a variable with no defined midpoint.

**Colorblind & B&W test**: check every figure with [Color Oracle](https://colororacle.org/), and convert to grayscale (`ggplot2::scale_colour_grey()` proof) before submission. INFORMS journals print B&W: pair color with linetype variation (`solid`, `dashed`, `dotted`) when distinguishing series matters.

---

## Multi-Panel Layout (patchwork)

```r
library(patchwork)

(p1 | p2) / p3 +
  plot_layout(heights = c(2, 1), axes = "collect") +
  plot_annotation(tag_levels = "A",
                  theme = theme(plot.tag = element_text(face = "bold", size = 14)))
```

`axes = "collect"` deduplicates shared axes; `tag_levels = "A"` adds journal-style A/B/C panel labels.

---

## Journal Standards Reference

From *Science* (AAAS) revised manuscript guidelines:

- **DPI**: 300–600 minimum; vector formats (PDF, EPS, AI) preferred
- **Font**: Sans-serif only (Helvetica / Arial); no Symbol fonts
- **Label size**: 7–8 pt in the *final printed figure* — scale up proportionally for high-DPI exports
- **Line weight**: Avoid hairlines; minimum ~0.5 pt; prefer 1 pt for data lines
- **Direct annotation preferred**: "Remove unnecessary labels from the figure itself; explain in the caption"
- **Panel labels**: uppercase A, B, C at upper-left; 10–12 pt bold

From *Marketing Science* / *Management Science* (INFORMS):

- **DPI**: 300 minimum for photos; supply graphs as vector if possible
- **Grayscale test**: Figures publish in color online but must convert cleanly to B&W for print; use line-style variation (solid, dashed, dotted) in addition to color
- **Colorblind palette**: Okabe-Ito (categorical) or Viridis family (sequential/diverging)

---

## Saving for Publication

```r
# PDF (vector — for LaTeX, preferred by journals)
ggsave("figure.pdf", plot = p, width = 7, height = 4, units = "in", device = cairo_pdf)

# PNG / TIFF at 600 DPI (for journal submission portals)
ggsave("figure.png",  plot = p, width = 7, height = 4, units = "in", dpi = 600)
ggsave("figure.tiff", plot = p, width = 7, height = 4, units = "in", dpi = 600,
       compression = "lzw")

# All three at once
for (ext in c("pdf", "png", "tiff")) {
  ggsave(sprintf("figure.%s", ext), plot = p,
         width = 7, height = 4, units = "in", dpi = 600)
}
```

Specify `width` / `height` explicitly — letting ggsave guess from the active device locks in the wrong physical size for fonts and line weights.

---

## Report

See [Report format](report.md).

**Definition (measure):** Figures produced (count, types, output paths); format and DPI; whether colorblind/grayscale check was run; whether categorical axes were sorted by value.  
**Analyses:** Chart types chosen and rationale (Cleveland-McGill justification); annotation strategy (direct vs. legend); journal standard compliance (DPI, font, line weight).  
**Takeaway:** Visual message conveyed; any deviations from personal figure standards or journal requirements that require human sign-off.

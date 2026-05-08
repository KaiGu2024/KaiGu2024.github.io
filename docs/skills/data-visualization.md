---
name: data-visualization
description: Use when producing publication-ready figures in R + ggplot2 — Cleveland-McGill perceptual ranking, Okabe-Ito colorblind-safe palette, direct annotation over legend boxes, 600 DPI output for journal submission, multi-panel patchwork layouts. Enforces personal figure standards (always sort categorical axes, plot differences not raw values, calculate before you graph). For journal-formatted regression tables, see tables.md.
allowed-tools: Read, Edit, Write, Bash
invocation: auto
---

## Personal Figure Standards

These rules apply to all figures produced for research:

1. **Tool: R + ggplot2.** Default to ggplot2 for every figure. The grammar-of-graphics composability, `fct_reorder()` for factor axes, ggrepel for non-overlapping labels, and patchwork for multi-panel layouts are non-negotiable for production figures. Do not reach for matplotlib/seaborn unless the figure genuinely cannot be made in ggplot2.
2. **Always sort when ordering is possible.** If a categorical axis has no inherent order (countries, brands, domains, models, conditions), sort by the value being plotted, or by the metric of interest if there are multiple panels. Use `fct_reorder(var, value)` (descending: `fct_reorder(var, value, .desc = TRUE)`). Alphabetical default ordering wastes the strongest pre-attentive channel — position. The only exceptions: time, naturally-ordered categories (Likert scales, age bins), or when a fixed external ordering is the comparison's whole point.
3. **Y-axis range.**
   - **Lower bound:** Start at 0 (or 100 for indexed/normalized series). Only deviate if the entire range of the data is far from zero AND the deviation within the data is the primary story — and always disclose this explicitly.
   - **Upper bound:** Let ggplot's default 5% expansion handle headroom for unbounded metrics — do not pad to a round number (`0–80` for `50–60` data adds dead space that under-sells the level). For bounded metrics (percent, share, normalized score, Likert), set the axis to the **cap** (100, 1.0, 5, 7) regardless of data range, so the reader can see where values sit on the full scale.
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
10. **Brief titles; no cross-panel overlap.** Axis titles, plot titles, and facet strip text should be the shortest phrasing that names what is on the axis or in the panel — 1–4 words plus units (`Loan amount ($, log)`, not `Loan amount in dollars (logarithmic scale)`). Long titles waste plot area, force the reader to read prose mid-figure, and in multi-panel layouts run into neighboring panels.
    - Pre-export, render at the final export width and inspect strip-text and axis-title boundaries between panels — `patchwork` and `facet_wrap` do not auto-resolve title overflow.
    - If titles still collide: shorten further; drop redundant y-axis titles from non-leftmost panels (`labs(y = NULL)`); share axes via `plot_layout(axes = "collect")`; rotate to a horizontal layout when category labels are too wide; or move secondary information into the figure caption rather than the title.
11. **Show uncertainty.** Always include confidence intervals or error bars on inferential plots — a ribbon (`geom_ribbon` at `alpha = 0.18–0.22`) for continuous coverage, an error bar for discrete points. A point estimate without uncertainty conveys false precision.
12. **Maximize data-ink ratio.** Remove gridlines, borders, and tick marks that add no information (Tufte). The default `theme_pub()` below already drops minor gridlines and the panel border; resist re-adding them.

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

**Greek and math symbols.** Use Unicode characters directly in axis labels, annotations, and titles — `α`, `β`, `μ`, `σ²`, `≥`, `×` — never Symbol-font glyphs, which render as tofu in modern PDF readers and fail journal preflight. ggplot2 + Helvetica handles Unicode without configuration; just paste the character.

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

### Color does four jobs

Before picking a palette, name what color is for in this figure. The palette family follows from the job. A sequential palette mapped to categories obscures the categories; a categorical palette mapped to a magnitude misleads about ordering.

| Job | When | Palette family |
|---|---|---|
| **Identification** — distinguish unordered categories | Treatment vs. control, platform A vs. B | Categorical (Okabe-Ito) |
| **Magnitude** — encode an ordered/continuous value | Choropleth, heatmap, density | Sequential (viridis, Blues) |
| **Signed deviation** — encode +/− around a midpoint | Coefficient vs. baseline, residual map | Diverging (RdBu, Purple-Green) |
| **Emphasis** — focus one series, fade others | "ChatGPT vs. all platforms" | Layer-and-highlight (gray + accent) |

### Categorical — Okabe-Ito with discipline

The 8-color Okabe-Ito palette is the gold standard. Set globally in `theme_pub()` above; use it for every categorical mapping.

```r
okabe_ito <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442",
               "#0072B2", "#D55E00", "#CC79A7", "#000000")
```

**Two-group canonical pair: orange `#E69F00` + blue `#0072B2`.** *The* default for treatment vs. control, before vs. after, fintech vs. bank, and any binary comparison. High **luminance** contrast (survives grayscale) and high **hue** contrast (survives protanopia / deuteranopia / tritanopia). Use this pair unless you have a strong reason not to.

```r
scale_colour_manual(values = c(treatment = "#E69F00", control = "#0072B2"))
```

**Single-series default: blue `#0072B2`.** When only one color is needed (single line, single bar series, one density), use the Okabe-Ito blue everywhere — not `steelblue`, not the ggplot2 default, not arbitrary hex. Consistency across the figures in one paper is itself a reading aid.

**Five-category ceiling.** Distinguishability collapses past 5 categorical colors. Above 5, switch to facet or layer-and-highlight. When 3–4 suffice, the *R Journal* 2023 recommendation is to use the **first four Okabe-Ito colors** (orange, sky blue, bluish green, yellow-with-border).

**Known weaknesses to design around:**

- `#F0E442` (yellow) is nearly invisible on white — use **only for fills with borders**, never for lines or thin marks.
- `#000000` (black) clashes with axis lines — drop it from the active palette unless used for a single highlighted "headline" series.
- The two oranges (`#E69F00` light + `#D55E00` vermillion) confuse for protanopia. **Don't pair them as the two main categories** — choose orange + blue or blue + green instead.
- Avoid red + green combinations (8% of men, 0.5% of women have red-green CVD) regardless of palette.

### Sequential — viridis (default) or Blues

For ordered / continuous magnitudes:

```r
scale_fill_viridis_c(option = "viridis")                  # perceptually uniform default
scale_fill_viridis_c(option = "cividis")                  # blue-yellow, max colorblind safety
scale_fill_distiller(palette = "Blues", direction = 1)    # higher value → darker
```

Viridis has **monotonic luminance** (equal data distance → equal perceived distance), is colorblind-safe across all three deficiency types, and converts cleanly to grayscale. `rainbow()`, `heat.colors()`, and matplotlib's `jet` violate all three — never use them. ColorBrewer's HCL palettes are sometimes recommended but are *not always* colorblind-safe (*R Journal* 2023); default to viridis when in doubt.

`direction = 1` makes higher values darker — the printed-figure convention. Don't flip it without reason.

### Diverging — only with a meaningful midpoint

Use a diverging palette only when the variable has a **defined zero or baseline**: signed coefficient, percent change relative to control, residual, deviation from a target.

```r
scale_fill_gradient2(low = "#762A83", mid = "white", high = "#1B7837",
                     midpoint = 0, limits = c(-x, x))      # Purple-Green, accessible
scale_fill_distiller(palette = "RdBu", direction = -1, limits = c(-x, x))
```

**The midpoint must be the meaningful zero, not the data midpoint.** Symmetric `limits = c(-x, x)` keeps the white center aligned with zero.

### Colorblind check

Live simulation: [Color Oracle](https://colororacle.org/) (free, all OS) — flick through protanopia / deuteranopia / tritanopia views and confirm the message survives. Static grayscale proof:

```r
p + scale_colour_grey()
```

When color alone is fragile (more than two series, anticipated grayscale printing, accessibility audit), **pair color with linetype or shape**:

```r
# Lines — pair color with linetype
aes(colour = group, linetype = group)
scale_linetype_manual(values = c("solid", "dashed", "dotted"))

# Points — pair color with shape
aes(colour = group, shape = group)
```

The orange + blue pair survives grayscale on its own; a third or fourth series almost certainly will not — pair channels above N = 2.

---

## Multi-Panel Layout (patchwork)

```r
library(patchwork)

(p1 | p2) / p3 +
  plot_layout(heights = c(2, 1), axes = "collect") +
  plot_annotation(tag_levels = "A",
                  theme = theme(plot.tag = element_text(face = "bold", size = 17)))
```

`axes = "collect"` deduplicates shared axes. `tag_levels = "A"` produces **uppercase** A/B/C panel labels — the journal-required form. Tag size 17 pt bold matches Personal Figure Standards #6 (panel tag 16–18 pt bold at export DPI).

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

## Tables

For regression / descriptive tables — journal-specific star cutoffs, booktabs templates, the never-change-a-number rule — see the sibling skill: [tables.md](tables.md).

---

## Report

See [Report format](report.md).

**Definition (measure):** Figures produced (count, types, output paths); format and DPI; whether colorblind/grayscale check was run; whether categorical axes were sorted by value.  
**Analyses:** Chart types chosen and rationale (Cleveland-McGill justification); annotation strategy (direct vs. legend); journal standard compliance (DPI, font, line weight).  
**Takeaway:** Visual message conveyed; any deviations from personal figure standards or journal requirements that require human sign-off.

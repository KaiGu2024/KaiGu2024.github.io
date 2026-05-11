---
name: visualization
description: Use when producing publication-ready figures in R + ggplot2 — Cleveland-McGill perceptual ranking; a tight Monet/Hokusai-inspired brand palette (dusty blue + sage canonical pair on warm cream, Hokusai-Prussian sequential ramp, viridis for precise magnitudes, crimson accent for emphasis); five-element title/axis/strip hierarchy with axis-title floor 3 words + unit; direct annotation over legends; 600 DPI output. Enforces personal figure standards (sort categorical axes, plot differences not raw, calculate before you graph). For regression tables, see tables.md.
allowed-tools: Read, Edit, Write, Bash
invocation: auto
---

## Contents

1. [Standards](#1-standards) — the 12 rules every figure must obey
2. [Perception](#2-perception) — Cleveland-McGill, channel budget, layer-and-highlight
3. [Decisions](#3-decisions) — pick the chart type, name the color job
4. [Setup](#4-setup) — `theme_pub()` and the brand palette
5. [Palettes](#5-palettes) — categorical, sequential, diverging, layer-and-highlight, CVD
6. [Recipes](#6-recipes) — copy-pasteable code
7. [Output](#7-output) — patchwork, ggsave at 600 DPI
8. [Cross-references](#8-cross-references)

---

## 1. Standards

1. **Tool: R + ggplot2.** Default to ggplot2. Reach for matplotlib/seaborn only if the figure genuinely cannot be made in ggplot2.

2. **Sort categorical axes by value.** No inherent order (countries, brands, models, conditions) → `fct_reorder(var, value)` (descending: `.desc = TRUE`). Alphabetical wastes the strongest pre-attentive channel — position. Exceptions: time, naturally-ordered categories (Likert, age bins), or a fixed external ordering that is itself the comparison.

3. **Y-axis range.** Lower bound: start at 0 (or 100 for indexed series); deviate only if the entire range is far from zero AND within-data variation is the story — disclose explicitly. Upper bound: for unbounded metrics, let ggplot's 5% expansion handle headroom (don't pad to round numbers); for bounded metrics (percent, share, Likert), set the axis to the cap (100, 1.0, 5, 7) regardless of data range.

4. **Direct annotation, no legends.** Label each line/group at its endpoint or most legible point. Suppress redundant guides with `guides(fill = "none")` when a variable is mapped to both `x` and `fill`/`color`.

5. **High DPI.** `dpi = 600` (or PDF vector). *Science*/*Nature* minimum at submission.

6. **Enlarged components for high DPI.** Default ggplot fonts (~11 pt) and lines (~0.5 pt) print too thin at 600 DPI:
   - Axis titles 18–20 pt; tick labels 15–17 pt; inline labels 14–16 pt
   - Panel title 20–22 pt; subtitle 16–18 pt grey30; tag (A/B/C) 16–18 pt bold; caption 12–14 pt grey40
   - Data lines `linewidth = 1.0–1.4`; reference/zero lines 0.5–0.7; axis lines 0.6
   - Points `size = 2.5–3.5`; ribbon `alpha = 0.18–0.22`

7. **Thin out dense axis ticks.** Crowded labels → drop ticks, don't shrink fonts. Date: `scale_x_date(date_breaks = "3 months", date_labels = "%Y-%m")`. Numeric: `scales::pretty_breaks(n = 6)`. Categorical: label every other level, or rotate to horizontal layout. Rotation is last resort — `angle = 30, hjust = 1` if you must.

8. **Plot differences, not raw values.** Compute the gap (treatment − control) and plot one value per group, sorted by the difference. Two side-by-side bars force mental subtraction; the diff makes the comparison explicit.

9. **Calculate before you graph.** Pre-aggregate with dplyr, plot with `stat = "identity"`. Geom-side stats (`after_stat(prop)`, `stat_summary`) fail in surprising ways with grouped/multi-variable aggregation; the summary table is itself a useful artifact.

10. **Title and label hierarchy.** Five text layers, each with a distinct purpose. **Default — minimum required: axis titles only.** Add the rest only when context demands it.

    | Element | Required? | Word budget | When | Example |
    |---|---|---|---|---|
    | Axis title | **Always** | 3–6 words + units | Every figure. Self-contained. | `Mortgage loan amount ($, log)` |
    | Facet strip | When faceting | 1–3 words | Auto-generated; keep short. | `North America` |
    | Plot title | Skip by default | 4–8 words | Standalone (slide, blog) only. | `Loan demand fell after the 2023 reform` |
    | Plot subtitle | Skip by default | 6–12 words | Standalone + in-figure context. | `DiD, US private banks, 2018–2024` |
    | Caption | Submission only | 2–6 sentences | LaTeX `\caption{}` only. | — |

    Two failure modes: **over-condensed axis titles** (`Amount`, `Year`) under 3 words / no unit; **title-as-caption** stuffing sample/period detail into the title when LaTeX renders a full caption. Keep title to the finding; let caption carry methodology.

    Cross-panel overlap: render at export width before saving; drop redundant y-titles from non-leftmost panels (`labs(y = NULL)`); share axes via `plot_layout(axes = "collect")`. Shortening below the 3-word floor is not a valid resolution — fix the layout.

11. **Show uncertainty.** Confidence intervals always — `geom_ribbon(alpha = 0.18–0.22)` for continuous, error bars for discrete. Point estimates without uncertainty convey false precision.

12. **Maximize data-ink ratio.** Drop minor gridlines, panel border, redundant ticks (Tufte). Major gridlines stay faint (`grey85`, `linewidth 0.4`); axis lines and ticks at labeled values stay. `theme_pub()` (§4) implements this.

---

## 2. Perception

### Cleveland-McGill — accuracy of perceptual tasks (best → worst)

1. Position on a common scale (bar/dot, shared baseline)
2. Position on non-aligned scales (small multiples)
3. Length without baseline
4. Angle / slope (pie, dual-axis)
5. Area (bubble, treemap)
6. Color luminance / saturation
7. Color hue
8. Volume / 3D

Default to bars or dot plots for quantitative comparison. Never pie, donut, 3D. Use area only when the message is "rough magnitude," not precise comparison.

### Channels for unordered categories (best → worst)

Spatial region (facet) → color hue → motion → shape. Reserve hue for categorical distinction; reserve shape only for redundant encoding (grayscale fallback).

### Channel budget

Color and luminance pop pre-attentively; shape, angle, size do not. **Hard rule: at most one channel encoding beyond position.** If you find yourself mapping color + shape + size, facet instead.

### Gestalt — connection and proximity dominate color similarity

Items linked by a line read as a group even if differently colored. Use deliberately (group structure via spacing/lines); avoid accidentally (don't let layout suggest groupings the data doesn't support).

### Layer-and-highlight pattern

For "this country/firm/domain vs. all others": plot all data in `grey80`, plot focal subset on top in saturated accent, label only the focal subset. More effective than a 20-color rainbow; survives B&W. Code in §6.

---

## 3. Decisions

### Chart type

| Relationship | Chart |
|---|---|
| Distribution (one var) | Histogram, density, violin |
| Distribution (compare groups) | Ridge, overlaid density |
| Two continuous vars | Scatter, hexbin (large N) |
| Category vs. continuous | Bar/dot (mean ± CI), strip + box |
| Time series | Line with shaded CI |
| Time series + fitted models | Black raw line + linetype-distinguished fits + grey CI |
| Correlation matrix | Heatmap |
| Causal estimate | Coefficient plot (dot + CI) |
| Geographic | Choropleth |

### Color job

Name what color is *for* before picking a palette.

| Job | When | Palette |
|---|---|---|
| **Identification** | Treatment vs. control | Brand pair (`#6B89A8` + `#9CAF88`) |
| **Magnitude (rank)** | Sorted bars colored by tertile | Brand sequential ramp |
| **Magnitude (precise)** | Choropleth, heatmap, density | Viridis |
| **Signed deviation** | Coefficient vs. baseline, residual | Diverging |
| **Emphasis** | "ChatGPT vs. all platforms" | Layer-and-highlight (gray + accent) |

---

## 4. Setup

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
      plot.subtitle    = element_text(size = 17, colour = "grey30",
                                      margin = margin(t = 2, b = 8)),
      plot.caption     = element_text(size = 13, colour = "grey40",
                                      hjust = 0, margin = margin(t = 8)),
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

# Brand palette — Monet Water Lilies + Hokusai crimson.
# Pick by role; same hex serves as fill or stroke; tint with scales::alpha().
brand <- list(
  primary   = "#6B89A8",  # Monet dusty blue   — default series, single-series fills
  secondary = "#9CAF88",  # Monet sage green   — second series in 2-group comparisons
  neutral   = "#EFE6D2",  # warm cream         — backgrounds, "all others"
  dark      = "#1A1A1A",  # near-black         — raw observed lines, axis text
  accent    = "#A03830"   # Hokusai crimson    — rare, single high-emphasis callout
)

# Sequential ramp — Hokusai-Prussian blues (5 steps, dark = high). Use for
# ORDERED bins where rank matters but not precise magnitude. For precise
# magnitude (heatmap, choropleth) use viridis.
brand_blues <- c("#1F3A5F", "#3A5F87", "#6688AB", "#9DBBD2", "#D2DDE6")

options(ggplot2.discrete.fill   = c(brand$primary, brand$secondary),
        ggplot2.discrete.colour = c(brand$primary, brand$secondary))
```

**Greek and math symbols.** Use Unicode directly in labels: `α`, `β`, `μ`, `σ²`, `≥`, `×`. Symbol-font glyphs tofu in modern PDF readers.

---

## 5. Palettes

### Categorical — 2-group brand pair

`#6B89A8` (Monet dusty blue) + `#9CAF88` (Monet sage). ~12% luminance gap (sage lighter) carries grayscale and CVD. Default for treatment vs. control, before/after, any binary comparison.

```r
# Bars / boxes / ribbons / filled shapes
geom_col(aes(fill = group), colour = NA)

# Single-series default — primary blue
geom_col(fill = brand$primary)

# Lines
geom_line(aes(colour = group), linewidth = 1.0)

# Filled points (pch 21–25) — same hex as fill and stroke
geom_point(aes(fill = group, colour = group), shape = 21, size = 2.8)
```

**Three or more categories: don't add a third color — facet or layer-and-highlight.** The brand caps at 2 because that's where 2-channel comparisons (color × position) work cleanly. For 3+, position becomes the primary distinguisher (facet); color encodes a second dimension only.

### Sequential — rank vs. precise

**Branded ramp — rank only.** `brand_blues`, dark = high. For ordered discrete bins where readers compare ranks, not extract precise numbers.

```r
scale_fill_gradientn(colours = rev(brand_blues))   # continuous
scale_fill_manual(values = brand_blues)            # discrete, ≤5 bins
```

**Viridis — precise magnitude.** When readers extract numeric values (heatmap, choropleth, density). Perceptually uniform, CVD-safe, grayscale-clean.

```r
scale_fill_viridis_c(option = "viridis")
scale_fill_viridis_c(option = "cividis")    # max CVD safety
```

`direction = 1` (default) → higher = darker. Don't flip without reason.

### Diverging — only with a meaningful midpoint

For signed coefficients, percent change vs. baseline, residuals, deviations from a target.

```r
# Soft — primary blue ↔ secondary sage
scale_fill_gradient2(low = brand$primary, mid = "white", high = brand$secondary,
                     midpoint = 0, limits = c(-x, x))

# High-contrast — Prussian dark ↔ crimson accent
scale_fill_gradient2(low = "#1F3A5F", mid = "white", high = brand$accent,
                     midpoint = 0, limits = c(-x, x))
```

**The midpoint must be the meaningful zero, not the data midpoint.** Symmetric `limits = c(-x, x)` keeps white centered on zero.

### Layer-and-highlight — focal series in crimson

```r
focal <- c("ChatGPT")

ggplot(df, aes(x = week, y = visits, group = platform)) +
  geom_line(data = filter(df, !platform %in% focal),
            colour = "grey80", linewidth = 0.4) +
  geom_line(data = filter(df,  platform %in% focal),
            colour = brand$accent, linewidth = 1.0) +
  geom_text_repel(
    data = filter(df, platform %in% focal) |>
             group_by(platform) |> slice_max(week, n = 1),
    aes(label = platform), colour = brand$accent,
    hjust = 0, nudge_x = 1, direction = "y", segment.colour = NA
  ) +
  scale_x_continuous(expand = expansion(mult = c(0.02, 0.12))) +
  labs(x = "Week", y = "Visits")
```

For two focal series, use `brand$primary` and `brand$accent` against `grey80`.

### Conceptual diagrams

Same brand colors. Box fill: `scales::alpha(brand$primary, 0.3)`. Box stroke / header strip: full hex with white text. Arrows: `grey30` default; `brand$accent` if the arrow itself encodes emphasis. Diagrams cap at primary + secondary; for 3+ stages distinguish by *position and label*, not color.

### Colorblind check

Live: [Color Oracle](https://colororacle.org/) — flick through protanopia / deuteranopia / tritanopia. Static grayscale: `p + scale_colour_grey()`.

The brand pair survives grayscale (luminance gap). For 3+ series, pair color with linetype or shape:

```r
aes(colour = group, linetype = group)
scale_linetype_manual(values = c("solid", "dashed", "dotted"))
```

---

## 6. Recipes

Code assumes `theme_pub()` and the `brand` palette from §4 are loaded.

### Sorting categorical axes

```r
# Bar plot sorted by value, horizontal layout for long labels
df |>
  mutate(domain = fct_reorder(domain, share)) |>
  ggplot(aes(x = share, y = domain)) +
  geom_col(fill = brand$primary) +
  scale_x_continuous(labels = label_percent(accuracy = 1),
                     expand = expansion(mult = c(0, 0.05))) +
  labs(x = "Referral share", y = NULL)

# Faceted: order facets by aggregate, order bars within facet by value
df |>
  mutate(
    platform = fct_reorder(platform, value, .fun = sum, .desc = TRUE),
    domain   = tidytext::reorder_within(domain, value, platform)
  ) |>
  ggplot(aes(x = value, y = domain)) +
  geom_col(fill = brand$primary) +
  facet_wrap(~ platform, scales = "free_y") +
  tidytext::scale_y_reordered()
```

### Thinning dense axes

```r
scale_x_date(date_breaks = "3 months", date_labels = "%Y-%m",
             expand = expansion(mult = c(0.02, 0.05)))
scale_x_date(date_breaks = "5 years", date_labels = "%Y")
scale_x_continuous(breaks = scales::pretty_breaks(n = 6))

# Categorical — label every other level
lv <- levels(df$category)
scale_x_discrete(breaks = lv[c(TRUE, FALSE)])
```

If labels still overlap after thinning, flip to horizontal before rotating axis text.

### Direct line annotation

```r
labels <- df |> group_by(group) |> slice_max(year, n = 1) |> ungroup()

ggplot(df, aes(x = year, y = outcome, colour = group)) +
  geom_line(linewidth = 0.9) +
  geom_text_repel(
    data = labels, aes(label = group),
    hjust = 0, nudge_x = 0.2, direction = "y",
    segment.colour = NA, size = 4
  ) +
  scale_y_continuous(labels = label_percent(accuracy = 1)) +
  scale_x_continuous(expand = expansion(mult = c(0.02, 0.15))) +
  labs(x = "Year", y = "Outcome")
```

### Coefficient / event-study plot

```r
ggplot(es, aes(x = period, y = coef)) +
  geom_hline(yintercept = 0, linewidth = 0.4) +
  geom_vline(xintercept = -0.5, linetype = "dashed",
             colour = brand$accent, linewidth = 0.4) +
  geom_ribbon(aes(ymin = lo, ymax = hi),
              fill = brand$primary, alpha = 0.22) +
  geom_line(linewidth = 0.8, colour = brand$primary) +
  geom_point(size = 2.6, colour = brand$primary) +
  labs(x = "Periods relative to treatment", y = "Estimated effect")
```

### Time trend with overlaid fits (raw + models + CI)

Three weights: raw series in `brand$dark` at `linewidth = 0.45` (reference); fitted lines distinguished primarily by **linetype** (so the figure reads in grayscale), secondary by hue, at `linewidth = 1.0`; one CI ribbon for the primary fit (`fill = "grey70", alpha = 0.25`).

```r
ggplot(df, aes(x = year, y = value)) +
  geom_ribbon(data = filter(df, series == "loess"),
              aes(ymin = lo, ymax = hi),
              fill = "grey70", alpha = 0.25, colour = NA) +
  geom_line(data = filter(df, series == "raw"),
            colour = brand$dark, linewidth = 0.45) +
  geom_line(data = filter(df, series != "raw"),
            aes(linetype = series, colour = series),
            linewidth = 1.0) +
  scale_linetype_manual(values = c(linear = "dashed",
                                   loess  = "solid",
                                   poly   = "dotted")) +
  scale_colour_manual(values = c(linear = brand$primary,
                                 loess  = brand$secondary,
                                 poly   = brand$accent)) +
  geom_text_repel(
    data = filter(df, series != "raw") |>
             group_by(series) |> slice_max(year, n = 1),
    aes(label = series, colour = series),
    hjust = 0, nudge_x = 1, direction = "y",
    segment.colour = NA, size = 4
  ) +
  scale_x_continuous(expand = expansion(mult = c(0.02, 0.15))) +
  labs(x = "Year", y = "Value (units)")
```

### Distribution comparisons (ridge plot)

```r
library(ggridges)

df |>
  mutate(group = fct_reorder(group, value, median)) |>
  ggplot(aes(x = value, y = group, fill = group)) +
  geom_density_ridges(alpha = 0.7, scale = 1.0,
                      rel_min_height = 0.01, colour = "white") +
  scale_fill_manual(
    values = colorRampPalette(brand_blues)(n_distinct(df$group))
  ) +
  labs(x = "Value", y = NULL) +
  guides(fill = "none")
```

---

## 7. Output

```r
# Multi-panel layout
(p1 | p2) / p3 +
  plot_layout(heights = c(2, 1), axes = "collect") +
  plot_annotation(tag_levels = "A",
                  theme = theme(plot.tag = element_text(face = "bold", size = 17)))

# Saving — always specify width/height so font and line sizes lock in
ggsave("figure.pdf", plot = p, width = 7, height = 4, units = "in",
       device = cairo_pdf)
ggsave("figure.png", plot = p, width = 7, height = 4, units = "in", dpi = 600)
ggsave("figure.tiff", plot = p, width = 7, height = 4, units = "in", dpi = 600,
       compression = "lzw")
```

---

## 8. Cross-references

For regression / descriptive tables (journal star cutoffs, booktabs, never-change-a-number), see [tables.md](tables.md). Report format in [report.md](report.md).

**Definition:** Figures produced (count, types, output paths); format and DPI; whether colorblind/grayscale check was run; whether categorical axes were sorted by value.
**Analyses:** Chart types and rationale (Cleveland-McGill); annotation strategy; journal compliance (DPI, font, line weight).
**Takeaway:** Visual message conveyed; deviations from personal standards or journal requirements requiring human sign-off.

---
name: data-visualization
description: Use when producing publication-ready figures in R + ggplot2 — Cleveland-McGill perceptual ranking; three-tier dusty palette (tinted Okabe-Ito fills + muted Okabe-Ito strokes/lines/marks as the default; saturated Okabe-Ito reserved for rare accents only — never the default); hierarchical hue-family + saturation encodings; layered same-family sequential ramps; five-element title/subtitle/axis/strip/caption hierarchy with explicit word budgets (axis-title floor 3 words + unit); direct annotation over legend boxes; 600 DPI output for journal submission; multi-panel patchwork layouts. Enforces personal figure standards (always sort categorical axes, plot differences not raw values, calculate before you graph). For journal-formatted regression tables, see tables.md.
allowed-tools: Read, Edit, Write, Bash
invocation: auto
---

## Contents

1. [Personal Figure Standards](#1-personal-figure-standards) — the 12 rules every figure must obey
2. [Perception Fundamentals](#2-perception-fundamentals) — Cleveland-McGill, Gestalt, channel budget
3. [Decision Guides](#3-decision-guides) — pick the chart type and the color-job
4. [ggplot2 Setup](#4-ggplot2-setup) — `theme_pub()` and the three-tier palettes
5. [Color Palettes](#5-color-palettes) — categorical, sequential, diverging, hierarchical, layered, diagrams, CVD check
6. [Recipes](#6-recipes) — copy-pasteable code for sort / thin / annotate / coef / time-trend / ridge / layer-highlight
7. [Output](#7-output) — patchwork, ggsave at 600 DPI
8. [Cross-references](#8-cross-references) — tables, report

---

## 1. Personal Figure Standards

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
   - Plot subtitle (if used): 16–18 pt, `grey30`, regular weight
   - Panel tag (A/B/C): 16–18 pt bold
   - Plot caption / figure note (if rendered on the plot): 12–14 pt, `grey40`
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
10. **Title and label hierarchy — brief but self-contained.** A figure has up to five text layers. Each has a distinct purpose and word budget; **over-condensing happens when content from one layer gets pushed onto a shorter layer or dropped entirely**. Calibrate to the budget for each layer, not to "shortest possible".

    **Default — minimum required:** axis titles only. Add the rest only when the context demands it. Most figures should have *just axes + (facet strips when faceting)*; nothing else.

    | Element | Required? | Word budget | When to add | Example |
    |---|---|---|---|---|
    | **Axis title** | **Always** | 3–6 words + units | Every figure. Self-contained: the reader should not need the caption to know what the numbers mean. | `Mortgage loan amount ($, log)` — *not* `Amount` (too terse, no unit) or `Loan amount in dollars on a logarithmic scale` (too verbose). |
    | **Facet strip** | When faceting | 1–3 words | Auto-generated by `facet_wrap` / `facet_grid` — just keep it short. | `North America`, `Q4 2024`, `Treated` |
    | **Plot title** | **Skip by default** | 4–8 words, noun phrase | Only when the figure is shown *standalone* without a caption (single-figure slide, social media, blog post). For a paper figure, the LaTeX `\caption{}` does this work — adding a plot title duplicates it. | `Loan demand fell after the 2023 reform` |
    | **Plot subtitle** | **Skip by default** | 6–12 words | Only when the figure is shown standalone *and* needs in-figure sample/period context (slide, poster, social share). Never for a journal-submitted figure — the caption carries this. | `Difference-in-differences estimates, US private banks, 2018–2024` |
    | **Caption** | At submission only | Full prose, 2–6 sentences | Only in the final LaTeX `\caption{}`, not on the plot. Drafts, working figures, and exploratory plots don't need one. | — |

    The two most common failure modes:

    - **Over-condensed axis titles** — `Amount`, `Share`, `Year`, `Value`. Under 3 words, no unit. Forces the reader to consult the caption to know what's on the axis, breaking self-containment. If a 3-word + unit title doesn't fit, the figure is too narrow, not the title too long.
    - **Title-as-caption** — stuffing sample / period / identification detail into the title or subtitle when the journal is going to render a full caption underneath. Keep the title to the finding; let the caption carry the methodological context.

    Cross-panel overlap (the original concern in this rule):

    - Pre-export, render at the final export width and inspect strip-text and axis-title boundaries between panels — `patchwork` and `facet_wrap` do not auto-resolve title overflow.
    - If titles still collide: drop redundant y-axis titles from non-leftmost panels (`labs(y = NULL)`); share axes via `plot_layout(axes = "collect")`; rotate to a horizontal layout when category labels are too wide; or move secondary information into the figure caption rather than the title. **Shortening below the floor (3 words + unit on axis titles) is not a valid resolution** — fix the layout instead.
11. **Show uncertainty.** Always include confidence intervals or error bars on inferential plots — a ribbon (`geom_ribbon` at `alpha = 0.18–0.22`) for continuous coverage, an error bar for discrete points. A point estimate without uncertainty conveys false precision.
12. **Maximize data-ink ratio.** Drop minor gridlines, the panel border, and tick marks that add no information (Tufte). Keep major gridlines as faint reference (`grey85`, `linewidth 0.4`); keep axis lines and tick marks at the values labels are placed against. The default `theme_pub()` in §4 implements this — resist re-adding the things it drops.

---

## 2. Perception Fundamentals

From socviz.co Ch. 1. Internalize once; they decide chart-type choices automatically.

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

More effective than a 20-color rainbow and survives B&W printing. Code recipe in §6.

---

## 3. Decision Guides

Two tables that decide the bulk of figure-design choices: which chart, and what color is *for*.

### Chart Type Guide

| Relationship                  | Chart                            |
|-------------------------------|----------------------------------|
| Distribution (one var)        | Histogram, density, violin       |
| Distribution (compare groups) | Ridge plot, overlaid density     |
| Two continuous vars           | Scatter, hexbin (large N)        |
| Category vs. continuous       | Bar/dot (mean ± CI), strip + box |
| Time series                   | Line with shaded CI              |
| Time series + fitted models   | Black raw line + linetype-distinguished fits + grey CI |
| Correlation matrix            | Heatmap                          |
| Causal estimate               | Coefficient plot (dot + CI)      |
| Geographic                    | Choropleth                       |

### Color Job Guide

Before picking a palette, name what color is *for* in this figure. The palette family follows from the job. A sequential palette mapped to categories obscures the categories; a categorical palette mapped to a magnitude misleads about ordering.

| Job | When | Palette family |
|---|---|---|
| **Identification** — distinguish unordered categories | Treatment vs. control, platform A vs. B | Categorical: tint fills (`okabe_ito_tint`) + muted strokes (`okabe_ito_muted`). **Never saturated.** |
| **Hierarchy** — two categorical levels (parent × child) | Workflow stages × steps, arms × waves | Muted hue family per parent + tint steps per child |
| **Magnitude** — encode one ordered/continuous value | Choropleth, heatmap, density | Sequential (viridis, Blues — endpoints stop at navy / brick, never bright) |
| **Layered magnitude** — two related ordered quantities, one nested in the other | Sea-level zone within elevation zone, treated within full sample | Tint (outer) + muted (inner) of same hue. Cap 2 levels. |
| **Signed deviation** — encode +/− around a midpoint | Coefficient vs. baseline, residual map | Diverging (RdBu, Purple-Green) |
| **Emphasis** — focus one series, fade others | "ChatGPT vs. all platforms" | Layer-and-highlight (gray + saturated accent — *the one place Tier 3 is right*) |

---

## 4. ggplot2 Setup

`theme_pub()` (calibrated for 600 DPI publication output) and the three-tier Okabe-Ito palette system. Source this once at the top of any analysis script.

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
                                      hjust = 0,
                                      margin = margin(t = 8)),
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

# Three-tier Okabe-Ito system. Each tier is the same eight Okabe-Ito hues
# transformed differently — so CVD-safety and hue ordering are preserved
# across all three.

# TIER 1 — Tint fills (each hue mixed 50/50 with white).
# Default for filled shapes that carry text or should sit calmly on white.
okabe_ito_tint <- c("#F2CF80", "#ABDAF4", "#80CFB9", "#F8F2A1",
                    "#80B9D9", "#EAAF80", "#E6BCD3", "#808080")

# TIER 2 — Muted / dusty strokes (each hue mixed 50/50 with mid-gray #999).
# Default for strokes, lines, points, error bars, and any "mark" that
# carries no fill. This is the editorial / JAMA / Nature-2020s look —
# the layer that most distinguishes a current figure from a 1990s
# ggplot2 default. Use this everywhere the previous convention reached
# for saturated Okabe-Ito.
okabe_ito_muted <- c("#BF9C4C", "#77A6C1", "#4C9B86", "#C4BE6D",
                     "#4C85A5", "#B77B4C", "#B289A0", "#4C4C4C")

# TIER 3 — Saturated Okabe-Ito (the original).
# RESERVED FOR ACCENT ONLY: focal series in a layer-and-highlight, or
# a single high-emphasis callout against a muted/gray background.
# Do NOT use as the default stroke palette — it reads as "old-school".
okabe_ito <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442",
               "#0072B2", "#D55E00", "#CC79A7", "#000000")

# House discipline: tint fills + muted strokes/lines.
# Pair them on shape geoms with `aes(fill = g, colour = g)` so the
# fill picks the tint and the stroke picks the muted counterpart.
options(ggplot2.discrete.fill   = okabe_ito_tint,
        ggplot2.discrete.colour = okabe_ito_muted)
```

**Greek and math symbols.** Use Unicode characters directly in axis labels, annotations, and titles — `α`, `β`, `μ`, `σ²`, `≥`, `×` — never Symbol-font glyphs, which render as tofu in modern PDF readers and fail journal preflight. ggplot2 + Helvetica handles Unicode without configuration; just paste the character.

---

## 5. Color Palettes

Detail behind the Color Job Guide in §3. Palettes themselves are defined in §4 — this section explains *how to use* each one.

### Categorical — three-tier dusty palette (Okabe-Ito derived)

The hue system is Okabe-Ito; the *aesthetic* is a **three-tier system** — tint fills, muted/dusty strokes, and saturated only as accent. Tinted fills sit calmly on white and let on-shape text stay legible. **Muted strokes (and lines, points, error bars) keep contrast where the eye parses the value, without the bright "ggplot2-default" saturation that reads as old-school.** Saturated Okabe-Ito is demoted to accent — used only for the focal series in a layer-and-highlight or a single high-emphasis callout.

The three palettes (`okabe_ito_tint`, `okabe_ito_muted`, `okabe_ito`) are defined in §4.

**On any filled shape (bars, ribbons, boxes, areas, ridges), pair fill and colour:**

```r
# Bars — tint fill, muted outline
geom_col(aes(fill = group, colour = group), linewidth = 0.4)

# Filled points — pch 21–25 take fill + stroke separately
geom_point(aes(fill = group, colour = group),
           shape = 21, size = 2.8, stroke = 0.7)

# Ribbons — tint fill at low alpha, muted line on top
geom_ribbon(aes(ymin = lo, ymax = hi, fill = group), alpha = 0.22) +
geom_line(aes(colour = group), linewidth = 0.9)
```

The two `aes()` mappings pull from the two global palettes set in §4 — fill from `okabe_ito_tint`, colour from `okabe_ito_muted` — so the pairing is automatic. **For pure line geoms (no fill), only the muted colour applies** — correct, because the muted palette is calibrated to keep contrast on white at typical line widths (1.0–1.4 pt) without the saturation glare.

**Two-group canonical pair: dusty mustard + dusty steel blue.**
- Fills: `c("#F2CF80", "#80B9D9")`
- Strokes: `c("#BF9C4C", "#4C85A5")`

The default for treatment vs. control, before vs. after, fintech vs. bank, and any binary comparison. The fill pair has high luminance contrast (survives grayscale); the muted stroke pair has high hue contrast (survives all three CVD types). Use this pair unless there's a strong reason not to.

```r
scale_fill_manual  (values = c(treatment = "#F2CF80", control = "#80B9D9")) +
scale_colour_manual(values = c(treatment = "#BF9C4C", control = "#4C85A5"))
```

**Single-series default: tint blue `#80B9D9` fill + muted blue `#4C85A5` stroke.** When only one color is needed (single bar series, single density, single ribbon), use this fill/stroke pair everywhere — not `steelblue`, not the ggplot2 default, not arbitrary hex. For pure line geoms with one series, use the muted `#4C85A5` directly. Consistency across the figures in one paper is itself a reading aid.

**When to reach for saturated (Tier 3):**
- The focal series of a layer-and-highlight where the rest of the data is `grey80` background — saturation is needed to *pop* against the gray, and dusty strokes blend in too much. Use the saturated Okabe-Ito hue here (typically `#0072B2`).
- A single high-emphasis callout — one line/bar/point you want the reader's eye to land on first.
- That's it. Default plots should not contain saturated hues.

**Five-category ceiling.** Distinguishability collapses past 5 categorical colors. Above 5, switch to facet or layer-and-highlight. When 3–4 suffice, the *R Journal* 2023 recommendation is to use the **first four Okabe-Ito hues** — in our system, that means tints `#F2CF80, #ABDAF4, #80CFB9, #F8F2A1` paired with strokes `#BF9C4C, #77A6C1, #4C9B86, #C4BE6D`.

**Known weaknesses to design around:**

- Tint yellow `#F8F2A1` and muted yellow `#C4BE6D` are low-contrast on white — yellow needs a stroke even more than the others; never use for lines or thin marks.
- Muted near-black `#4C4C4C` reads almost as charcoal — use it for axis lines, zero lines, and text but not as a category color (it'll fight the axis).
- The two warm hues (muted mustard `#BF9C4C` + muted vermillion `#B77B4C`) confuse under protanopia — don't pair them as the two main categories. Choose mustard + steel blue, or steel blue + sage, instead.
- Avoid red + green combinations (8% of men, 0.5% of women have red-green CVD) regardless of palette tier.

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

### Hierarchical (nested categories) — hue family for the parent, saturation for the child

When the data has **two categorical levels** (e.g., paper sections × subsections within section, treatment arms × measurement waves, framework stages × steps within stage), don't burn one channel per level — burn one *family* per parent level and use saturation/luminance steps within. This is what conceptual diagrams and workflow figures rely on, and it works because the eye reads "same hue → same group" pre-attentively (Gestalt similarity).

Pattern:

1. Pick one **muted** Okabe-Ito hue per parent category (cap 4 parents — past that, distinguishability collapses). Muted, not saturated, because the parent header should match the rest of the figure's dusty register.
2. For each child within that parent, generate 2–3 saturation/luminance steps in the same hue: the muted version (parent's `okabe_ito_muted` entry — used for header/border), a mid version (mix the muted version 50% with white), and a tint (the corresponding `okabe_ito_tint` value).
3. Use the muted version for the parent header / outermost border / parent label; tint and mid for child fills.

```r
# Build a nested palette from a parent → children spec
mix_white <- function(hex, w) {
  rgb <- col2rgb(hex) / 255
  out <- rgb * (1 - w) + w
  rgb(out[1], out[2], out[3])
}

# Parents come from the MUTED palette, not the saturated one — keeps
# the diagram in the dusty register the rest of the figure uses.
parent_hues <- c(stage1 = "#4C85A5",   # muted blue
                 stage2 = "#4C9B86",   # muted green
                 stage3 = "#B77B4C",   # muted vermillion
                 stage4 = "#B289A0")   # muted purple

nested_pal <- unlist(lapply(parent_hues, function(h) {
  c(header = h,                   # muted — parent header / outer border
    mid    = mix_white(h, 0.40),  # half-tint — mid-level child fill
    tint   = mix_white(h, 0.70))  # near-pastel — innermost child fill
}))
```

**Cap at 4 parent hues, 3 children per parent.** Past that the saturation steps stop being discriminable, and the figure goes back to needing facets. Always run a CVD simulation pass before signing off — pastels narrow the hue gamut and bunch up under deuteranopia.

### Layered sequential — two related quantities, same hue family

When two **ordered/continuous** variables share a meaning (e.g., "<10 m elevation zone" containing "<1 m sea-level rise zone"; "all customers" containing "active customers"; "full sample" containing "treated subsample"), encode both with **two saturation steps in the same hue family** rather than two separate ramps. The figure then reads as nested ("the dark area is a subset of the light area") in one glance.

```r
# Two-level coastal-style overlay (matches the muted convention —
# both layers stay out of full saturation; the outer is tint, the inner
# is muted)
ggplot() +
  geom_sf(data = broad_zone, fill = "#ABDAF4", colour = NA) +   # tint  — outer extent
  geom_sf(data = focal_zone, fill = "#4C85A5", colour = NA)     # muted — inner extent

# In a panel chart: full vs. subsample distribution
ggplot(df, aes(x = value)) +
  geom_density(data = filter(df, group == "full"),
               fill = "#ABDAF4", colour = NA, alpha = 0.6) +
  geom_density(data = filter(df, group == "treated"),
               fill = "#4C85A5", colour = NA, alpha = 0.6)
```

**Hard limit: two levels.** Three saturation steps in one family stop being reliably ordered for the reader (especially under CVD). For three or more ordered categories, switch to a true sequential ramp (`scale_*_viridis_c()` or `scale_*_distiller(palette = "Blues")`).

### Conceptual diagrams (boxes-and-arrows)

For workflow diagrams, conceptual frameworks, and theoretical models, the rule generalizes the categorical convention — *no saturated hues anywhere*:

- **Fill** = the relevant tint hue (`okabe_ito_tint`) — low saturation, lets text on top stay legible.
- **Stroke** = the muted counterpart (`okabe_ito_muted`) at `linewidth = 0.6–0.8`.
- **Header strip / title bar** (if the box has one): the muted counterpart as a fill, with white text. (Saturated headers read as PowerPoint-2010; muted headers read as editorial.)
- **Arrows / connectors**: dark gray (`#444444`) by default; if the arrow itself encodes a category (e.g., feedback vs. forward flow), use a muted hue from `okabe_ito_muted`, **never saturated**.

Worked example for a 4-stage workflow:

```r
# Each stage gets a (header, fill) muted/tint pair from the same hue.
stages <- list(
  stage1 = list(header = "#4C85A5", fill = "#ABDAF4"),  # blue
  stage2 = list(header = "#4C9B86", fill = "#80CFB9"),  # green
  stage3 = list(header = "#B77B4C", fill = "#EAAF80"),  # vermillion
  stage4 = list(header = "#B289A0", fill = "#E6BCD3")   # purple
)
```

Works for `ggplot2` annotation layers (`geom_rect`, `geom_label`), `ggraph`/`tidygraph` for DAGs, and hand-laid `cowplot::draw_*` overlays. Keeping every element — fills, headers, strokes, arrows — out of full saturation is what makes the diagram read as "polished" / "Nature-style" rather than "AutoCAD" or "PowerPoint".

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

The mustard + blue pair (muted: `#BF9C4C` + `#4C85A5`; tint: `#F2CF80` + `#80B9D9`) survives grayscale on its own; a third or fourth series almost certainly will not — pair channels above N = 2.

---

## 6. Recipes

Copy-pasteable code for the chart types in §3. Each recipe assumes `theme_pub()` and the three-tier palettes from §4 are already loaded.

### Sorting categorical axes (always)

```r
# Bar/dot plot sorted by value, horizontal for long labels
df |>
  mutate(domain = fct_reorder(domain, share)) |>
  ggplot(aes(x = share, y = domain)) +
  geom_col(fill = "#80B9D9", colour = "#4C85A5", linewidth = 0.4) +
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

### Thinning dense axes

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

### Direct line annotation (no legend)

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

### Coefficient / event-study plot

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
             colour = "#B77B4C", linewidth = 0.4) +
  annotate("text", x = -0.5 + 0.1, y = Inf, vjust = 1.3,
           label = "Event", colour = "#B77B4C", size = 3.5, hjust = 0) +
  geom_ribbon(aes(ymin = lo, ymax = hi), alpha = 0.22, fill = "#80B9D9") +
  geom_line(linewidth = 0.8, colour = "#4C85A5") +
  geom_point(size = 2.6, shape = 21, fill = "#80B9D9",
             colour = "#4C85A5", stroke = 0.7) +
  labs(x = "Periods relative to treatment", y = "Estimated effect")
```

### Time trend with overlaid fits (raw + models + CI)

When a figure layers a raw observed series, one or more model fits, and uncertainty — the *Nature*-panel-1 style. Three deliberate roles, three different visual weights:

- **Raw series** — near-black `#1A1A1A`, `linewidth = 0.4–0.5`. *Thin*, because raw data is the reference, not the headline.
- **Fitted lines** — distinguished primarily by **linetype** (`solid`, `dashed`, `dotted`, `dotdash`), with secondary muted-Okabe-Ito hues for color. `linewidth = 1.0–1.2`. Linetype is the load-bearing channel: the figure must read in grayscale.
- **CI ribbon** — `fill = "grey70"`, `alpha = 0.22–0.28`, `colour = NA`. Belongs to one fit (usually the primary model); don't overlay multiple ribbons unless they're nested same-family.
- **Direct annotation** at each fit's right endpoint. No legend.

```r
# Long-format data with a `series` column: "raw", "linear", "loess", "poly".
# Ribbon attached to the primary fit only (e.g., loess).
ggplot(df, aes(x = year, y = value)) +
  geom_ribbon(data = filter(df, series == "loess"),
              aes(ymin = lo, ymax = hi),
              fill = "grey70", alpha = 0.25, colour = NA) +
  geom_line(data = filter(df, series == "raw"),
            colour = "#1A1A1A", linewidth = 0.45) +
  geom_line(data = filter(df, series != "raw"),
            aes(linetype = series, colour = series),
            linewidth = 1.0) +
  scale_linetype_manual(values = c(linear = "dashed",
                                   loess  = "solid",
                                   poly   = "dotted")) +
  scale_colour_manual(values = c(linear = "#4C85A5",
                                 loess  = "#B77B4C",
                                 poly   = "#4C9B86")) +
  geom_text_repel(
    data = filter(df, series != "raw") |>
             group_by(series) |> slice_max(year, n = 1),
    aes(label = series, colour = series),
    hjust = 0, nudge_x = 1, direction = "y", segment.colour = NA, size = 4
  ) +
  scale_x_continuous(expand = expansion(mult = c(0.02, 0.15))) +
  labs(x = "Year", y = "Value (units)")
```

**Why linetype carries the categorical work and not just color:** raw + 3 fits = 4 categories on overlapping x. Even with the muted palette, four overlapping muted lines on white start to bleed into each other, especially under CVD. Linetype gives a redundant, grayscale-safe channel — the same trick the colorblind-fallback subsection covers, but here it's the *positive* default rather than a fallback.

**Variations:**
- *Single fit + raw*: drop linetype mapping; raw black + one muted-colored fit + grey ribbon. Simplest version, common in working papers.
- *Two fits, no raw* (e.g., counterfactual vs. observed model): use the two-group canonical pair with linetype contrast (`solid` for observed, `dashed` for counterfactual).
- *Many fits, no raw* (e.g., specification curve): switch to the layer-and-highlight pattern instead — gray for non-focal fits, saturated for the focal one.

### Distribution comparisons (ridge plot)

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

### Layer-and-highlight (focal comparison)

This is the **one figure type where saturated Okabe-Ito (Tier 3) is correct** — the focal series needs to pop against the gray background, and a muted/dusty stroke would blend in too much. Override the default discrete-colour palette explicitly.

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
  scale_colour_manual(values = c(ChatGPT = "#0072B2",     # saturated — Tier 3
                                 Claude  = "#D55E00")) +
  scale_x_continuous(expand = expansion(mult = c(0.02, 0.12))) +
  labs(x = "Week", y = "Visits")
```

---

## 7. Output

### Multi-panel layout (patchwork)

```r
library(patchwork)

(p1 | p2) / p3 +
  plot_layout(heights = c(2, 1), axes = "collect") +
  plot_annotation(tag_levels = "A",
                  theme = theme(plot.tag = element_text(face = "bold", size = 17)))
```

`axes = "collect"` deduplicates shared axes. `tag_levels = "A"` produces **uppercase** A/B/C panel labels — the journal-required form. Tag size 17 pt bold matches Personal Figure Standards #6 (panel tag 16–18 pt bold at export DPI).

### Saving for publication

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

## 8. Cross-references

### Tables

For regression / descriptive tables — journal-specific star cutoffs, booktabs templates, the never-change-a-number rule — see the sibling skill: [tables.md](tables.md).

### Report

See [Report format](report.md).

**Definition (measure):** Figures produced (count, types, output paths); format and DPI; whether colorblind/grayscale check was run; whether categorical axes were sorted by value.  
**Analyses:** Chart types chosen and rationale (Cleveland-McGill justification); annotation strategy (direct vs. legend); journal standard compliance (DPI, font, line weight).  
**Takeaway:** Visual message conveyed; any deviations from personal figure standards or journal requirements that require human sign-off.

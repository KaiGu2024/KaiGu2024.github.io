---
name: visualization
description: Use when producing publication-ready figures in R + ggplot2 — Cleveland-McGill perceptual ranking; Monet/Hokusai brand palette (dusty blue + sage default, Prussian sequential, viridis precise, crimson accent); Lora display + Newsreader body fonts matching the personal site/slides/CV; one panel per figure (combine via LaTeX `subfigure`); axis-title-only with no plot title/subtitle/caption inside the image (text belongs in TeX); oversized components so figure text reads LARGER than body text in a paragraph or slide; direct annotation over legends; 600 DPI. Enforces sort-categorical-axes, plot-differences-not-raw, no-gridlines, nothing-clips-or-overlaps. For regression tables, see tables.md.
allowed-tools: Read, Edit, Write, Bash
invocation: auto
---

## Contents

1. [Standards](#1-standards) — the 13 rules every figure must obey
2. [Perception](#2-perception) — Cleveland-McGill, channel budget, layer-and-highlight
3. [Decisions](#3-decisions) — pick the chart type, name the color job
4. [Setup](#4-setup) — `theme_pub()` and the brand palette
5. [Palettes](#5-palettes) — categorical, sequential, diverging, layer-and-highlight, CVD
6. [Recipes](#6-recipes) — pointer to `references/recipes.md`
7. [Output](#7-output) — one panel per file, ggsave at 600 DPI, LaTeX `subfigure`
8. [Cross-references](#8-cross-references)

---

## 1. Standards

1. **Tool: R + ggplot2.** Default to ggplot2. Reach for matplotlib/seaborn only if the figure genuinely cannot be made in ggplot2.

2. **Sort categorical axes by value.** No inherent order (countries, brands, models, conditions) → `fct_reorder(var, value)` (descending: `.desc = TRUE`). Alphabetical wastes the strongest pre-attentive channel — position. Exceptions: time, naturally-ordered categories (Likert, age bins), or a fixed external ordering that is itself the comparison.

3. **Y-axis range.** Lower bound: start at 0 (or 100 for indexed series); deviate only if the entire range is far from zero AND within-data variation is the story — disclose explicitly. Upper bound: for unbounded metrics, let ggplot's 5% expansion handle headroom (don't pad to round numbers); for bounded metrics (percent, share, Likert), set the axis to the cap (100, 1.0, 5, 7) regardless of data range.

4. **Direct annotation, no legends.** Label each line/group at its endpoint or most legible point. Suppress redundant guides with `guides(fill = "none")` when a variable is mapped to both `x` and `fill`/`color`.

    **Annotation readability — orientation and contrast.** Horizontal text is always easiest; use it unless a vertical event line or a narrow axis forces rotation. When you must rotate **annotation prose** (event-line labels, callouts, in-panel commentary), use **`angle = 90` only** — text reads bottom-to-top, head tilts LEFT, which is the standard direction. `angle = -90` / `270` produce top-to-bottom text (head tilts RIGHT) and are noticeably slower to read in English; never use them. **Avoid diagonals between 15° and 75° for prose** — full-word text reads slowly at those tilts; jump from horizontal straight to vertical-at-90°. **Short, standardized tick labels are a different case:** dates (`2024-12`), short category strings (≤ 8 chars) read well at `angle = 30, hjust = 1` — this is the publication standard for time-series x-axes and lets a panel fit roughly 3× the breaks of pure horizontal (e.g., a 2-month cadence instead of 6-month). Use the 30° tilt when you want denser dates than the §7 cadence table allows. For long category labels, prefer `coord_flip()` over any rotation — the labels become horizontal y-ticks. Minimum text contrast for annotations meant to be *read* is `grey30` on white — `grey60` looks designed but reads as decoration. (For *placement* — labels not sitting on data marks — see rule 13.8.)

    **Annotation styling — size, font, no parens.** Use `geom_text(size = 7–8)` ≈ **20–22 pt rendered** for direct line/point labels: slightly smaller than axis tick labels (24 pt) so commentary doesn't compete with the reference axis. Endpoint labels that replace a legend can match the axis text at `size = 8` (~22 pt) since they ARE the identification system. Use the figure's body font (Newsreader via `theme_pub()`); don't introduce a third typeface inside the data field — figures stay in the Lora display + Newsreader body pair, matching the surrounding paper or slide. **Plain nouns only — no parentheses, no qualifiers, no units inside annotations.** Write `ChatGPT`, `Google`, `Treatment` — never `ChatGPT (US)`, `Google (search)`, `Treatment (n=482)`. Units live on axis titles (`Mortgage amount (USD, log)`); sample size, period, country, model spec live in the LaTeX `\caption{}`. Inside the data field, every parenthesis is visual noise. Keep annotations to 1–3 words.

    **Label every series the reader needs to identify; highlight changes color, not coverage.** "No legends" means *replace the legend with direct labels*, which applies to every line/group the reader needs to identify by name. For a 5-line chart (ChatGPT, Google, Bing, DuckDuckGo, Yahoo) all five get endpoint labels — what changes with layer-and-highlight is the *color* of the focal line and its label (`brand$accent`), while the others stay in grey (line `grey80`, label `grey50` so it reads against white). Backgrounded series still need names; without them the reader can't reconstruct what the gray cloud represents. Two exceptions: (1) horizontal bar charts where y-axis ticks already name each bar — the ticks ARE the labels, don't double-label; (2) so many series that endpoint labels still collide after `ggrepel` — then facet, don't squeeze.

5. **High DPI.** `dpi = 600` (or PDF vector). *Science*/*Nature* minimum at submission.

6. **Oversize every component so figure text reads larger than body text.** Figures are usually placed at half-column or column width inside a paragraph or slide, so the rendered point size is roughly half the source size. Author at sizes that, after scaling, still beat 11 pt body. Default ggplot fonts (~11 pt) and lines (~0.5 pt) are far too small:
   - Axis titles **26–30 pt**; tick labels **22–26 pt**; inline / annotation labels **20–26 pt** (`geom_text(size = 7–9)` — ggplot text `size` is mm, ≈ 2.83 × pt)
   - Strip text (facets, if any) **22–26 pt** bold
   - Data lines `linewidth = 2.2–3.0`; reference / zero / vline lines 1.2–1.5; axis lines 1.1; ticks 1.0
   - Points `size = 6–8`; ribbon `alpha = 0.18–0.22`
   - **No plot title / subtitle / caption / tag inside the image** — see rule 10.

7. **Thin out dense axis ticks.** Crowded labels → drop ticks, don't shrink fonts. Date: `scale_x_date(date_breaks = "3 months", date_labels = "%Y-%m")`. Numeric: `scales::pretty_breaks(n = 6)`. Categorical: label every other level, or flip the chart with `coord_flip()` for long labels. Rotation is last resort *for arbitrary categorical labels* — but for short standardized labels like dates, `angle = 30, hjust = 1` is a normal option that buys ~3× the breaks (rule 4 has the full guidance; recipes have the code).

8. **Plot differences, not raw values.** Compute the gap (treatment − control) and plot one value per group, sorted by the difference. Two side-by-side bars force mental subtraction; the diff makes the comparison explicit.

9. **Calculate before you graph.** Pre-aggregate with dplyr, plot with `stat = "identity"`. Geom-side stats (`after_stat(prop)`, `stat_summary`) fail in surprising ways with grouped/multi-variable aggregation; the summary table is itself a useful artifact.

10. **Axis titles only — no in-figure text.** The only text inside the image is axis titles (and facet strips if a single-panel facet is unavoidable). **Do not** set `plot.title`, `plot.subtitle`, `plot.caption`, or `plot.tag`; those belong in LaTeX (`\caption{}`, `\subcaption{}`, section prose, slide chrome) where they can be re-edited without re-rendering the figure. Notes, sample descriptions, model details, and panel letters (A/B/C) all live in TeX, not in the PNG/PDF.

    Axis title floor: **3 words + unit.** Self-contained (`Mortgage loan amount ($, log)`, not `Amount`). Failure mode is over-condensed labels — the fix is more words, not a plot title.

    **One panel per figure.** Faceting and patchwork combining are out of the default toolbox: each panel exports as its own file, and combination happens in LaTeX via `subfigure` / `subcaption` (or in Beamer via columns). This keeps panel labels (a / b / c), sub-captions, and arrangement editable in source. If a faceted layout is truly the right encoding (small multiples over a single ordered variable), export the faceted plot as one file and skip the LaTeX combine — but the default is one chart, one file.

11. **Show uncertainty.** Confidence intervals always — `geom_ribbon(alpha = 0.18–0.22)` for continuous, error bars for discrete. Point estimates without uncertainty convey false precision.

12. **No gridlines.** Drop both major and minor gridlines, panel border, and redundant ticks (Tufte taken further than the usual "faint major" compromise). The axis line + ticks carry value-lookup; lengthen ticks (`axis.ticks.length ≈ 6 pt`) and use `scales::pretty_breaks(n = 6–8)` so the axis itself is the lookup aid. When a specific numeric value is part of the message — endpoint of a line, peak of a curve, a single bar — direct-label it with `geom_text` instead of asking the reader to interpolate against a grid. `theme_pub()` (§4) implements this.

13. **Nothing clips, nothing overlaps.** Oversized fonts (rule 6) collide easily — axis titles into tick labels, tick labels into each other, endpoint labels off the right edge, rotated annotations off the top, and direct-labels stacking on each other when lines converge. The principle applies to annotations as much as to axis chrome: every label must occupy its own white space. Before saving, render at the target export size and verify:
    1. **Tick labels don't touch each other** → thin breaks (`scales::pretty_breaks(n = 6)`, `date_breaks` cadence per recipes, or two-row date labels).
    2. **Axis title doesn't touch tick labels** → `theme_pub()` sets `axis.title.x/y` margins of 12 pt; bump higher if axis text wraps.
    3. **Endpoint / direct labels don't run off the panel** → expand the data-side axis with `scale_x_*(expand = expansion(mult = c(0.02, 0.15)))`. Right margin 0.12–0.18 is the usual range for line-endpoint labels.
    4. **Annotations above/below the panel don't get cropped** → `coord_cartesian(clip = "off")` plus extra `plot.margin` (e.g., `margin(t = 30, ...)`) when rotated labels or drop-pins extend past the data region.
    5. **Long y-category labels don't clip the left edge** → either wrap with `scales::label_wrap(20)` / `stringr::str_wrap(label, 20)`, or pad with `plot.margin = margin(l = 30)`.
    6. **The image itself is large enough for the fonts.** At 28 pt axis titles, author width ≥ 4.5 in. Authoring at 3.5 in will clip the axis title onto the panel.
    7. **Direct labels don't overlap each other — keep them on a single row of endpoint anchors.** For multi-series endpoint labels, use `geom_text_repel` with `direction = "y"` so labels nudge apart along the axis they identify. When lines *converge* (endpoint y-values too close, e.g., 5 platforms all near the same value at the right edge), don't let repel stack labels vertically with connector segments — that produces a 2-D scatter of labels and connector lines that looks messy. Instead, **rotate every label to vertical (`angle = 90, hjust = 0`), anchored at each line's endpoint, and repel with `direction = "x"`** so the labels space apart horizontally just past the right edge while each label runs bottom-to-top (readable orientation, head tilts LEFT). The whole label rail stays one row tall; you get up to ~8 labels in the horizontal margin a single horizontal label would occupy. Only if even the vertical row can't fit (truly too many series) do you facet or switch to layer-and-highlight — never shrink the font.
    8. **Direct labels don't sit on top of data lines, points, or bars.** Move them into white space with `nudge_x` / `nudge_y` or let `ggrepel` reposition. Inline annotations placed *inside* a panel (event line labels, statistical callouts) get the same treatment — anchor them in empty regions, not over a fitted curve or a tall bar. `geom_label` (white background box) is the absolute last resort, only when no white space exists.

    The check is visual — open the saved PDF/PNG, don't trust the RStudio viewer (its width drifts). Recipes in `references/recipes.md` already use the right `expand =`, `clip = "off"`, and `geom_text_repel` settings; if you copy one, keep them.

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

For "this country/firm/domain vs. all others": plot all data in `grey80`, plot focal subset on top in saturated accent, and label *every* series at its endpoint — focal in the accent color, the rest in `grey50` so the reader can still identify the grey cloud. More effective than a 20-color rainbow; survives B&W. Code in `references/recipes.md` → "Layer-and-highlight".

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

The theme function, brand palette, sequential ramp, and global ggplot defaults all live in `scripts/theme_pub.R`. Source it once per session — don't copy-paste from this file, the script is the source of truth.

```r
library(ggplot2)
library(dplyr)
library(forcats)
library(ggrepel)
library(scales)
# Note: no patchwork — one panel per figure; combine in LaTeX (subfigure).

source("~/.claude/skills/visualization/scripts/theme_pub.R")

# If Newsreader / Lora aren't installed system-wide, register them per session:
showtext::font_add_google("Newsreader", "Newsreader")
showtext::font_add_google("Lora",       "Lora")
showtext::showtext_auto()
```

This loads `theme_pub()` (already applied via `theme_set()`), the `brand` list, the `brand_blues` ramp, and sets discrete fill/colour defaults. **Fonts:** Lora (display) on axis titles + facet strips, Newsreader (body) on tick labels and annotations — the same pair as the personal site, slides, and CV, so figures sit inside the surrounding work instead of clashing with a generic Helvetica.

Palette slot names (full definitions in `scripts/theme_pub.R`):

```r
brand$primary    # "#6B89A8"  Monet dusty blue   — default series
brand$secondary  # "#9CAF88"  Monet sage green   — second series in 2-group
brand$neutral    # "#EFE6D2"  warm cream         — backgrounds, "all others"
brand$dark       # "#1A1A1A"  near-black         — raw observed lines, axis text
brand$accent    # "#A03830"  Hokusai crimson    — rare, single high-emphasis

brand_blues      # c("#1F3A5F", "#3A5F87", "#6688AB", "#9DBBD2", "#D2DDE6")
                 # Hokusai-Prussian ramp, dark = high; for ORDERED bins.
                 # For precise magnitude (heatmap, choropleth) use viridis.
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
geom_line(aes(colour = group), linewidth = 2.4)

# Filled points (pch 21–25) — same hex as fill and stroke
geom_point(aes(fill = group, colour = group), shape = 21, size = 7)
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

Copy-pasteable code lives in **`references/recipes.md`** to keep this file scannable:

- [Sorting categorical axes](references/recipes.md#sorting-categorical-axes)
- [Thinning dense axes](references/recipes.md#thinning-dense-axes)
- [Date axes — format and cadence](references/recipes.md#date-axes--format-and-cadence) (ISO `%Y-%m`, two-row labels, 30° tilt for dense breaks)
- [Direct line annotation](references/recipes.md#direct-line-annotation)
- [Coefficient / event-study plot](references/recipes.md#coefficient--event-study-plot)
- [Time trend with overlaid fits](references/recipes.md#time-trend-with-overlaid-fits-raw--models--ci) (raw + models + CI)
- [Designed event line](references/recipes.md#designed-event-line) (vertical annotation: drop-pin + rotated label + tinted post-region)
- [Layer-and-highlight](references/recipes.md#layer-and-highlight--focal-series-in-crimson-all-series-labeled) — focal in crimson, every series still named; includes the vertical-endpoints variant for converging lines
- [Distribution comparisons (ridge plot)](references/recipes.md#distribution-comparisons-ridge-plot)

Read the recipes file before writing a new figure — most patterns are already there.

---

## 7. Output

**One panel per file.** No patchwork, no `plot_annotation(tag_levels = "A")`, no in-R combining. Each chart goes to its own PDF/PNG and is composed in LaTeX.

**Before `ggsave`, run the overflow check** (rule 13). Save first, then **open the file in a PDF viewer** — the RStudio plot pane re-scales and lies. Walk the six checks: (1) tick labels not touching each other, (2) axis title not touching tick labels, (3) endpoint labels not running off the panel, (4) annotations above/below not cropped (use `coord_cartesian(clip = "off")` if needed), (5) long y-category labels not clipped on the left, (6) image wide enough for the fonts (≥ 4.5 in author width at 28 pt axis titles). If a check fails, fix it before exporting — don't shrink the font.

```r
# Always specify width/height so font and line sizes lock in.
# Author at the size you want the figure to OCCUPY in print — do not author
# at 7 in and ask LaTeX to scale to 3.3 in (text halves). For a half-column
# subfigure (~3.3 in), author width = 4–4.5 in; for a column figure, 6–7 in.
ggsave("fig_panel_a.pdf", plot = p_a, width = 4.5, height = 3.3,
       units = "in", device = cairo_pdf)
ggsave("fig_panel_b.pdf", plot = p_b, width = 4.5, height = 3.3,
       units = "in", device = cairo_pdf)
ggsave("fig_panel_a.png", plot = p_a, width = 4.5, height = 3.3,
       units = "in", dpi = 600)
```

**LaTeX composition** (uses `subcaption`; load with `\usepackage{subcaption}`):

```latex
\begin{figure}[t]
  \centering
  \begin{subfigure}[t]{0.48\textwidth}
    \centering
    \includegraphics[width=\linewidth]{fig_panel_a.pdf}
    \caption{Pre-period trend}
    \label{fig:main-a}
  \end{subfigure}\hfill
  \begin{subfigure}[t]{0.48\textwidth}
    \centering
    \includegraphics[width=\linewidth]{fig_panel_b.pdf}
    \caption{Post-period effect}
    \label{fig:main-b}
  \end{subfigure}
  \caption{Headline finding. Source / sample / model lives here, not in the PNG.}
  \label{fig:main}
\end{figure}
```

Panel letters (a / b), sub-captions, the overall caption, and the source note are all TeX — never baked into the figure file.

---

## 8. Cross-references

For regression / descriptive tables (journal star cutoffs, booktabs, never-change-a-number), see [tables.md](../tables.md). When reporting findings back to the user, [report.md](../report.md) carries the deliverable template — figures here are the artifact, the report explains them.

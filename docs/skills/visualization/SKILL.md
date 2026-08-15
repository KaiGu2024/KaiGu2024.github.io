---
name: visualization
title: Visualization
permalink: /skills/visualization/
description: Use when producing publication-ready R + ggplot2 figures for papers or slides. Applies perceptual chart selection; brand, subject-identity, magnitude, and CVD-safe palettes; Lora/Newsreader typography; direct labeling; uncertainty; one standalone panel per script; conditional LaTeX multi-panel assembly; paired PDF + 600-DPI PNG export; and a blocking inspection at intended placement size. Enforces sorted categories, plot-differences-not-raw, explicit units and aggregation, no gridlines, no explanatory titles or captions inside the image, and no clipping or overlap. For regression tables, use the tables skill.
allowed-tools: Read, Edit, Write, Bash
invocation: auto
---

## Contents

1. [Standards](#1-standards) — the 13 rules every figure must obey
2. [Perception](#2-perception) — Cleveland-McGill, channel budget, layer-and-highlight
3. [Decisions](#3-decisions) — pick the chart type, name the color job
4. [Setup](#4-setup) — shared theme, title, save, and palette helpers
5. [Palette rules](#5-palette-rules) — the color constraints that apply to every figure
6. [References](#6-references) — annotations, palettes, and implementation recipes
7. [Output](#7-output) — one standalone panel per file, conditional LaTeX assembly, paired PDF/PNG export
8. [Cross-references](#8-cross-references)

---

## 1. Standards

1. **Tool: R + ggplot2.** Default to ggplot2. Reach for matplotlib/seaborn only if the figure genuinely cannot be made in ggplot2.

2. **Sort categorical axes by value.** No inherent order (countries, brands, models, conditions) → `fct_reorder(var, value)` (descending: `.desc = TRUE`). Alphabetical wastes the strongest pre-attentive channel — position. Exceptions: time, naturally-ordered categories (Likert, age bins), or a fixed external ordering that is itself the comparison.

3. **Y-axis range.** Lower bound: start at 0 (or 100 for indexed series); deviate only if the entire range is far from zero AND within-data variation is the story — disclose explicitly. Upper bound: for unbounded metrics, let ggplot's 5% expansion handle headroom (don't pad to round numbers); for bounded metrics (percent, share, Likert), set the axis to the cap (100, 1.0, 5, 7) regardless of data range.

4. **Direct annotation, no legends.** Label every line or group the reader needs to identify, including background series; highlighting changes color, not label coverage. Horizontal-bar ticks may serve as labels. Suppress redundant guides, keep labels in white space, and facet or change encoding if required labels cannot fit. Read [annotations.md](references/annotations.md) whenever adding or positioning text.

5. **High DPI.** `dpi = 600` (or PDF vector). *Science*/*Nature* minimum at submission.

6. **Oversize every component so figure text reads larger than body text.** Author at the declared placement size (rule 13), with export and placement widths within 10%, so final text remains close to its designed physical size and still beats 11 pt body text. Default ggplot fonts (~11 pt) and lines (~0.5 pt) are far too small:
   - Axis titles **26–30 pt**; tick labels **22–26 pt**; inline / annotation labels **20–26 pt** (`geom_text(size = 7–9)` — ggplot text `size` is mm, ≈ 2.83 × pt)
   - Strip text (facets, if any) **22–26 pt** bold
   - Data lines `linewidth = 2.8` for **sparse** figures (few or monthly points — the default); step down to `2.4` when the series is **dense** (weekly+ points, busy path); reference / zero / vline lines 1.2–1.5; axis lines 1.1; ticks 1.0
   - Points `size = 9` for **sparse** figures (the default); `size = 7` when dense (and thin the markers — §5); ribbon `alpha = 0.18–0.22`. Keep the marker-to-line ratio near 3:1 — a 9-marker sits on a 2.8 line, a 7-marker on a 2.4 line; don't pair a fat marker with a thin line (beads-on-a-string) or vice versa.
   - **No plot title / subtitle / caption / tag inside the image** — see rule 10.

7. **Thin out dense axis ticks.** Crowded labels → drop ticks, don't shrink fonts. Use ISO dates, `scales::pretty_breaks(n = 6)`, alternate categorical labels, `guide_axis(n.dodge = 2)`, or `coord_flip()` for long categories. Rotate only short standardized ticks such as dates; see [annotations.md](references/annotations.md) and [recipes.md](references/recipes.md).

8. **Plot differences, not raw values.** Compute the gap (treatment − control) and plot one value per group, sorted by the difference. Two side-by-side bars force mental subtraction; the diff makes the comparison explicit.

9. **Calculate before you graph.** Pre-aggregate with dplyr, plot with `stat = "identity"`. Geom-side stats (`after_stat(prop)`, `stat_summary`) fail in surprising ways with grouped/multi-variable aggregation; the summary table is itself a useful artifact.

10. **No explanatory text except direct data labels and designed annotations.** Axis titles and tick labels are the only structural text inside the image; direct data labels and designed annotations from rule 4 are allowed. **Do not** set `plot.title`, `plot.subtitle`, `plot.caption`, or `plot.tag`; those belong in LaTeX (`\caption{}`, section prose, slide chrome) where they can be re-edited without re-rendering the figure. Notes, sample descriptions, model details, and any panel letter all live in TeX, not in the PNG/PDF.

    Use self-contained, sentence-case axis titles of roughly 3–6 words that state the metric and aggregation, with the measurement unit in parentheses at the end when needed. Format ticks with `scales::label_*`; use `y = NULL` only when y ticks already name each item. Follow the three-layer unit-disclosure rule in [annotations.md](references/annotations.md), which separates the axis label, LaTeX caption or panel subtitle, and figure note.

    **One standalone panel per file.** Generate every report panel independently with its own script and matched PDF/PNG pair; do not combine panels in R with patchwork or similar tools. Combine the exported panels in LaTeX under one figure number only when they jointly establish one argument and use compatible units, populations, and denominators. Otherwise use separate figure floats. A faceted plot that forms one small-multiple encoding over a shared variable remains one panel for this rule.

11. **Show uncertainty.** Confidence intervals always — `geom_ribbon(alpha = 0.18–0.22)` for continuous, error bars for discrete. Point estimates without uncertainty convey false precision.

12. **No gridlines.** Drop both major and minor gridlines, panel border, and redundant ticks (Tufte taken further than the usual "faint major" compromise). The axis line + ticks carry value-lookup; lengthen ticks (`axis.ticks.length ≈ 6 pt`) and use `scales::pretty_breaks(n = 6–8)` so the axis itself is the lookup aid. When a specific numeric value is part of the message — endpoint of a line, peak of a curve, a single bar — direct-label it with `geom_text` instead of asking the reader to interpolate against a grid. `theme_pub()` (§4) implements this.

13. **Blocking layout acceptance gate: nothing clips, touches, overlaps, or wastes space.** A figure is not complete when `ggsave()` succeeds. It is complete only after the saved artifact has been opened and inspected at its intended manuscript or slide placement size.

    1. **Declare geometry before constructing the plot.** Set export width, export height, and intended placement width first with `figure_spec()`. Use the same physical unit for export and placement. Export width and placement width may differ by no more than 10%; do not export large and substantially shrink in LaTeX. At 28 pt axis titles, author width is normally at least 4.5 in.
    2. **Save paired artifacts.** Use `save_figure()` to write the publication PDF and a white-background `-qa.png` at identical dimensions and aspect ratio. The PNG is an inspection artifact, not a substitute for the PDF.
    3. **Open the saved artifact itself.** Inspect the PNG or a rasterized PDF with an image-viewing tool, never only the RStudio plot pane. View it at the declared placement width. For TeX output, rebuild the report and inspect the placed figure in the report PDF too.
    4. **Audit unit consistency.** Verify that the code's aggregation level, axis label, LaTeX caption or panel subtitle, surrounding prose, and figure note describe the same observation unit, population, and denominator. Never alternate casually among units such as languages, repositories, models, and foundation models.
    5. **Reject and regenerate on any failure.** Reject if an axis title is cropped, touches a tick label, or touches an edge; tick labels touch, overlap, or truncate; any direct label or designed annotation crops or overlaps another label or mark; an exceptionally permitted legend is incomplete or touches an edge; or avoidable empty space makes text or data materially smaller at final placement.
    6. **Repair in this order.** Shorten or wrap axis titles and annotations with `labs_pub()` (defaults: 32 characters per x-title line, 26 per y-title line); thin breaks, use `guide_axis(n.dodge = 2)`, or flip long categorical axes; reserve a data-scale annotation gutter with `expand`; use `ggrepel`; select the relevant `theme_pub(gutter = ...)` margin profile or increase the device dimension; then change the layout or encoding. Right-side direct labels require both scale expansion and `theme_pub(gutter = "right")`. Never solve overflow by shrinking text below rule 6's minimum sizes.
    7. **Report only the verified state.** Do not report completion unless the rendered artifact passes. If no image-viewing or PDF-rendering tool is available, report it as **generated but layout-unverified**.

    Use [annotations.md](references/annotations.md) and the relevant [recipe](references/recipes.md) for direct-label rails, off-panel annotations, wrapping, and collision repairs; keep their overflow protections when adapting them.

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

Spatial region (facet) → color hue → motion → shape. Reserve hue for the categorical distinction; shape is the **default redundant** channel — map it to the same variable as hue so the figure survives grayscale and colorblindness. Never map shape to a *second* variable.

### Channel budget

Color and luminance pop pre-attentively; shape, angle, size do not. **Hard rule: at most one *variable* encoded beyond position.** If you find yourself mapping two *different* variables to color + shape (color = platform, shape = country), facet instead.

**Redundant encoding is exempt — and is the default for multi-series lines.** Mapping the *same* variable to both color and shape (ChatGPT = blue *and* circle) is one variable shown twice, not two channels of information; it does not spend the budget. It buys grayscale/B&W survival, colorblind safety, and disambiguation where two lines cross (the marker still names the series at the touch point). For 3–5 equal-weight line+point series, do this by default (§5).

### Gestalt — connection and proximity dominate color similarity

Items linked by a line read as a group even if differently colored. Use deliberately (group structure via spacing/lines); avoid accidentally (don't let layout suggest groupings the data doesn't support).

### Layer-and-highlight pattern

For "this country/firm/domain vs. all others": plot all data in `grey80`, plot the focal subset on top in a saturated accent, and label every series at its endpoint — focal in the accent, others in `grey50`. When a focal subject recurs, use its fixed project color from [palettes.md](references/palettes.md#locked-subject-identity), not generic crimson. See the layer-and-highlight recipe in `references/recipes.md`.

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
| **Magnitude (rank)** | Sorted bars colored by tertile | Brand sequential ramp (`brand_blues`); `subject_ramp()` if the figure is about one subject |
| **Magnitude (precise)** | Choropleth, heatmap, density | Viridis |
| **Signed deviation** | Coefficient vs. baseline, residual | Diverging |
| **Emphasis** | "ChatGPT vs. all platforms" | Layer-and-highlight (gray + accent, or the focal subject's [fixed color](references/palettes.md#locked-subject-identity)) |

---

## 4. Setup

The theme function, title wrappers, figure specification/save helpers, brand palette, sequential ramp, and global ggplot defaults all live in `scripts/theme_pub.R`. Source it from the project's one shared `_setup.R` (see "One script per panel" below) — don't copy-paste or fork these definitions, because improvements to the central skill do not propagate into local copies.

```r
library(ggplot2)
library(dplyr)
library(forcats)
library(ggrepel)
library(scales)
# Note: no patchwork — one standalone panel per file; combine only in LaTeX when warranted.

source("~/.claude/skills/visualization/scripts/theme_pub.R")

# If Newsreader / Lora aren't installed system-wide, register them per session:
showtext::font_add_google("Newsreader", "Newsreader")
showtext::font_add_google("Lora",       "Lora")
showtext::showtext_auto()
```

This loads `theme_pub()` (already applied via `theme_set()`), `labs_pub()`, `figure_spec()`, `save_figure()`, palette helpers, and discrete color defaults. Use Lora for axis titles and facet strips and Newsreader for ticks and annotations.

### One script per panel

**One runnable script per panel.** Each standalone figure or report panel is produced by its own self-contained script (e.g. `figures/fig_<slug>.R`) that writes exactly **one matched PDF/PNG pair**. Never put several panels in one serial script — that forces them to render one after another.

**One shared project setup, not divergent local copies.** Factor the common preamble — the `library()` calls, the single `source(".../theme_pub.R")`, the `showtext` font registration above, project subject mappings, and any shared data prep — into one project-level `_setup.R` that every figure script sources. Do not redefine `theme_pub()`, `labs_pub()`, `figure_spec()`, or `save_figure()` in project/subproject setup files. When divergent copies already exist, replace them with thin forwarding setup files that source the one project helper; merely improving the central skill will not update copied functions. Cache expensive data prep to disk (e.g. `saveRDS()` / `readRDS()`) so each job reads the prepared data instead of recomputing it.

```r
# figures/fig_referral_share.R
source("_setup.R")                 # theme + fonts + palette + cached data
spec <- figure_spec(
  stem = "fig_referral_share",
  width = 4.5, height = 3.3,
  placement_width = 4.5
)
dat <- readRDS("_cache/panel.rds")
# ... build p ...
save_figure(p, spec)
```

Because each script is independent, panels can render simultaneously under any parallel launcher: one panel = one matched artifact pair = one script = one job.

Read [palettes.md](references/palettes.md) for palette slots, subject mappings, scale code, and CVD checks. `scripts/theme_pub.R` remains the executable source of truth.

**Greek and math symbols.** Use Unicode directly in labels: `α`, `β`, `μ`, `σ²`, `≥`, `×`. Symbol-font glyphs tofu in modern PDF readers.

---

## 5. Palette rules

- Use `brand$primary` for one series and the dusty-blue/sage pair for binary comparisons.
- For 3–5 equal-weight line series, map the same variable to color and redundant shape; past five, facet or layer-and-highlight.
- Assign recurring subjects one fixed project-level color and shape from `subject_palette`; use different hue families when highlighting several subjects.
- Use `brand_blues` or `subject_ramp()` for rank only, viridis/cividis for precise magnitude, and a diverging scale only around a meaningful midpoint.
- Keep non-focal series grey and reserve saturated colors for subject identity, not decoration.
- Check grayscale and common color-vision deficiencies before acceptance.

Read [palettes.md](references/palettes.md) when choosing anything beyond the default single-series or binary palette. It contains slot definitions, rationale, and scale code.

---

## 6. References

- Read [annotations.md](references/annotations.md) when writing or positioning axis text, direct labels, callouts, or event annotations.
- Read [palettes.md](references/palettes.md) when selecting categorical, identity, sequential, diverging, or CVD-safe color encodings.
- Read the relevant section of [recipes.md](references/recipes.md) before implementing a chart pattern or export workflow. It covers sorting, axes, paired export, direct labels, multi-series lines, event studies, model overlays, event lines, layer-and-highlight, and ridge plots.

---

## 7. Output

**One standalone panel per file.** No patchwork, no `plot_annotation(tag_levels = "A")`, and no in-R panel combining. Each panel gets its own PDF/PNG pair. Combine panels in LaTeX under one figure number only when they jointly establish one argument and use compatible units, populations, and denominators; otherwise give each panel its own figure float.

**The blocking acceptance gate in rule 13 governs every export.** Declare geometry before constructing the plot, save the paired PDF and white-background PNG, open the artifact at placement size, and inspect the rebuilt report PDF when TeX is the destination. A successful save is not acceptance.

Use the paired-export and TeX-placement examples in [recipes.md](references/recipes.md#figure-specification-paired-export-and-qa). Relationship alone is insufficient for combining panels; the panels must jointly support one claim and remain directly comparable.

---

## 8. Cross-references

For regression / descriptive tables (journal star cutoffs, booktabs, never-change-a-number), see [tables/SKILL.md](../tables/SKILL.md). When reporting findings back to the user, [report.md](../report.md) carries the deliverable template — figures here are the artifact, the report explains them.

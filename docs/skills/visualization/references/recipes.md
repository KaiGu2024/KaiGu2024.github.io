# Recipes

Copy-pasteable code for common figures. Assumes the shared `theme_pub.R` helpers and `brand` palette from SKILL.md §4 are loaded. Text sizes follow SKILL.md §1.6: 20 pt axis titles, 16 pt ticks, 16–18 pt direct labels, and 18 pt facet strips at manuscript placement size.

For complete runnable examples and their rendered PDFs, use the [visual gallery](../guidance/gallery.md). This file supplies reusable fragments and additional patterns; the gallery scripts own the complete teaching examples.

## Contents

1. [Figure specification, PDF export, and QA](#figure-specification-pdf-export-and-qa)
2. [Sorting categorical axes](#sorting-categorical-axes)
3. [Subject-anchored rank ramp](#subject-anchored-rank-ramp)
4. [Thinning dense axes](#thinning-dense-axes)
5. [Date axes](#date-axes--format-and-cadence)
6. [Axis number formatting](#axis-text--number-formatting)
7. [Direct line annotation](#direct-line-annotation)
8. [Multi-series lines](#multi-series-lines--redundant-shape-per-series)
9. [Coefficient and event-study plots](#coefficient--event-study-plot)
10. [Time trends with model fits](#time-trend-with-overlaid-fits-raw--models--ci)
11. [Designed event lines](#designed-event-line)
12. [Layer-and-highlight](#layer-and-highlight)
13. [Distribution comparisons](#distribution-comparisons-ridge-plot)
14. [Joint quantile grid](#joint-quantile-grid)

## Joint quantile grid

Consider this optional diagnostic for overlap between two ranked variables and concentration of activity. Inspiration: [Winkler et al. (2026), Figure 3](https://link.springer.com/article/10.1007/s11129-026-09312-2/figures/3), which crosses Spotify-stream and TikTok-creation deciles. Adapt the construction to the question; 10×10 is not mandatory.

- **Define bins.** Use one record per intended unit and a stated measurement window. Bin each variable separately over the same reference sample, then cross the two marginal classifications. Choose 3×3 (tertiles), 5×5 (quintiles), 10×10 (deciles), or another resolution supported by occupancy and placement size. These are rank intervals, not equal-width intervals in original units; equal marginal counts do not imply equally populated cells.
- **Handle ties and comparisons.** Preserve ties with documented cutpoints, accepting fewer or uneven bins; consider a separate zero category for a large zero mass. Do not silently split equal values to force the requested grid. Report missing/excluded units. For comparable groups or periods, use common reference cutpoints; for baseline-defined treatment heterogeneity, construct and freeze bins before treatment.
- **Choose the cell statistic.** Observation share is `n_cell / N`; activity share is `sum(z_in_cell) / sum(z_in_sample)` for a named nonnegative measure with a positive total. State weights and the denominator. Row/column percentages answer different, conditional questions and must be labeled accordingly. Retain counts alongside activity shares; use separate panels for different measures.
- **Draw and label.** Pre-aggregate, then use `geom_tile()` with a sequential magnitude palette or a bubble matrix with area proportional to the statistic (`scale_size_area()`). Keep axes ordered low to high. Use readable percentages in cells where feasible; a compact color/size key is allowed when needed to decode magnitude. Distinguish empty cells, missing values, and rounded near-zero shares. Reduce bin count if labels crowd; do not shrink text to force 100 cells.
- **Check.** Save cutpoints and the cell summary. Verify counts reconcile and unconditional shares sum to 100% before rounding. Inspect at placement size. Describe where units and activity concentrate; this descriptive plot does not establish a treatment effect.

## Figure specification, PDF export, and QA

Declare export geometry and intended placement width before constructing the plot. `figure_spec()` blocks export/placement mismatches above 10%; `save_figure()` writes only a publication PDF with a white background. Saving does not certify the layout: open the saved PDF at placement size and inspect the rebuilt report PDF when TeX is the destination.

```r
spec <- figure_spec(
  stem = "figures/fig_referral_share",
  width = 4.5, height = 3.3,
  placement_width = 4.5
)

p <- ggplot(df, aes(x = source, y = share)) +
  geom_col(fill = brand$primary) +
  labs_pub(x = "Referral source category",
           y = "Average referral share (%)")

paths <- save_figure(p, spec)
# Open paths[["pdf"]] with a PDF-viewing or rendering tool at 4.5 in.
# If raster inspection is needed, render the saved PDF to
# <project-root>/exploratory/previews/fig_referral_share-qa.png.
# Keep /exploratory/previews/ in the project's .gitignore.
```

`labs_pub()` wraps x titles at 32 characters and y titles at 26 by default; override `x_width` or `y_width` only when the rendered artifact shows a better break. For right-side direct labels, reserve both kinds of space:

```r
p +
  scale_x_continuous(expand = expansion(mult = c(0.02, 0.18))) +
  theme_pub(gutter = "right")
```

The scale expansion creates a data-space label rail; the gutter profile adds device-edge clearance. Neither replaces opening and inspecting the saved artifact.

For a single-panel TeX figure, place the PDF at the declared physical width:

```latex
\begin{figure}[t]
  \centering
  \includegraphics[width=4.5in]{fig_referral_share.pdf}
  \caption{Headline finding. Source, sample, and model details live here.}
  \label{fig:referral-share}
\end{figure}
```

Inspect the rebuilt report PDF. Generate every report panel as its own script and PDF. Combine panels in LaTeX under one figure number only when they jointly establish one argument and use compatible units, populations, and denominators; otherwise place them in separate floats. Keep panel subtitles, letters, and the shared caption in LaTeX rather than baking them into the image files.

## Sorting categorical axes

```r
# Bar plot sorted by value, horizontal layout for long labels
df |>
  mutate(domain = fct_reorder(domain, share)) |>
  ggplot(aes(x = share, y = domain)) +
  geom_col(fill = brand$primary) +
  scale_x_continuous(labels = label_percent(accuracy = 1),
                     expand = expansion(mult = c(0, 0.05))) +
  labs(x = "Referral share", y = NULL)
```

For "one bar plot per platform," export each platform panel independently. Combine them in LaTeX only if the platform panels jointly establish one comparison using compatible units, populations, and denominators; otherwise use separate figure floats. Use `facet_wrap()` only when the facets constitute one small-multiple encoding over a shared variable rather than separately authored report panels.

## Subject-anchored rank ramp

When the whole figure is about one subject and bars are shaded by rank (tertiles, quantiles, ordered bins), build the ramp from that subject's identity hue so the value shading matches its categorical colour elsewhere. `subject_ramp()` (`theme_pub.R`) returns dark = high, drop-in for `brand_blues`. Use only for *rank* on a *single* subject — precise magnitude stays viridis, multi-subject value figures stay on one neutral ramp (SKILL.md §5).

```r
subject_hex <- "#2251FF"   # this subject's fixed identity colour (subject_palette)

df |>
  mutate(domain = fct_reorder(domain, share),
         bin    = cut(share, breaks = 3, labels = c("low", "mid", "high"))) |>
  ggplot(aes(x = share, y = domain, fill = bin)) +
  geom_col(colour = NA) +
  scale_fill_manual(values = rev(subject_ramp(subject_hex, 3))) +  # high bin = darkest
  scale_x_continuous(labels = label_percent(accuracy = 1),
                     expand = expansion(mult = c(0, 0.05))) +
  guides(fill = "none") +                       # bins are self-evident from order
  labs(x = "Referral share", y = NULL)

# Continuous value instead of discrete bins:
#   scale_fill_gradientn(colours = rev(subject_ramp(subject_hex)))
```

`colorspace` must be installed (`subject_ramp` calls it namespaced). If a bin legend is genuinely needed, drop the `guides(fill = "none")` and label it; usually the sort order already conveys rank.

## Thinning dense axes

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

## Date axes — format and cadence

Default to ISO `%Y-%m` (`2024-12`) — fixed-width, 7 chars, no ambiguity. Avoid `Dec 2024` (variable width: May vs. September) and `2024/12` (reads less like a date). Target **5–7 labels across the full x-range**:

```r
# ≤ 1.5 years
scale_x_date(date_breaks = "2 months", date_labels = "%Y-%m",
             expand = expansion(mult = c(0.02, 0.05)))

# 1.5–4 years (quarterly — aligns to fiscal Qs)
scale_x_date(date_breaks = "3 months", date_labels = "%Y-%m")

# 4–8 years
scale_x_date(date_breaks = "6 months", date_labels = "%Y-%m")

# > 8 years
scale_x_date(date_breaks = "2 years",  date_labels = "%Y")
```

**Two-row labels** — month on row 1, year on row 2 — buy ~30% more label density without rotation. Repeat the year only at January; leave it blank in other months so the eye doesn't see "2024" stacked twelve times:

```r
two_row_date <- function(x) {
  ifelse(format(x, "%m") == "01" | seq_along(x) == 1,
         format(x, "%b\n%Y"),
         format(x, "%b"))
}

scale_x_date(date_breaks = "1 month", labels = two_row_date,
             expand = expansion(mult = c(0.02, 0.05)))
```

**Tilted dense labels — fit ~3× more breaks.** When you want a tighter cadence than the table allows (every 2 months on a 4-year panel, monthly on an 18-month panel), tilt the labels 30°. Dates are short and standardized, so the tilt reads fine — this is the publication standard for time-series x-axes (see rule 4 for why prose is different):

```r
# Every 2 months on a 2-4 year panel, tilted 30°
scale_x_date(date_breaks = "2 months", date_labels = "%Y-%m",
             expand = expansion(mult = c(0.02, 0.05)))
+ theme(axis.text.x = element_text(angle = 30, hjust = 1,
                                   margin = margin(t = 6)))
```

`hjust = 1` right-anchors the label so its end sits under the tick mark; `margin(t = 6)` adds breathing room between the rotated text and the axis line. If labels still feel crowded after tilting, escalate to two-row labels rather than going steeper than 30°.

For numeric-year axes (`2018, 2019, …`), use `scales::pretty_breaks(n = 6)` and let ggplot pick.

## Axis text — number formatting

Keep tick labels short and fixed-width — format with `scales::label_*`, never raw digit strings or scientific-notation tofu (`1e+05`). Pick by what the number is (SKILL.md rule 10, "Axis text"):

```r
scale_y_continuous(labels = label_percent(accuracy = 1))            # 0.42  -> 42%
scale_y_continuous(labels = label_dollar())                         # 1500  -> $1,500
scale_y_continuous(labels = label_number(scale_cut = cut_short_scale()))  # 1.2e6 -> 1.2M
scale_y_continuous(labels = label_comma())                          # 1500000 -> 1,500,000
```

`cut_short_scale()` gives k / M / bn suffixes — use it whenever values run past ~10,000 so the axis doesn't show long digit strings or `2e+05`. Axis *titles* carry the unit in parentheses (`Daily visits (thousands)`), so don't repeat it on every tick.

## Direct line annotation

```r
labels <- df |> group_by(group) |> slice_max(year, n = 1) |> ungroup()

ggplot(df, aes(x = year, y = outcome, colour = group)) +
  geom_line(linewidth = 2.8) +
  geom_text_repel(
    data = labels, aes(label = group),
    hjust = 0, nudge_x = 0.2, direction = "y",
    segment.colour = NA, size = 16 / ggplot2::.pt, family = "Newsreader"
  ) +
  scale_y_continuous(labels = label_percent(accuracy = 1)) +
  scale_x_continuous(expand = expansion(mult = c(0.02, 0.15))) +
  labs_pub(x = "Calendar year", y = "Average outcome value (%)") +
  theme_pub(gutter = "right")
```

## Multi-series lines — redundant shape per series

3–5 equal-weight series, each its own colored line, with a redundant shape so the figure survives grayscale / colorblindness and reads where lines cross. `shape` and `fill` map to the **same** variable as the line `colour` (SKILL.md §5); shape rides redundant on color and so doesn't spend the channel budget. `brand_shapes <- c(21, 24, 22, 23, 25)` comes from `theme_pub.R`.

```r
pal <- setNames(series_palette(3), c("A", "B", "C"))

labels <- df |> group_by(group) |> slice_max(month, n = 1) |> ungroup()

ggplot(df, aes(x = month, y = value, colour = group)) +
  geom_line(linewidth = 2.8) +                             # monthly = sparse
  geom_point(aes(fill = group, shape = group),
             size = 9, stroke = 1.0, colour = "white") +   # white halo
  geom_text_repel(data = labels, aes(label = group),
                  hjust = 0, nudge_x = 0.2, direction = "y",
                  segment.colour = NA, size = 16 / ggplot2::.pt,
                  family = "Newsreader") +
  scale_colour_manual(values = pal) +
  scale_fill_manual(values   = pal) +
  scale_shape_manual(values  = brand_shapes) +
  scale_x_continuous(expand = expansion(mult = c(0.02, 0.15))) +
  labs_pub(x = "Calendar month", y = "Average outcome value (units)") +
  theme_pub(gutter = "right")
```

The white `colour` on `geom_point` haloes each filled marker so it stays crisp sitting on its own line and at crossings. Endpoint labels (rule 4) still name every series — the shape is a redundant aid, not a substitute for the label.

**Weekly (or denser) data — thin the markers and lighten the weight.** A marker on every monthly point reads fine; on weekly data it beads the line. Drop from the sparse default to the lighter dense weight (`size = 7`, `linewidth = 2.4`), keep `geom_line` on the full series, and feed `geom_point` every 4th week plus each series' last point:

```r
mk <- df |>
  arrange(group, month) |>
  group_by(group) |>
  filter(row_number() %% 4 == 1 | row_number() == n()) |>
  ungroup()

  geom_line(data = df, linewidth = 2.4) +                  # full line, lighter (dense)
  geom_point(data = mk, aes(fill = group, shape = group),
             size = 7, stroke = 1.0, colour = "white") +   # thinned markers
```

Past weekly cadence, drop per-point markers entirely — distinguish by color + linetype (see "Time trend with overlaid fits"), or facet.

## Coefficient / event-study plot

**Default: fine dots and individual confidence intervals.** This is a house-style starting point; connecting estimates at discrete event times is also valid. Use consistent design criteria across related outcomes and specifications. Horizontal coefficient plots use the same mark hierarchy, with intervals along x.

Follow [event-study axis wording and normalization](annotations.md#event-study-axes). The example assumes monthly event time, first treatment at 0, employment effects and interval endpoints already expressed in percentage points, and a single omitted month −1. `es` contains only estimated periods. Substitute the source's actual event, scale, and base-period scheme; do not relabel raw coefficients without converting them.

```r
ink <- brand_blues[1]  # deep navy; use an existing subject color when applicable

ggplot(es, aes(x = period, y = coef)) +
  geom_hline(yintercept = 0, colour = "grey65", linewidth = 0.4) +
  # Boundary between last untreated month (-1) and first treated month (0).
  geom_vline(xintercept = -0.5, linetype = "dashed",
             colour = "grey65", linewidth = 0.4) +
  geom_errorbar(aes(ymin = lo, ymax = hi), width = 0.18,
                colour = ink, linewidth = 0.65) +
  geom_point(size = 2.6, colour = ink) +
  # Normalization only: hollow point, no estimated interval.
  annotate("point", x = -1, y = 0, shape = 21, fill = "white",
           colour = ink, size = 2.6, stroke = 0.65) +
  labs_pub(x = "Months relative to first treatment",
           y = "Employment (percentage points)") +
  theme_pub(style = "estimate")
```

**Size at the actual placement.** These starting weights suit a full-width figure around 7.2 inches: points 2.6, intervals 0.65, references 0.4 in ggplot units. The estimate theme supplies lighter axes and ticks while preserving Lora/Newsreader at 20/16 pt. Keep reference lines gray and visually subordinate. Short caps or uncapped `geom_linerange()` are both acceptable; cap width is in time-axis units, so adapt it to period spacing. Retain all estimated points and intervals; thin axis ticks, not estimates. Narrow layouts may need smaller marks or a different aspect ratio, checked at placement size.

**Preserve the inference.** Include zero and every interval endpoint. A normalized reference marker has no estimated interval; do not create one or assume every design uses month −1. Put the actual reference scheme, confidence level, coverage and clustering in the note. Multiple series need consistent color/shape identities and, if needed, modest horizontal offsets that preserve period identity or separate panels.

**Connecting lines are optional.** They can help make an abrupt change, a turning point, or the separation between overlapping paths easier to read. Judge the saved figure at placement size: choose line weight to suit point spacing, series density and visual emphasis, while keeping estimates and intervals legible. Neither thin nor heavy lines are universally required. If adding connectors, apply them consistently within each comparable path rather than only to selected large jumps. Break them across missing periods or incomparable bins; join estimates without fitting a smoother.

**Uncertainty is a separate choice.** A connecting line can accompany individual intervals; it does not require a ribbon. A ribbon may be used when it makes uncertainty easier to read, with its interpretation stated in the note. For discrete estimates, shading between periods is a visual connection, not additional estimates. Preserve the supplied interval endpoints and coverage: shading does not turn pointwise intervals into a simultaneous band.

These choices follow the distinction between individual values and connected paths in [Wilke's time-series guidance](https://clauswilke.com/dataviz/time-series.html). Both event-study styles are supported by the [fect plotting documentation](https://yiqingxu.org/packages/fect/11-plots.html). Our dot default and mark weights express the user's preferred style, not a universal ranking of the two displays.

Export at the intended placement width using `figure_spec()`; 7.2 inches is an example, not a required canvas. Do not shrink a larger PDF into a narrow column to make its marks look finer. Keep the 10% width tolerance and inspect the placed result.

## Time trend with overlaid fits (raw + models + CI)

Three weights: raw series in `brand$dark` at `linewidth = 1.0` (reference); fitted lines distinguished primarily by **linetype** (so the figure reads in grayscale), secondary by hue, at `linewidth = 2.8` (the sparse default — smooth fits carry no markers); one CI ribbon for the primary fit (`fill = "grey70", alpha = 0.25`).

```r
ggplot(df, aes(x = year, y = value)) +
  geom_ribbon(data = filter(df, series == "loess"),
              aes(ymin = lo, ymax = hi),
              fill = "grey70", alpha = 0.25, colour = NA) +
  geom_line(data = filter(df, series == "raw"),
            colour = brand$dark, linewidth = 1.0) +
  geom_line(data = filter(df, series != "raw"),
            aes(linetype = series, colour = series),
            linewidth = 2.8) +
  scale_linetype_manual(values = c(linear = "dashed",
                                   loess  = "solid",
                                   poly   = "dotted")) +
  scale_colour_manual(values = setNames(series_palette(3), c("linear", "loess", "poly"))) +
  geom_text_repel(
    data = filter(df, series != "raw") |>
             group_by(series) |> slice_max(year, n = 1),
    aes(label = series, colour = series),
    hjust = 0, nudge_x = 1, direction = "y",
    segment.colour = NA, size = 16 / ggplot2::.pt, family = "Newsreader"
  ) +
  scale_x_continuous(expand = expansion(mult = c(0.02, 0.15))) +
  labs_pub(x = "Calendar year", y = "Average outcome value (units)") +
  theme_pub(gutter = "right")
```

## Designed event line

A vertical event line goes from "engineering schematic" to "designed annotation" by combining four moves: a short dashed segment that dies inside the data field (not a full-panel rule), a crimson drop-pin at the top, a rotated label hanging off the pin, and a faint tint over the post-event region. The reader sees "something changed here" before reading the label.

```r
# Inputs you set per figure
ev      <- as.Date("2024-03-15")    # the event x-position
y_min   <- 0                         # bottom of plotting region for the segment
y_top   <- max(df$y) * 0.92          # segment ends below the data peak
y_label <- max(df$y) * 0.95          # where the rotated label sits

ggplot(df, aes(x = date, y = y)) +

  # 1. Tinted post-event region — silent context, alpha so it doesn't dominate
  annotate("rect",
           xmin = ev, xmax = max(df$date),
           ymin = -Inf, ymax = Inf,
           fill = brand$accent, alpha = 0.06) +

  # 2. Short dashed segment, dies before the top axis
  annotate("segment",
           x = ev, xend = ev, y = y_min, yend = y_top,
           colour = brand$accent, linewidth = 1.3,
           linetype = "dashed") +

  # 3. Drop-pin at the top of the segment
  annotate("point",
           x = ev, y = y_top,
           shape = 21, size = 5,
           fill = brand$accent, colour = "white", stroke = 0.9) +

  # 4. Rotated label hanging off the pin.
  # angle = 90 (NOT -90 or 270) — text reads bottom-to-top, head tilts LEFT.
  # hjust = 1 puts the END of the label at y_label, so the text hangs
  # downward from the pin and the reader's eye runs UP toward the event.
  annotate("text",
           x = ev, y = y_label,
           label = "Policy enacted, 2024-03",
           angle = 90, hjust = 1, vjust = -0.4,
           size = 16 / ggplot2::.pt, family = "Newsreader",
           colour = "grey30") +

  # Data on top of all of the above
  geom_line(linewidth = 2.8, colour = marks$primary) +

  labs(x = "Date", y = "Outcome")
```

Variations:

- **Multiple events.** Use `grey40` for all event lines and let the rotated labels carry the distinction. Reserve `brand$accent` for the single event that matters most.
- **Date range, not a point.** Replace the `segment` with a wider `annotate("rect", xmin = start, xmax = end, ...)` at low alpha; drop the pin; label the range above the rect.
- **Bottom anchor.** If the data peaks at the top, anchor the pin at the bottom instead (`y = y_min`) with `vjust = 1.4` so the label hangs below.
- **No tint.** If the post-event region runs off the panel or there's no meaningful "after," omit the `rect` — keep the dashed segment + pin + label alone.

The "dies before the top axis" trick is what most people miss. A full-height `geom_vline` reads as a chart axis, not as data context.

## Layer-and-highlight

Use the [emphasis hierarchy](palettes.md#emphasis-hierarchy) and [selective-label rules](annotations.md#direct-label-coverage). Keep all observations; choose individual labels for relevance. Use a project subject color in place of `emphasis$focal` when already assigned.

For many trajectories, label focal subjects and required comparators, and identify the remaining context collectively in the caption. This example assumes one focal platform; `required_comparators` is an explicit set from the figure brief, possibly empty.

```r
focal <- "ChatGPT"
required_comparators <- character(0)
focal_colour <- emphasis$focal  # use the existing project mapping when present

endpoints <- df |>
  filter(platform %in% c(focal, required_comparators)) |>
  group_by(platform) |>
  slice_max(week, n = 1, with_ties = FALSE) |>
  ungroup() |>
  mutate(label_colour = ifelse(platform %in% focal,
                               focal_colour, emphasis$summary))

p <- ggplot(df, aes(week, visits, group = platform)) +
  geom_line(data = filter(df, !platform %in% c(focal, required_comparators)),
            colour = emphasis$context, linewidth = 0.5) +
  geom_line(data = filter(df, platform %in% required_comparators),
            colour = emphasis$comparison, linewidth = 0.8, linetype = "dashed") +
  geom_line(data = filter(df, platform %in% focal),
            colour = focal_colour, linewidth = 1.2) +
  geom_text_repel(
    data = endpoints, aes(label = platform, colour = label_colour),
    size = 16 / ggplot2::.pt, family = "Newsreader",
    hjust = 0, nudge_x = 1, direction = "y", max.overlaps = Inf,
    segment.colour = emphasis$comparison, min.segment.length = 0
  ) +
  scale_colour_identity() +
  scale_x_continuous(expand = expansion(mult = c(0.02, 0.22))) +
  labs_pub(x = "Observation week", y = "Weekly platform visits (thousands)") +
  theme_pub(gutter = "right")
```

For dense scatterplots, use smaller marks and label only the selected observations. Here `df` has `x`, `y`, `subject`, an evidence-based `role` (`context`, `comparison`, or `focal`), and `show_label` chosen by the brief. Use only the roles actually present. Supply substantive axis titles and identify the actual groups in the caption or with direct group annotations.

```r
role_colours <- unlist(emphasis[c("context", "comparison", "focal")])
plot_data <- df |>
  mutate(role = factor(role, levels = names(role_colours))) |>
  arrange(role)  # focal points drawn last

p <- ggplot(plot_data, aes(x, y)) +
  geom_point(aes(colour = role, shape = role), size = 2.8) +
  geom_text_repel(
    data = filter(plot_data, show_label), aes(label = subject),
    colour = emphasis$summary, size = 16 / ggplot2::.pt,
    family = "Newsreader", max.overlaps = Inf,
    min.segment.length = 0, segment.colour = emphasis$comparison
  ) +
  scale_colour_manual(values = role_colours) +
  scale_shape_manual(values = c(context = 16, comparison = 16, focal = 17)) +
  theme_pub()
```

The focal triangle preserves its distinction from gray comparison points in grayscale. If context and comparison also need to be distinguished individually, assign them different shapes too. Add a fitted line or interval only from the prepared analysis; style the overall summary with `emphasis$summary`. Inspect density, label selection, group identification, and contrast at final placement. Keep horizontal labels by default; facet when required individual identities cannot fit.

## Distribution comparisons (ridge plot)

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

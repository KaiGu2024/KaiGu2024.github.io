# Recipes

Copy-pasteable code for common figures. Assumes the shared `theme_pub.R` helpers and `brand` palette from SKILL.md §4 are loaded. All sizes follow SKILL.md §1.6 (oversized for half-column print).

## Contents

1. [Figure specification, paired export, and QA](#figure-specification-paired-export-and-qa)
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
12. [Layer-and-highlight](#layer-and-highlight--focal-series-in-crimson-all-series-labeled)
13. [Distribution comparisons](#distribution-comparisons-ridge-plot)

## Figure specification, paired export, and QA

Declare export geometry and intended placement width before constructing the plot. `figure_spec()` blocks export/placement mismatches above 10%; `save_figure()` writes a publication PDF and a white-background `-qa.png` with the same dimensions and aspect ratio. Saving does not certify the layout: open the QA image at placement size and inspect the rebuilt report PDF when TeX is the destination.

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
# Open paths[["qa_png"]] with an image-viewing tool at 4.5 in.
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

Inspect the rebuilt report PDF. Generate every report panel as its own script and PDF/PNG pair. Combine panels in LaTeX under one figure number only when they jointly establish one argument and use compatible units, populations, and denominators; otherwise place them in separate floats. Keep panel subtitles, letters, and the shared caption in LaTeX rather than baking them into the image files.

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
    segment.colour = NA, size = 8
  ) +
  scale_y_continuous(labels = label_percent(accuracy = 1)) +
  scale_x_continuous(expand = expansion(mult = c(0.02, 0.15))) +
  labs_pub(x = "Calendar year", y = "Average outcome value (%)") +
  theme_pub(gutter = "right")
```

## Multi-series lines — redundant shape per series

3–5 equal-weight series, each its own colored line, with a redundant shape so the figure survives grayscale / colorblindness and reads where lines cross. `shape` and `fill` map to the **same** variable as the line `colour` (SKILL.md §5); shape rides redundant on color and so doesn't spend the channel budget. `brand_shapes <- c(21, 24, 22, 23, 25)` comes from `theme_pub.R`.

```r
pal <- c(A = brand$primary, B = brand$secondary, C = brand$dark)

labels <- df |> group_by(group) |> slice_max(month, n = 1) |> ungroup()

ggplot(df, aes(x = month, y = value, colour = group)) +
  geom_line(linewidth = 2.8) +                             # monthly = sparse
  geom_point(aes(fill = group, shape = group),
             size = 9, stroke = 1.0, colour = "white") +   # white halo
  geom_text_repel(data = labels, aes(label = group),
                  hjust = 0, nudge_x = 0.2, direction = "y",
                  segment.colour = NA, size = 8) +
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

```r
ggplot(es, aes(x = period, y = coef)) +
  geom_hline(yintercept = 0, linewidth = 1.2) +
  geom_vline(xintercept = -0.5, linetype = "dashed",
             colour = brand$accent, linewidth = 1.2) +
  geom_ribbon(aes(ymin = lo, ymax = hi),
              fill = brand$primary, alpha = 0.22) +
  geom_line(linewidth = 2.8, colour = brand$primary) +
  geom_point(size = 9, colour = brand$primary) +
  labs(x = "Periods relative to treatment", y = "Estimated effect")
```

**Two versions — match the CI to the connection.** The code above is the **line version**: estimates connected by a line, uncertainty as a shaded ribbon. It reads as a *continuous trajectory* and is right when the coefficient path is **smooth** (a clean pre-trend and a coherent post arc). When the path is **noisy / jagged** — coefficients zig-zagging month to month — the line turns into a sawtooth that overstates structure that is mostly sampling wobble, and a shaded band implies a continuity the data doesn't support. Switch to the **non-shaded version**: drop the connecting line and draw each CI as a vertical error-bar *line*, dots only — the classic discrete coefficient plot.

```r
  # non-shaded version: discrete coefficients, CI as error-bar lines, NO connecting line
  geom_hline(yintercept = 0, colour = "grey55", linewidth = 1.0) +
  geom_linerange(aes(ymin = lo, ymax = hi), colour = brand$primary, linewidth = 1.1) +
  geom_point(colour = brand$primary, fill = "white", shape = 21, size = 6, stroke = 1.3) +
  # (no geom_line, no geom_ribbon)   # use geom_errorbar(width = 0.4) if you want caps
```

The pairing is the rule, not a style toss-up (rule 11): **shaded ribbon ↔ connecting line** (continuous reading), **error-bar lines ↔ disconnected dots** (discrete reading). Don't cross them — a shaded band under unconnected dots asserts a smooth function you've otherwise refused to draw, and bare error bars threaded by a heavy line double-encode the path. Pick the reading first, then both elements follow.

For a multi-outcome loop (one `make_es()`-style function over several outcomes), this is a per-figure author choice, not runtime branching on the data: carry a `shaded`/`line` flag in the spec table and let smooth outcomes take the line version, noisy ones the non-shaded version. The marker refinements below (open-circle, tangent-circle) apply to the **line** version.

**Open-circle marker — sanctioned variant.** Instead of the solid blue dot, draw a blue-ringed white circle (`shape = 21`, `fill = "white"`, `colour = brand$primary`). The white interior lets the connecting line and ribbon read *through* the marker rail, so a long monthly event study (25+ periods) stays legible where solid dots would clot into a blue stripe. Use it for single-series coefficient/event-study plots; keep the solid dot when periods are few.

```r
  geom_line(colour = brand$primary, linewidth = 2.6) +
  geom_point(colour = brand$primary, fill = "white", shape = 21,
             size = 7, stroke = 1.6) +
```

Two things keep it inside the skill rather than fighting it:

- **This is the inverse of the multi-series marker, and deliberately so.** Multi-series lines (§5) put the colour *inside* (`fill = group`) and a white *halo* outside (`colour = "white"`) so each marker names its series and stays crisp at crossings. A single-series event study has no series to name, so the marker carries no identity — invert it (white inside, brand ring outside) to make the rail recede and let the data path show through. Don't mix the two: open ring for one series, filled-with-white-halo for many.
- **Hold the marker-to-line ratio, then size to period count.** The white fill makes an open circle read larger than a solid dot of the same radius, so it can run a touch smaller — but keep it near the 3:1 band (rule 6): `size = 7` on a `2.6` line, `stroke` 1.4–1.6 for a ring that reads at half-column. `size = 7` is the default for a shorter event study (≤ ~15 periods); past ~20 periods the markers start to kiss where the path is steepest, so drop to `size = 6`. Don't drop below `size ≈ 6` or the ring thins to a hairline — if even 6 crowds, thin the markers (every other period) rather than shrink further.
- **Line weight `2.6` for a long monthly event study.** Rule 6 gives two discrete weights — `2.8` sparse, `2.4` dense — but a 25+-period monthly series is the in-between case: monthly cadence (sparse) yet long enough to read busy (dense). Split the difference at `linewidth = 2.6`. Keep `colour = brand$primary` — the dusty blue is already the default single-series colour, so the line, ribbon (`fill = brand$primary`), and open-circle ring all stay one hue.

**Tangent-circle look — let big markers hide the line except across gaps.** A variant of the open circle that makes the figure read as a *chain of dots* rather than a line: keep the continuous line, but size the (opaque-white-filled) circles so neighbouring circles in the flat stretches sit **tangent** — just touching — so their white fill covers the line segment between them. The line then only **peeks through where two consecutive points are far apart**, i.e. exactly where the series moves fast. No threshold, no `geom_segment`, no conditional drawing — the "few connectors" are an emergent geometric effect of the markers sitting on an always-present line.

```r
  geom_ribbon(aes(ymin = lo, ymax = hi), fill = brand$primary, alpha = 0.20) +
  geom_line(colour = brand$primary, linewidth = 2.6) +     # KEEP — continuous, underneath
  geom_point(colour = brand$primary, fill = "white", shape = 21,
             size = 7, stroke = 1.4) +                      # ~tangent in flat runs at this geometry
```

What keeps this coherent:

- **Opaque white fill is the mechanism.** `fill = "white"` (not a transparent fill) is what hides the line under each circle. The continuous line still exists — it is simply covered wherever two circles touch.
- **The tangency point is geometry-driven and the window is narrow.** Tangency depends on the marker diameter relative to the x-spacing in plot units, not on the line weight. For ~25 monthly periods at a 6.2 in author width, the threshold sits at **`size ≈ 7`** (`stroke ≈ 1.4`): at `size = 6` the line still beads through the flat run; at `7` the flat run closes up and the line peeks only on the climb; by `size ≈ 9–10` the climb circles also overlap and the line stops showing **anywhere** — the effect is lost. So this is the *same* sizing region as the plain open-circle bullet above, one step past where the beads disappear — not a dramatically bigger marker. Pick by intent: `6` for beads-on-a-line, `7` for the tangent dot-chain.
- **No ratio violation.** At `size = 7` on a `2.6` line the marker-to-line ratio is ~2.7:1 — right at rule 6's 3:1, not beyond it. Keep `stroke ≈ size/5` so the ring stays a proportionate fraction of the circle, and keep the line at `2.6` so the stub that peeks across a gap reads at the ring's weight (a deliberate connector, not a hairline).
- **It self-adapts across panels.** With constant x-spacing the only thing separating two circles is the vertical move, so once they kiss in flat runs the line shows precisely on the steep moves — and scales to each panel's own y-range across a faceted set of outcomes (flat outcomes ≈ pure dots; big-effect outcomes show stubs on the climb). No per-panel tuning. **Tune by eye in the rendered PDF, not the RStudio pane**: nudge `size` up until flat-run neighbours just touch; if the line vanishes on the climb too, you have gone one step too far.

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
  scale_colour_manual(values = c(linear = brand$primary,
                                 loess  = brand$secondary,
                                 poly   = brand$accent)) +
  geom_text_repel(
    data = filter(df, series != "raw") |>
             group_by(series) |> slice_max(year, n = 1),
    aes(label = series, colour = series),
    hjust = 0, nudge_x = 1, direction = "y",
    segment.colour = NA, size = 8
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
           size = 6, colour = "grey30") +

  # Data on top of all of the above
  geom_line(linewidth = 2.8, colour = brand$primary) +

  labs(x = "Date", y = "Outcome")
```

Variations:

- **Multiple events.** Use `grey40` for all event lines and let the rotated labels carry the distinction. Reserve `brand$accent` for the single event that matters most.
- **Date range, not a point.** Replace the `segment` with a wider `annotate("rect", xmin = start, xmax = end, ...)` at low alpha; drop the pin; label the range above the rect.
- **Bottom anchor.** If the data peaks at the top, anchor the pin at the bottom instead (`y = y_min`) with `vjust = 1.4` so the label hangs below.
- **No tint.** If the post-event region runs off the panel or there's no meaningful "after," omit the `rect` — keep the dashed segment + pin + label alone.

The "dies before the top axis" trick is what most people miss. A full-height `geom_vline` reads as a chart axis, not as data context.

## Layer-and-highlight — focal series in crimson, all series labeled

Highlight changes color, not coverage — every line still gets a name at its endpoint so the reader knows what the grey cloud is. Focal line and label in `brand$accent`; non-focal lines in `grey80` and their labels in `grey50` (slightly darker than the line so the text reads against white).

```r
focal <- c("ChatGPT")

endpoints <- df |>
  group_by(platform) |>
  slice_max(week, n = 1) |>
  ungroup() |>
  mutate(
    is_focal     = platform %in% focal,
    label_colour = ifelse(is_focal, brand$accent, "grey50")
  )

ggplot(df, aes(x = week, y = visits, group = platform)) +
  geom_line(data = filter(df, !platform %in% focal),
            colour = "grey80", linewidth = 1.0) +
  geom_line(data = filter(df,  platform %in% focal),
            colour = brand$accent, linewidth = 2.8) +
  geom_text_repel(
    data = endpoints,
    aes(label = platform, colour = label_colour),
    size = 7, hjust = 0, nudge_x = 1, direction = "y",
    segment.colour = NA
  ) +
  scale_colour_identity() +    # use the literal hex / "grey50" from the column
  scale_x_continuous(expand = expansion(mult = c(0.02, 0.18))) +
  labs_pub(x = "Observation week", y = "Weekly platform visits (thousands)") +
  theme_pub(gutter = "right")
```

For two focal series, give each a distinct accent (`brand$primary` and `brand$accent`) with its label matching its line; the rest stay grey80 / grey50.

**If the focal subject recurs across your figures** (the same platform / source highlighted in figure after figure), don't use crimson — give that subject one fixed colour from `subject_palette` (`theme_pub.R`) and reuse that exact colour every time, so the highlight reads identically across the paper (see `palettes.md` → "Locked subject identity"). When a figure highlights two or more subjects at once, take each from a different `subject_families` group (never two blues) so they separate by hue. Crimson stays the default for a one-off highlight whose subject won't reappear.

**Converging-endpoints variant — vertical labels.** When line endpoints crowd into a narrow vertical band at the right edge (5+ platforms all near the same value), horizontal labels with `direction = "y"` repel start stacking with connector lines — messy. Switch to vertical labels at each endpoint: `angle = 90, hjust = 0` makes each label hang upward from its line's endpoint (readable bottom-to-top, head tilts LEFT), and `direction = "x"` spaces them apart horizontally just past the right edge. The whole label rail stays one row tall.

```r
geom_text_repel(
  data = endpoints,
  aes(label = platform, colour = label_colour),
  size = 7,
  angle  = 90, hjust = 0,           # vertical, hanging upward from endpoint
  nudge_x = 1, direction = "x",     # repel only sideways, not vertically
  segment.colour = NA
) +
coord_cartesian(clip = "off") +     # let the labels run past the panel top if needed
scale_x_continuous(expand = expansion(mult = c(0.02, 0.20))) +
theme_pub(gutter = "right")
```

If the rotated labels extend above the data region, combine the right gutter with a targeted top-margin override (`theme_pub(gutter = "right") + theme(plot.margin = margin(t = 54, r = 72, b = 12, l = 14))`) and/or expand the right side further (`mult = c(0.02, 0.25)`).

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

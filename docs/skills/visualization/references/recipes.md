# Recipes

Copy-pasteable code for common figures. Assumes `theme_pub()` and the `brand` palette from SKILL.md §4 are loaded. All sizes follow SKILL.md §1.6 (oversized for half-column print).

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

For "one bar plot per platform", export each platform as its own file and combine with `subfigure` in LaTeX — do not `facet_wrap` into a grid.

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

For numeric-year axes (`2018, 2019, …`), use `scales::pretty_breaks(n = 6)` and let ggplot pick.

## Direct line annotation

```r
labels <- df |> group_by(group) |> slice_max(year, n = 1) |> ungroup()

ggplot(df, aes(x = year, y = outcome, colour = group)) +
  geom_line(linewidth = 2.4) +
  geom_text_repel(
    data = labels, aes(label = group),
    hjust = 0, nudge_x = 0.2, direction = "y",
    segment.colour = NA, size = 8
  ) +
  scale_y_continuous(labels = label_percent(accuracy = 1)) +
  scale_x_continuous(expand = expansion(mult = c(0.02, 0.15))) +
  labs(x = "Year", y = "Outcome")
```

## Coefficient / event-study plot

```r
ggplot(es, aes(x = period, y = coef)) +
  geom_hline(yintercept = 0, linewidth = 1.2) +
  geom_vline(xintercept = -0.5, linetype = "dashed",
             colour = brand$accent, linewidth = 1.2) +
  geom_ribbon(aes(ymin = lo, ymax = hi),
              fill = brand$primary, alpha = 0.22) +
  geom_line(linewidth = 2.4, colour = brand$primary) +
  geom_point(size = 6.5, colour = brand$primary) +
  labs(x = "Periods relative to treatment", y = "Estimated effect")
```

## Time trend with overlaid fits (raw + models + CI)

Three weights: raw series in `brand$dark` at `linewidth = 1.0` (reference); fitted lines distinguished primarily by **linetype** (so the figure reads in grayscale), secondary by hue, at `linewidth = 2.6`; one CI ribbon for the primary fit (`fill = "grey70", alpha = 0.25`).

```r
ggplot(df, aes(x = year, y = value)) +
  geom_ribbon(data = filter(df, series == "loess"),
              aes(ymin = lo, ymax = hi),
              fill = "grey70", alpha = 0.25, colour = NA) +
  geom_line(data = filter(df, series == "raw"),
            colour = brand$dark, linewidth = 1.0) +
  geom_line(data = filter(df, series != "raw"),
            aes(linetype = series, colour = series),
            linewidth = 2.6) +
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
  labs(x = "Year", y = "Value (units)")
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

  # 4. Rotated label hanging off the pin
  annotate("text",
           x = ev, y = y_label,
           label = "Policy enacted, 2024-03",
           angle = 90, hjust = 1, vjust = -0.4,
           size = 6, colour = "grey30") +

  # Data on top of all of the above
  geom_line(linewidth = 2.4, colour = brand$primary) +

  labs(x = "Date", y = "Outcome")
```

Variations:

- **Multiple events.** Use `grey40` for all event lines and let the rotated labels carry the distinction. Reserve `brand$accent` for the single event that matters most.
- **Date range, not a point.** Replace the `segment` with a wider `annotate("rect", xmin = start, xmax = end, ...)` at low alpha; drop the pin; label the range above the rect.
- **Bottom anchor.** If the data peaks at the top, anchor the pin at the bottom instead (`y = y_min`) with `vjust = 1.4` so the label hangs below.
- **No tint.** If the post-event region runs off the panel or there's no meaningful "after," omit the `rect` — keep the dashed segment + pin + label alone.

The "dies before the top axis" trick is what most people miss. A full-height `geom_vline` reads as a chart axis, not as data context.

## Layer-and-highlight — focal series in crimson

```r
focal <- c("ChatGPT")

ggplot(df, aes(x = week, y = visits, group = platform)) +
  geom_line(data = filter(df, !platform %in% focal),
            colour = "grey80", linewidth = 1.0) +
  geom_line(data = filter(df,  platform %in% focal),
            colour = brand$accent, linewidth = 2.6) +
  geom_text_repel(
    data = filter(df, platform %in% focal) |>
             group_by(platform) |> slice_max(week, n = 1),
    aes(label = platform), colour = brand$accent, size = 8,
    hjust = 0, nudge_x = 1, direction = "y", segment.colour = NA
  ) +
  scale_x_continuous(expand = expansion(mult = c(0.02, 0.12))) +
  labs(x = "Week", y = "Visits")
```

For two focal series, use `brand$primary` and `brand$accent` against `grey80`.

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

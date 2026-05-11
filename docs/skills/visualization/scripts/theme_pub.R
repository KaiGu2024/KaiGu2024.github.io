# Personal brand: publication-ready ggplot theme + color palette.
# See ../SKILL.md for the full design rationale (rules 1–13).
#
# Fonts: Lora (display) for axis titles + strip text, Newsreader (body) for
# tick labels and annotations. Same pair as the personal website / slides /
# CV — figures live in the same typeface family as the surrounding work
# instead of defaulting to a generic Helvetica.
#
# If Newsreader / Lora aren't installed system-wide, register them once per
# session with showtext:
#
#   showtext::font_add_google("Newsreader", "Newsreader")
#   showtext::font_add_google("Lora",       "Lora")
#   showtext::showtext_auto()

library(ggplot2)

theme_pub <- function() {
  theme_minimal(base_family = "Newsreader") +
    theme(
      # Axis titles in Lora (display weight); explicit margins keep them off
      # the tick labels (SKILL.md rule 13.2).
      axis.title.x     = element_text(family = "Lora", size = 28,
                                      margin = margin(t = 12)),
      axis.title.y     = element_text(family = "Lora", size = 28,
                                      margin = margin(r = 12)),
      axis.text.x      = element_text(size = 24, margin = margin(t = 4)),
      axis.text.y      = element_text(size = 24, margin = margin(r = 4)),
      # In-figure title / subtitle / caption / tag are intentionally
      # suppressed — that text belongs in LaTeX (rule 10).
      plot.title       = element_blank(),
      plot.subtitle    = element_blank(),
      plot.caption     = element_blank(),
      plot.tag         = element_blank(),
      panel.grid       = element_blank(),   # no gridlines, ever (rule 12)
      panel.border     = element_blank(),
      axis.line        = element_line(linewidth = 1.1, colour = "grey20"),
      axis.ticks       = element_line(linewidth = 1.0, colour = "grey20"),
      axis.ticks.length = unit(8, "pt"),
      strip.text       = element_text(family = "Lora", size = 24,
                                      face = "bold",
                                      margin = margin(b = 8)),
      # Outer padding so axis titles and end-of-axis tick labels don't crop
      # at the figure boundary (rule 13.1, 13.5, 13.6).
      plot.margin      = margin(t = 18, r = 22, b = 12, l = 14),
      legend.position  = "none"   # direct annotation by default (rule 4)
    )
}
theme_set(theme_pub())

# Brand palette — Monet Water Lilies + Hokusai crimson. Same hex serves as
# fill or stroke; tint with scales::alpha().
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

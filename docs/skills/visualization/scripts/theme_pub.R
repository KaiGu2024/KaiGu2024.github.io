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

wrap_axis_title <- function(label, width) {
  if (is.null(label) || !is.character(label)) return(label)

  vapply(
    label,
    function(value) paste(strwrap(value, width = width), collapse = "\n"),
    character(1),
    USE.NAMES = FALSE
  )
}

# Wrap titles before they reach the device. Defaults reflect the narrower
# usable span of a rotated y title at common manuscript placements.
labs_pub <- function(x = NULL, y = NULL, x_width = 32, y_width = 26) {
  ggplot2::labs(
    x = wrap_axis_title(x, x_width),
    y = wrap_axis_title(y, y_width)
  )
}

theme_pub <- function(gutter = c("none", "right", "left", "top", "bottom")) {
  gutter <- match.arg(gutter)
  plot_margins <- switch(
    gutter,
    none   = c(t = 18, r = 22, b = 12, l = 14),
    right  = c(t = 18, r = 72, b = 12, l = 14),
    left   = c(t = 18, r = 22, b = 12, l = 54),
    top    = c(t = 54, r = 22, b = 12, l = 14),
    bottom = c(t = 18, r = 22, b = 48, l = 14)
  )

  theme_minimal(base_family = "Newsreader") +
    theme(
      # Axis titles in Lora (display weight); explicit margins keep them off
      # the tick labels (SKILL.md rule 13 repair order).
      axis.title.x     = element_text(family = "Lora", size = 28,
                                      lineheight = 0.95,
                                      margin = margin(t = 12)),
      axis.title.y     = element_text(family = "Lora", size = 28,
                                      lineheight = 0.95,
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
      # Outer padding profiles keep axis chrome and off-panel annotations away
      # from the device boundary (rule 13 acceptance gate).
      plot.margin      = margin(
        t = unname(plot_margins["t"]),
        r = unname(plot_margins["r"]),
        b = unname(plot_margins["b"]),
        l = unname(plot_margins["l"])
      ),
      legend.position  = "none"   # direct annotation by default (rule 4)
    )
}
theme_set(theme_pub())

# Declare geometry before constructing a plot. Placement width uses the same
# physical unit as export width (inches) and may differ by at most 10%.
figure_spec <- function(stem, width, height, placement_width) {
  numeric_values <- c(width = width, height = height,
                      placement_width = placement_width)
  if (length(stem) != 1L || !is.character(stem) || !nzchar(stem)) {
    stop("`stem` must be one non-empty path without a file extension.",
         call. = FALSE)
  }
  if (grepl("\\.(pdf|png)$", stem, ignore.case = TRUE)) {
    stop("`stem` must not include a .pdf or .png extension.", call. = FALSE)
  }
  if (any(lengths(list(width, height, placement_width)) != 1L) ||
      !is.numeric(numeric_values) || any(!is.finite(numeric_values)) ||
      any(numeric_values <= 0)) {
    stop("`width`, `height`, and `placement_width` must be positive numbers.",
         call. = FALSE)
  }

  scale_delta <- abs(width - placement_width) / placement_width
  if (scale_delta > 0.10 + sqrt(.Machine$double.eps)) {
    stop(sprintf(
      "Export width %.2f and placement width %.2f differ by %.1f%%; maximum is 10%%.",
      width, placement_width, 100 * scale_delta
    ), call. = FALSE)
  }

  structure(
    list(stem = stem, width = width, height = height,
         placement_width = placement_width),
    class = "figure_spec"
  )
}

# Save the publication PDF and a white-background PNG QA copy with identical
# dimensions. Opening and accepting the rendered artifact remains a blocking
# manual step; this helper cannot certify layout quality.
save_figure <- function(plot, spec, dpi = 600) {
  if (!inherits(spec, "figure_spec")) {
    stop("`spec` must come from figure_spec().", call. = FALSE)
  }

  output_dir <- dirname(spec$stem)
  dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
  paths <- c(
    pdf = paste0(spec$stem, ".pdf"),
    qa_png = paste0(spec$stem, "-qa.png")
  )

  ggplot2::ggsave(
    paths[["pdf"]], plot = plot,
    width = spec$width, height = spec$height, units = "in",
    device = grDevices::cairo_pdf, bg = "white"
  )
  ggplot2::ggsave(
    paths[["qa_png"]], plot = plot,
    width = spec$width, height = spec$height, units = "in",
    dpi = dpi, bg = "white"
  )

  invisible(paths)
}

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

# Redundant shape set — filled pch (21–25 accept a contrasting border), ordered
# by perceptual dissimilarity: circle, triangle-up, square, diamond, triangle-
# down. Map to the SAME grouping variable as colour on multi-series line+point
# figures so they survive grayscale / colorblindness and read where lines cross
# (SKILL.md §5). Caps at 5 — past that, facet or layer-and-highlight.
brand_shapes <- c(21, 24, 22, 23, 25)

# Subject-identification candidate pool — fixed colours for the emphasized
# subject(s) in a layer-and-highlight figure (the focal series; everyone else
# stays grey80). NOT a paint-everyone palette and NOT a strong/weak hierarchy —
# it is a flat pool of 8 candidates, ordered by aesthetics. When a figure
# colours more than one subject, pick from DIFFERENT families (see below) so the
# subjects separate by hue, never two members of the same family in one figure.
# Which subject gets which colour is project-specific (references/palettes.md,
# "Locked subject identity") — assign once per project and reuse it everywhere.
subject_palette <- c(
  "#2251FF",  # blue
  "#E3120B",  # red
  "#78efc0",  # mint / green
  "#f2006c",  # rose / magenta
  "#ff804f",  # coral
  "#9DBBD2",  # dusty blue   (= brand_blues[4]; reuse aware)
  "#00355F",  # navy
  "#A02050"   # raspberry
)
# Grouped by family so "one per family" is mechanical — e.g. for a 3-subject
# comparison take blue + warm + rose, never two blues. The first four entries of
# subject_palette are already one-per-family (blue, red, green, rose).
subject_families <- list(
  blue = c("#2251FF", "#9DBBD2", "#00355F"),
  green = c("#78efc0"),
  warm  = c("#E3120B", "#ff804f"),   # red + coral
  rose  = c("#f2006c", "#A02050")    # magenta + raspberry
)

# Sequential ramp anchored on a subject's identity hue — for the RANK job on a
# SINGLE-subject figure (bars/bins shaded by value, the whole figure about one
# subject), so the value ramp carries the same identity as the subject's
# categorical colour. NOT for precise magnitude (use viridis — perceptual
# uniformity beats brand identity) and NOT for multi-subject value figures (use
# one neutral ramp there; identity stays categorical via subject_palette, or the
# gradient and the palette fight over the same channel). The vivid identity hue
# sits MID-ramp: the high stop is a darkened version, the low stop a desaturated
# light tint, hue held roughly constant in HCL so lightness stays monotonic and
# the ramp reads as ordered + CVD-safe. Returns dark -> light (dark = high), the
# same orientation as brand_blues, so it is a drop-in replacement:
#   scale_fill_manual(values  = subject_ramp(hex, k))          # discrete bins
#   scale_fill_gradientn(colours = rev(subject_ramp(hex)))     # continuous
# Needs the colorspace package; called namespaced so sourcing this file does not
# require it — only invoking subject_ramp() does.
subject_ramp <- function(hex, n = 5) {
  high <- colorspace::darken(hex, 0.30, space = "HCL")
  low  <- colorspace::lighten(colorspace::desaturate(hex, 0.55), 0.80,
                              space = "HCL")
  grDevices::colorRampPalette(c(high, low))(n)
}

options(ggplot2.discrete.fill   = c(brand$primary, brand$secondary),
        ggplot2.discrete.colour = c(brand$primary, brand$secondary))

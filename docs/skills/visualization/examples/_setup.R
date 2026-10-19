# Shared setup for this teaching gallery. Data in each script are invented.
# Run any fig_*.R with Rscript; each writes exactly one PDF beside its source.
source(file.path(example_dir, "..", "scripts", "theme_pub.R"))
sysfonts::font_add_google("Lora", "Lora")
sysfonts::font_add_google("Newsreader", "Newsreader")
showtext::showtext_auto()
label_pt <- 16 / ggplot2::.pt
example_spec <- function(stem, height = 4.8) {
  figure_spec(file.path(example_dir, stem), width = 7.2,
              height = height, placement_width = 7.2)
}

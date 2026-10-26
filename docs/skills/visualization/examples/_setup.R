# Shared setup for this teaching gallery. Data in each script are invented.
# Run any fig_*.R with Rscript; each writes exactly one PDF beside its source.
source(file.path(example_dir, "..", "scripts", "theme_pub.R"))
# These 7.2-inch exhibits intentionally use larger type; compact panels should
# choose their own base size and geometry under SKILL.md rules 6 and 13.
example_base_size <- 16
theme_set(theme_pub(base_size = example_base_size))
sysfonts::font_add_google("Lora", "Lora")
sysfonts::font_add_google("Newsreader", "Newsreader")
showtext::showtext_auto()
label_pt <- example_base_size / ggplot2::.pt
example_spec <- function(stem, height = 4.8) {
  figure_spec(file.path(example_dir, stem), width = 7.2,
              height = height, placement_width = 7.2)
}

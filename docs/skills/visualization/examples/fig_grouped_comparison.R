example_dir <- dirname(normalizePath(sub("^--file=", "", grep("^--file=", commandArgs(), value = TRUE)[1]), winslash = "/"))
source(file.path(example_dir, "_setup.R"))
# Intent: compare descriptive gaps; position shows the contrast directly.
# Region is a meaningful grouping. No inference is implied by these toy values.
spec <- example_spec("fig_grouped_comparison", height = 5.2)
dat <- data.frame(region = rep(c("North", "South"), each = 3),
                  sector = rep(c("Retail", "Services", "Manufacturing"), 2),
                  program = c(31,36,42,30,38,40), comparison = c(29,31,35,27,32,32))
dat$gap <- dat$program - dat$comparison
dat$sector <- reorder(dat$sector, dat$gap)
p <- ggplot(dat, aes(gap, sector)) +
  geom_col(width = .5, fill = brand$primary) +
  geom_text(aes(label = sprintf("%+.0f", gap)), nudge_x = .35, hjust = 0,
            family = "Newsreader", size = label_pt, colour = "grey25") +
  facet_grid(region ~ ., scales = "free_y", space = "free_y", switch = "y") +
  scale_x_continuous(limits = c(0,9.5), breaks = seq(0,8,2), expand = expansion(mult = 0)) +
  scale_y_discrete(expand = expansion(add = .65)) +
  labs_pub(x = "Program minus comparison (orders per firm)", y = NULL, x_width = 28) +
  theme(strip.placement = "outside", strip.text.y.left = element_text(angle = 0),
        panel.spacing.y = grid::unit(20, "pt"))
stopifnot(all(dat$gap == dat$program - dat$comparison))
save_figure(p, spec)

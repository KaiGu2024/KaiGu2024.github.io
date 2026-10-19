example_dir <- dirname(normalizePath(sub("^--file=", "", grep("^--file=", commandArgs(), value = TRUE)[1]), winslash = "/"))
source(file.path(example_dir, "_setup.R"))
# Intent: locate concentration; cell labels give exact shares, color aids scanning.
spec <- example_spec("fig_heatmap", height = 5.8)
dat <- expand.grid(usage = c("Low", "Middle", "High"), spend = c("Low", "Middle", "High"))
dat$share <- c(22,8,3,7,20,7,3,9,21)
dat$ink <- ifelse(dat$share >= 15, "grey15", "white")
p <- ggplot(dat, aes(usage, spend, fill = share)) +
  geom_tile(colour = "white", linewidth = 1.5) +
  geom_text(aes(label = paste0(share, "%"), colour = ink),
            family = "Newsreader", size = 18 / ggplot2::.pt) +
  scale_colour_identity() +
  scale_fill_viridis_c(option = "D", limits = c(0,25)) +
  scale_x_discrete(expand = expansion(add = 0)) +
  scale_y_discrete(expand = expansion(add = 0)) +
  coord_fixed() + labs_pub(x = "Usage rank", y = "Spending rank") +
  theme(axis.line = element_blank(), axis.ticks = element_blank())
stopifnot(sum(dat$share) == 100, nrow(dat) == 9L)
save_figure(p, spec)

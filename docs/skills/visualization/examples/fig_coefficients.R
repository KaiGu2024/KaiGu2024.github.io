example_dir <- dirname(normalizePath(sub("^--file=", "", grep("^--file=", commandArgs(), value = TRUE)[1]), winslash = "/"))
source(file.path(example_dir, "_setup.R"))
# Intent: compare illustrative effects and uncertainty on one common scale.
spec <- example_spec("fig_coefficients")
dat <- data.frame(group = c("Small firms", "Large firms", "New firms", "Established firms"),
                  estimate = c(.8,1.7,2.4,1.25), half_width = c(.6,.7,.8,.55))
dat$group <- reorder(dat$group, dat$estimate)
dat$lo <- dat$estimate - dat$half_width
dat$hi <- dat$estimate + dat$half_width
p <- ggplot(dat, aes(estimate, group)) +
  geom_vline(xintercept = 0, colour = "grey55", linewidth = 1.2) +
  geom_segment(aes(x = lo, xend = hi, yend = group), colour = marks$primary, linewidth = 1.2) +
  geom_point(colour = marks$primary, size = 9) +
  scale_x_continuous(limits = c(-.1,3.4), breaks = 0:3) +
  scale_y_discrete(expand = expansion(add = .65)) +
  labs_pub(x = "Effect on employment (percentage points)", y = NULL, x_width = 26)
stopifnot(all(dat$lo <= dat$estimate), all(dat$hi >= dat$estimate))
save_figure(p, spec)

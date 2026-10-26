example_dir <- dirname(normalizePath(sub("^--file=", "", grep("^--file=", commandArgs(), value = TRUE)[1]), winslash = "/"))
source(file.path(example_dir, "_setup.R"))
# Intent: show event-time estimates without connecting across the omitted period.
# Illustrative coefficients and interval endpoints; no model or inference claim.
spec <- example_spec("fig_event_study")
dat <- data.frame(month = c(-4,-3,-2,0,1,2,3,4),
                  estimate = c(-0.2,0.15,-0.1,0.7,1.3,1.65,1.9,2.05),
                  half_width = c(.5,.45,.4,.45,.5,.55,.6,.65))
dat$lo <- dat$estimate - dat$half_width
dat$hi <- dat$estimate + dat$half_width
p <- ggplot(dat, aes(month, estimate)) +
  geom_hline(yintercept = 0, colour = "grey65", linewidth = .4) +
  geom_vline(xintercept = -.5, colour = "grey65", linetype = "dashed", linewidth = .4) +
  geom_errorbar(aes(ymin = lo, ymax = hi), width = .12,
                colour = brand_blues[1], linewidth = .65) +
  geom_point(colour = brand_blues[1], size = 2.6) +
  annotate("point", x = -1, y = 0, shape = 1, size = 2.6, colour = "grey35", stroke = .65) +
  scale_x_continuous(breaks = -4:4, expand = expansion(mult = .05)) +
  scale_y_continuous(breaks = -1:3, expand = expansion(mult = .08)) +
  labs_pub(x = "Months relative to policy adoption", y = "Employment") +
  theme_pub(style = "estimate", base_size = example_base_size)
stopifnot(nrow(dat) == 8L, !any(dat$month == -1), all(dat$lo < dat$estimate), all(dat$hi > dat$estimate))
save_figure(p, spec)

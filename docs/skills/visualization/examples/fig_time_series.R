example_dir <- dirname(normalizePath(sub("^--file=", "", grep("^--file=", commandArgs(), value = TRUE)[1]), winslash = "/"))
source(file.path(example_dir, "_setup.R"))
# Intent: compare two descriptive series; endpoint labels remove legend lookup.
spec <- example_spec("fig_time_series")
dat <- data.frame(month = rep(1:6, 2), group = rep(c("Program", "Comparison"), each = 6),
                  count = c(18,21,24,29,32,37,17,19,21,22,24,25))
pal <- c(Program = marks$primary, Comparison = marks$secondary)
ends <- dat[dat$month == 6, ]
p <- ggplot(dat, aes(month, count, colour = group, group = group)) +
  geom_line(aes(linetype = group), linewidth = 2.8) +
  geom_point(aes(shape = group, fill = group), size = 9, colour = "white", stroke = 1) +
  geom_text(data = ends, aes(x = 6.3, label = group), hjust = 0,
            colour = "grey25", size = label_pt, family = "Newsreader") +
  scale_colour_manual(values = pal) + scale_fill_manual(values = pal) +
  scale_shape_manual(values = c(Program = 21, Comparison = 24)) +
  scale_linetype_manual(values = c(Program = "solid", Comparison = "dashed")) +
  scale_x_continuous(limits = c(.6,8.2), breaks = 1:6, expand = expansion(mult = 0)) +
  scale_y_continuous(limits = c(0,42), breaks = seq(0,40,10), expand = expansion(mult = 0)) +
  labs_pub(x = "Calendar month", y = "Mean orders per firm") +
  theme_pub(gutter = "right")
stopifnot(nrow(ends) == 2L, !anyDuplicated(dat[c("month", "group")]))
save_figure(p, spec)

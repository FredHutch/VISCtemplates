## Plot settings for {{ study_name }} to be used across PT reports

visc_theme <- theme_bw() +
  theme(legend.position = "bottom")
theme_set(visc_theme)

placebocolor <- "grey50"
group_colors <- c(
  `Group 1` = "#F4D08D",
  `Group 2` = "#A189BF",
  `Group 3` = "[HEX#]",
  `Group 4` = placebocolor
)
# default color scheme will be given by group_colors
assign("scale_color_discrete", function(..., values = group_colors) scale_color_manual(..., values = values), globalenv())
assign("scale_fill_discrete", function(..., values = group_colors) scale_fill_manual(..., values = values), globalenv())

response_shapes <- c(
  `Baseline` = 5,
  `No Detectable Response` = 2,
  `No Response` = 2,
  `Positive Response` = 16,
  `Detectable Response` = 16
)
assign("scale_shape_discrete", function(..., values = response_shapes) scale_color_manual(..., values = values), globalenv())

# To source these group colors, response shapes, and other plot settings in your Rmarkdown report:
#  source("R/ggplot_settings.R", local = TRUE)

# allows using variables from chunk in figure caption
opts_knit$set(eval.after = c("fig.scap", "fig.cap"))

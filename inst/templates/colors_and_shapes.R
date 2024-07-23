## Colors and shapes for {{ study_name }} figures, to be used across PT reports

# To use these in your Rmarkdown report:
# source(rprojroot::find_rstudio_root_file("R", "ggplot_settings.R"), local = TRUE)

placebocolor <- "grey50"
group_colors <- c(
  `Group 1` = "#F4D08D",
  `Group 2` = "#A189BF",
  `Group 3` = "[HEX#]",
  `Group 4` = placebocolor
)

response_shapes <- c(
  `Baseline` = 5,
  `No Detectable Response` = 2,
  `No Response` = 2,
  `Positive Response` = 16,
  `Detectable Response` = 16
)

# Set these colors and shapes to be the defaults, so that you don't always need to use
# scale_color_manual, scale_fil_manual, and scale_shape_manual
assign("scale_color_discrete", function(..., values = group_colors) scale_color_manual(..., values = values), globalenv())
assign("scale_fill_discrete", function(..., values = group_colors) scale_fill_manual(..., values = values), globalenv())
assign("scale_shape_discrete", function(..., values = response_shapes) scale_shape_manual(..., values = values), globalenv())

## Colors and shapes for VDCnnn figures, to be used across PT reports

# To source these for use in your Rmarkdown report:
# source("R/colors-and-shapes.R", local = TRUE)

# this color scheme was generated on 3/24/25 with help from microsoft copilot
# the following prompts were used:
# "I need a colorblind friendly palette that includes 4 colors plus a medium gray"
# "can you give me both dark and light variations of the blue, orange, green, and purple?"

report_colors <- c(

  # for plots using color to indicate group, regardless of response status
  `Placebo` = "#999999", # medium gray
  `Group 1` = "#005682", # dark blue,
  `Group 2` = "#B97500", # dark orange
  `Group 3` = "#007856", # dark green
  `Group 4` = "#994E71", # dark purple/maroon

  # for plots using color to indicate group AND response status
  `Baseline` = "#999999", # medium gray
  `Non-Responders` = "#999999", # medium gray
  `Group 1 (Responders)` = "#005682", # dark blue,
  `Group 2 (Responders)` = "#B97500", # dark orange
  `Group 3 (Responders)` = "#007856", # dark green
  `Group 4 (Responders)` = "#994E71", # dark purple/maroon

  # alternative color scheme for dose-response study
  `Treatment 1, Low Dose` = "#66B2FF", # light blue
  `Treatment 1, High Dose` = "#005682", # dark blue
  `Treatment 2, Low Dose` = "#FFBF80", # light orange
  `Treatment 2, High Dose` = "#B97500", # dark orange
  `Treatment 3, Low Dose` = "#80E1B8", # light green
  `Treatment 3, High Dose` = "#007856", # dark green
  `Treatment 4, Low Dose` = "#E6AFC8", # light purple/maroon
  `Treatment 4, High Dose` = "#994E71" # dark purple/maroon

)

report_shapes <- c(

  `Baseline` = 5, # open diamond
  `Baseline (Upper Limit)` = 0, # open square

  `Non-Responders` = 2, # open triangle

  # filled circles
  `Group 1 (Responders)` = 16,
  `Group 2 (Responders)` = 16,
  `Group 3 (Responders)` = 16,
  `Group 4 (Responders)` = 16
)

# You can apply these colors and shapes to ggplot figures using:
# scale_color_manual(values = report_colors)
# scale_fill_manual(values = report_colors)
# scale_shape_manual(values = report_shapes)

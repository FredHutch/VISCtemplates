## Colors and shapes for VDCnnn figures, to be used across PT reports

# To source these for use in your Rmarkdown report:
# source("R/group-colors.R", local = TRUE)

# this color scheme was generated on 3/24/25 with help from microsoft copilot
# the following prompts were used:
# "I need a colorblind friendly palette that includes 4 colors plus a medium gray"
# "can you give me both dark and light variations of the blue, orange, green, and purple?"

group_colors <- c(

  `Placebo` = "#999999", # medium gray
  `Baseline` = "#999999", # medium gray
  `No Response` = "#999999", # medium gray

  `Group 1` = "#005682", # dark blue,
  `Group 2` = "#B97500", # dark orange
  `Group 3` = "#007856", # dark green
  `Group 4` = "#994E71", # dark purple/maroon

  `Treatment 1, Low Dose` = "#66B2FF", # light blue
  `Treatment 1, High Dose` = "#005682", # dark blue
  `Treatment 2, Low Dose` = "#FFBF80", # light orange
  `Treatment 2, High Dose` = "#B97500", # dark orange
  `Treatment 3, Low Dose` = "#80E1B8", # light green
  `Treatment 3, High Dose` = "#007856", # dark green
  `Treatment 4, Low Dose` = "#E6AFC8", # light purple/maroon
  `Treatment 4, High Dose` = "#994E71" # dark purple/maroon

)

response_shapes <- c(
  `Baseline` = 5, # open diamond
  `Baseline (Upper Limit)` = 0, # open square
  `No Detectable Response` = 2, # open triangle
  `No Response` = 2, # open triangle
  `Positive Response` = 16, # filled circle
  `Detectable Response` = 16 # filled circle
)

# Set these colors and shapes to be the ggplot defaults
assign("scale_color_discrete", function(..., values = group_colors) scale_color_manual(..., values = values), globalenv())
assign("scale_fill_discrete", function(..., values = group_colors) scale_fill_manual(..., values = values), globalenv())
assign("scale_shape_discrete", function(..., values = response_shapes) scale_shape_manual(..., values = values), globalenv())

# Alternatively, you can apply
# scale_color_manual(values = group_colors)
# scale_fill_manual(values = group_colors)
# scale_shape_manual(values = response_shapes)
# to individual ggplot objects in the report

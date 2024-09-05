#' Study Schema for {{ study_name }}
#'
#' To source the study schema in a chunk in your Rmarkdown report:
#' source("R/study_schema.R", local = TRUE)

schema_table <- tibble::tribble(
  ~Group, ~`Sample Size`, ~`Week 10`, ~`Week 20`,
  "Group A", 10, "Dose A", "Dose A",
  "Group B", 10, "Dose B", "Dose B"
)

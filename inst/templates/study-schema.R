## Study Schema for {{ study_name }}

# Edit the code below to set up a shared study schema across PT reports.

study_schema <- tibble::tribble(
  ~Group, ~`Sample Size`, ~`Week 10`, ~`Week 20`,
  "Group A", 10, "Dose A", "Dose A",
  "Group B", 10, "Dose B", "Dose B"
)

# To source the study schema in a chunk in your Rmarkdown report:
#  knitr::read_chunk("protocol/study-schema.R")

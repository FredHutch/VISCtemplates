#' Study Schema for {{ study_name }}
#'
#' To source the study schema in a chunk in your Rmarkdown report:
#' source("R/study_schema.R", local = TRUE)
#'
#' @param caption caption for the study schema table
#'
#' @return a kable table with the study schema
#' @export
#'
#' @examples
study_schema <- function(caption = "{{ study_name }} study schema.") {

  schema_table <- tibble::tribble(
    ~Group, ~`Sample Size`, ~`Week 10`, ~`Week 20`,
    "Group A", 10, "Dose A", "Dose A",
    "Group B", 10, "Dose B", "Dose B"
    )

  schema_table %>%
    knitr::kable(
      format = VISCtemplates::get_output_type(),
      caption = caption,
      booktabs = TRUE,
      linesep = ""
    ) %>%
    kableExtra::kable_styling(latex_options = c("hold_position"))
  }

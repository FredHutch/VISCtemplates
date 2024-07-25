#' Study Schema for {{ study_name }}
#'
#' To print the study schema in a chunk in your Rmarkdown report, use:
#' source("R/study_schema.R", local = TRUE)
#'
#' @param caption caption for the study schema table
#'
study_schema <- function(caption = "{{ study_name }} study schema.",
                         label = "study-schema") {

  schema_table <- tibble::tribble(
    ~Group, ~`Sample Size`, ~`Week 10`, ~`Week 20`,
    "Group A", 10, "Dose A", "Dose A",
    "Group B", 10, "Dose B", "Dose B"
    )

  flextable(schema_table) %>%
    set_caption(caption,
                autonum = officer::run_autonum(seq_id = "tab", bkm = label))
  }

#' Use a VISC README template
#'
#' @param study_name name of study in VDCNNN format
#' @param save_as where to save README.Rmd. Defaults to top-level.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' use_visc_readme("Gallo477")
#' }
use_visc_readme <- function(study_name, save_as = "README.Rmd") {
  usethis::use_template(
    template = "visc-project-readme.Rmd",
    save_as = save_as,
    data = list(study_name = study_name),
    package = "VISCtemplates"
  )
}

#' Create a VISC docs directory with template files
#'
#' Creates the docs/ directory and presentations/ directory with templates
#' for the project background, objectives, group colors, and study schema.
#'
#' @param study_name name of study in VDCNNN format
#'
#' @export
#'
#' @examples
#' \dontrun{
#' use_visc_docs("Gallo477")
#' }
use_visc_docs <- function(study_name) {

  usethis::use_directory("docs")
  usethis::use_directory("docs/presentations")

  # use template for background
  use_project_background(study_name)

  # use template for objectives
  use_project_objectives(study_name)

  # group colors template code
  use_group_colors(study_name)

  # study schema template
  use_study_schema(study_name)
}


use_project_background <- function(study_name) {
  usethis::use_template(
    template = "visc-project-background.Rmd",
    save_as = "docs/background.Rmd",
    data = list(study_name = study_name),
    package = "VISCtemplates"
  )
}

use_project_objectives <- function(study_name) {
  usethis::use_template(
    template = "visc-project-objectives.Rmd",
    save_as = "docs/objectives.Rmd",
    data = list(study_name = study_name),
    package = "VISCtemplates"
  )
}

use_group_colors <- function(study_name) {
  usethis::use_template(
    template = "group-colors.R",
    save_as = "docs/group-colors.R",
    data = list(study_name = study_name),
    package = "VISCtemplates"
  )
}

use_study_schema <- function(study_name) {
  usethis::use_template(
    template = "study-schema.R",
    save_as = "docs/study-schema.R",
    data = list(study_name = study_name),
    package = "VISCtemplates"
  )
}


#' Convert to a VISC Report PDF/LaTeX document
#'
#' Runs the VISC Report for PDF output based on the template.tex file.
#'
#' @param latex_engine latex engine to use
#' @param keep_tex keep the .tex file
#' @param ... other options to pass to \code{pdf_document()}
#'
#' @details
#'
#' Normally used through `output:VISCtemplates::visc_pdf_document` in the .rmd YAML
#'
#' @export
#'
visc_pdf_document <- function(latex_engine = "pdflatex",
                              keep_tex = TRUE,
                              ...) {
  template <- find_resource("visc_report", "template.tex")

  logo_path_scharp <- find_resource("visc_report", "SCHARP_logo.png")
  logo_path_fh <- find_resource("visc_report", "FredHutch_logo.png")
  logo_path_visc <- find_resource("visc_report", "VISC_logo.jpg")

  rmarkdown::pdf_document(
    template = template,
    keep_tex = keep_tex,
    fig_caption = TRUE,
    latex_engine = latex_engine,
    pandoc_args = c(
      "-V", paste0("logo_path_scharp=", logo_path_scharp),
      "-V", paste0("logo_path_fh=", logo_path_fh),
      "-V", paste0("logo_path_visc=", logo_path_visc)
    ),
    ...)
}


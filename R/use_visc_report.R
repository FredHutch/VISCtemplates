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
#' for the project background, objectives, group colors, study schema, and
#' project-level bib file.
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

  # project-level bib file
  use_bib(study_name)
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
    template = "group_colors.R",
    save_as = "R/group_colors.R",
    data = list(study_name = study_name),
    package = "VISCtemplates"
  )
}

use_study_schema <- function(study_name) {
  usethis::use_template(
    template = "study_schema.R",
    save_as = "R/study_schema.R",
    data = list(study_name = study_name),
    package = "VISCtemplates"
  )
}

use_bib <- function(study_name) {
  usethis::use_template(
    template = "bibliography.bib",
    save_as = "docs/bibliography.bib",
    data = list(study_name = study_name),
    package = "VISCtemplates"
  )
}

#' Use a VISC Report Template
#'
#' This function creates a template R Markdown file for a VISC report.
#'
#' @param report_name name of the file (character)
#' @param path path of the file within the active project
#' @param report_type "empty", "generic", "bama", "nab", or "adcc"
#' @param interactive TRUE by default. FALSE is for non-interactive unit testing
#'   only.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' use_visc_report(
#'   report_name = "McElrath708_BAMA_PT_Report_blinded",
#'   path = "BAMA",
#'   report_type = "bama"
#'   )
#' }
use_visc_report <- function(report_name = "PT-Report",
                            path = ".",
                            report_type = c("empty", "generic", "bama", "nab", "adcc"),
                            interactive = TRUE) {

  stopifnot(report_type %in% c("empty", "generic", "bama", "nab", "adcc"))

  # suppress usethis output when non-interactive
  old_usethis_quiet <- getOption('usethis.quiet')
  on.exit(options(usethis.quiet = old_usethis_quiet))
  options(usethis.quiet = !interactive)

  if (report_type != 'empty') challenge_visc_report(report_name, interactive)
  if (!dir.exists(path)) dir.create(path, recursive = TRUE)
  use_template <- paste0(
    'visc', '_', if (report_type == 'empty') 'empty' else 'report'
  )
  rmarkdown::draft(
    file = file.path(path, report_name),
    template = use_template,
    package = "VISCtemplates",
    edit = FALSE
  )
  usethis::ui_done(
    glue::glue("Creating {{report_type}} VISC report at '{{file.path(path, report_name)}}'")
  )
  if (report_type != 'empty') {
    use_visc_methods(path = file.path(path, report_name), assay = report_type,
                     interactive = interactive)
  }


}

challenge_visc_report <- function(report_name, interactive = TRUE) {
  if (!interactive) return(invisible(NULL))

  continue <- usethis::ui_yeah("
    Creating a new VISC PT Report called {report_name}.
    At VISC, we use a naming convention for PT reports:
    'VDCnnn_assay_PT_Report_statusifapplicable'
    where 'statusifapplicable' distinguishes blinded reports,
    HIV status, or something that distinguishes a type/subset
    of a report.
    'VDC' is the PI name and 'nnn' is the study number.
    Would you like to continue?")

  if (!continue) {
    usethis::ui_stop("Stopping `use_visc_report()`")
  }
}

#' Use template files for methods sections in PT reports
#'
#' Creates a "methods" directory that contains 3 "child" R Markdown documents
#'  used in PT reports: statistical-methods.Rmd, lab-methods.Rmd,
#'  and biological-endpoints.Rmd
#'
#' @param assay "generic", "bama", "nab" or "adcc"
#' @param path path within the active project
#' @param interactive TRUE by default. FALSE is for non-interactive unit testing
#'   only.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' use_visc_methods(path = "bama/BAMA-PT-Report", assay = "bama")
#' }
use_visc_methods <- function(path = ".", assay = c("generic", "bama", "nab", "adcc"),
                             interactive = TRUE) {

  # suppress usethis output when non-interactive
  old_usethis_quiet <- getOption('usethis.quiet')
  on.exit(options(usethis.quiet = old_usethis_quiet))
  options(usethis.quiet = !interactive)

  pkg_ver <- utils::packageVersion("VISCtemplates")

  usethis::use_directory(file.path(path, "methods"))

  usethis::use_template(
    template = file.path(
      paste0("methods-", assay),
      paste0(assay, "-statistical-methods.Rmd")
      ),
    data = list(pkg_ver = pkg_ver),
    save_as = file.path(path, "methods", "statistical-methods.Rmd"),
    package = "VISCtemplates"
  )

  usethis::use_template(
    template = file.path(
      paste0("methods-", assay),
      paste0(assay, "-lab-methods.Rmd")
      ),
    data = list(pkg_ver = pkg_ver),
    save_as = file.path(path, "methods", "lab-methods.Rmd"),
    package = "VISCtemplates"
  )

  usethis::use_template(
    template = file.path(
      paste0("methods-", assay),
      paste0(assay, "-biological-endpoints.Rmd")
      ),
    data = list(pkg_ver = pkg_ver),
    save_as = file.path(path, "methods", "biological-endpoints.Rmd"),
    package = "VISCtemplates"
  )

}

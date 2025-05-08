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
use_visc_report <- function(report_name = "VDCnnn_assay_PTreport",
                            path = ".",
                            report_type = c("empty", "generic", "bama", "nab", "adcc"),
                            interactive = TRUE) {

  report_type <- match.arg(report_type)

  if (dirname(report_name) != ".") {
    stop("report_name cannot include a subdirectory. you can instead specify a subdirectory using the path argument of use_visc_report().")
  }

  # suppress usethis output when non-interactive
  old_usethis_quiet <- getOption('usethis.quiet')
  on.exit(options(usethis.quiet = old_usethis_quiet))
  options(usethis.quiet = !interactive)

  if (report_type != 'empty') challenge_visc_report(report_name, interactive)

  # create assay level folder (specified in path) and readme, if don't yet exist
  if (!dir.exists(path)) {
    dir.create(path, recursive = TRUE)

    usethis::use_template(
      template = "README_assay_folder.md",
      data = list(study_name = get_study_name(report_name), assay_name = get_assay_name(report_name)),
      save_as = file.path(path, "README.md"),
      package = "VISCtemplates"
    )
  }

  # create report folder and main Rmd document
  visc_report_type <- paste0(
    'visc', '_', if (report_type == 'empty') 'empty' else 'report'
  )
  rmarkdown::draft(
    file = file.path(path, report_name),
    template = system.file("templates", visc_report_type, package = "VISCtemplates"),
    edit = FALSE
  )

  usethis::ui_done(
    glue::glue("Created {{report_type}} VISC report at '{{file.path(path, report_name)}}'")
  )

  # create readme for report folder
  usethis::use_template(
    template = "README_report_folder.md",
    data = list(),
    save_as = file.path(path, report_name, "README.md"),
    package = "VISCtemplates"
  )

  # add draft methods
  if (report_type != 'empty'){
    use_visc_methods(path = file.path(path, report_name), assay = report_type,
                     interactive = interactive)
  }

  # add report QC tests
  usethis::use_testthat()
  usethis::use_template(
    template = "report_qc_tests.R",
    save_as = paste0("tests/testthat/test-report_qc_tests_", report_name, ".R"),
    data = list(report_name = report_name, path = path),
    package = "VISCtemplates"
  )

}

# function to infer study name from report name
get_study_name <- function(report_name) {
  underscore_positions <- gregexpr('\\_', report_name)[[1]]
  n_underscores <- length(underscore_positions[underscore_positions != -1])
  if (n_underscores >= 2) {
    study_name <- strsplit(report_name, '_')[[1]][1]
  } else {
    study_name <- "Study"
  }
  return(study_name)
}

# function to infer assay name from report name
get_assay_name <- function(report_name) {
  underscore_positions <- gregexpr('\\_', report_name)[[1]]
  n_underscores <- length(underscore_positions[underscore_positions != -1])
  if (n_underscores >= 2) {
    assay_name <- strsplit(report_name, '_')[[1]][2]
  } else {
    assay_name <- "Assay"
  }
  return(assay_name)
}

challenge_visc_report <- function(report_name, interactive = TRUE) {

  if (!interactive) return(invisible(NULL))

  continue <- usethis::ui_yeah("
    Creating a new VISC PT Report called {report_name}.
    At VISC, we use a naming convention for PT reports:
    'VDCnnn_assay_PTreport_status_blindingifapplicable'
    where 'status' should be either 'interim' or 'final'
    and 'blindingifapplicable' should be either 'blinded'
    or 'unblinded' (applicable to interim reports only).
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

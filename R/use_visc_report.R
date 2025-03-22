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
  # knit the md from the Rmd on request of SRA team
  rmarkdown::render(
    usethis::proj_path('README.Rmd'),
    quiet = TRUE
  )
  # remove Rmd at request of SRA team; they just manually edit the *.md
  # so the Rmd file merely clutters their working directory
  unlink(
    usethis::proj_path(
      paste0(
        'README',
        c('.Rmd', '.html')
      )
    )
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
    template = "visc-project-group-colors.R",
    save_as = "R/group_colors.R",
    data = list(study_name = study_name),
    package = "VISCtemplates"
  )
}

use_study_schema <- function(study_name) {
  usethis::use_template(
    template = "visc-project-study-schema.R",
    save_as = "R/study_schema.R",
    data = list(study_name = study_name),
    package = "VISCtemplates"
  )
}

use_bib <- function(study_name) {
  usethis::use_template(
    template = "visc-project-bibliography.bib",
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
use_visc_report <- function(report_name = "VDCnnn_assay_PTreport",
                            path = NULL,
                            report_type = c("empty", "generic", "bama", "nab", "adcc"),
                            interactive = TRUE) {

  if (is.null(path)) {
    path <- dirname(report_name) # will be "." if no subdirectory specified in report_name
  }

  stopifnot(report_type %in% c("empty", "generic", "bama", "nab", "adcc"))

  # suppress usethis output when non-interactive
  old_usethis_quiet <- getOption('usethis.quiet')
  on.exit(options(usethis.quiet = old_usethis_quiet))
  options(usethis.quiet = !interactive)

  if (report_type != 'empty') challenge_visc_report(report_name, interactive)

  # create assay level folder (specified in path) and readme, if don't yet exist
  if (!dir.exists(path)) {
    dir.create(path, recursive = TRUE)

    # try to automatically fill in the study and assay names in readme, otherwise use deafults
    tryCatch(
      expr = { study_name <- strsplit(report_name, '_')[[1]][1] },
      error = function(e){ 
        message(paste("Could not extract study name from report name", report_name))
        message("Here's the original error message:")
        message(conditionMessage(e))
        study_name <- "Study Name"
      }
    )
    tryCatch(
      expr = { assay_name <- strsplit(report_name, '_')[[1]][2] },
      error = function(e){ 
        message(paste("Could not extract assay name from report name", report_name))
        message("Here's the original error message:")
        message(conditionMessage(e))
        assay_name <- "Assay Name"
      }
    )
    
    usethis::use_template(
      template = "README_assay_folder.md",
      data = list(study_name = study_name, assay_name = assay_name),
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

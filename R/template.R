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
#' @param report_name name of the file (character)
#' @param path path of the file within the active project
#' @param report_type "empty", "generic", or "bama"
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
                            report_type = c("empty", "generic", "bama")) {

  stopifnot(report_type %in% c("empty", "generic", "bama"))

  if (report_type == "empty") {
    rmarkdown::draft(
      file = file.path(path, report_name),
      template = "visc_empty",
      package = "VISCtemplates",
      create_dir = TRUE,
      edit = FALSE
      )
    usethis::ui_done(
      glue::glue("Creating an empty VISC report at '{{file.path(path, report_name)}}'")
      )

  } else {

    challenge_visc_report(report_name)

    rmarkdown::draft(
      file = file.path(path, report_name),
      template = "visc_report",
      package = "VISCtemplates",
      create_dir = TRUE,
      edit = FALSE
    )
    usethis::ui_done(
      glue::glue("Creating a VISC report at '{{file.path(path, report_name)}}'")
    )
    use_visc_methods(path = file.path(path, report_name), assay = report_type)
  }


}

challenge_visc_report <- function(report_name) {

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
#' @param assay "bama" or "generic"
#' @param path path within the active project
#'
#' @export
#'
#' @examples
#' \dontrun{
#' use_visc_methods(path = "bama/BAMA-PT-Report", assay = "bama")
#' }
use_visc_methods <- function(path = ".", assay = c("generic", "bama")) {

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

#' Convert to a VISC Report PDF/LaTeX document
#'
#' Runs the VISC Report for PDF output based on the template.tex file.
#'
#' @param latex_engine latex engine to use
#' @param keep_tex keep the .tex file
#' @param ... other options to pass to \code{bookdown::pdf_document2()}
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

  # If no project-level bib file creating report specific bib
  if (!file.exists(here::here('docs', 'bibliography.bib'))) {
    file.copy(from = system.file("templates", 'bibliography.bib',
                                 package = "VISCtemplates"),
            to = "bibliography.bib",
            overwrite = FALSE)
   }

  file.copy(from = find_resource("visc_report", "README_PT_Report.md"),
            to = "README.md",
            overwrite = FALSE)

  bookdown::pdf_document2(
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


#' Convert to a VISC Report Word document
#'
#' Runs the VISC Report for PDF output based on the template.tex file.
#'
#' @param toc include table of contents
#' @param fig_caption all figure captions
#' @param keep_md keep the .tex file
#' @param ... other options to pass to \code{bookdown::word_document2()}
#'
#' @details
#'
#' Normally used through `output:VISCtemplates::visc_word_document` in the .rmd YAML
#'
#' @export
#'
visc_word_document <- function(toc = TRUE,
                               fig_caption = TRUE,
                               keep_md = TRUE,
                              ...) {

  word_style_path <- find_resource("visc_report", "word-styles-reference.docx")

  # If no project-level bib file creating report specific bib
  if (!file.exists(here::here('docs', 'bibliography.bib'))) {
    file.copy(from = system.file("templates", 'bibliography.bib',
                                 package = "VISCtemplates"),
              to = "bibliography.bib",
              overwrite = FALSE)
  }

  file.copy(from = find_resource("visc_report", "README_PT_Report.md"),
            to = "README.md",
            overwrite = FALSE)

  bookdown::word_document2(
    toc = toc,
    fig_caption = fig_caption,
    keep_md = keep_md,
    reference_docx = word_style_path,
    ...)
}

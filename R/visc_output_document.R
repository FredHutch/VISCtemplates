
find_logo <- function(filename) {
  res <- system.file(
    "logos", filename, package = "VISCtemplates"
  )
  if (res == "") stop(
    "Couldn't find logo file ", filename, call. = FALSE
  )
  res
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

  template <- system.file("templates", "report_latex_template.tex",
                          package = "VISCtemplates")

  logo_path_scharp <- find_logo("SCHARP_logo.png")
  logo_path_fh <- find_logo("FredHutch_logo.png")
  logo_path_visc <- find_logo("VISC_logo.jpg")

  # If no project-level bib file creating report specific bib
  if (!file.exists(
    rprojroot::find_rstudio_root_file('docs', 'bibliography.bib')
  )) {
    file.copy(from = system.file("templates", 'bibliography.bib',
                                 package = "VISCtemplates"),
              to = "bibliography.bib",
              overwrite = FALSE)
  }

  # switch for a breaking change in pandoc template, see notes in template.tex
  use_old_csl_refs <- tolower(rmarkdown::pandoc_version() < '3.1.7')

  bookdown::pdf_document2(
    template = template,
    keep_tex = keep_tex,
    fig_caption = TRUE,
    latex_engine = latex_engine,
    pandoc_args = c(
      "-V", paste0("logo_path_scharp=", logo_path_scharp),
      "-V", paste0("logo_path_fh=", logo_path_fh),
      "-V", paste0("logo_path_visc=", logo_path_visc),
      "-M", paste0("use_old_csl_refs=", use_old_csl_refs)
    ),
    ...)
}


#' Convert to a VISC Report Word document
#'
#' Runs the VISC Report for Word output based on the word-styles-reference.docx file.
#'
#' @param toc include table of contents
#' @param fig_caption all figure captions
#' @param keep_md keep the .md file
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

  word_style_path <- system.file("templates", "report_word_template.docx",
                                 package = "VISCtemplates")

  # If no project-level bib file creating report specific bib
  if (!file.exists(
    rprojroot::find_rstudio_root_file('docs', 'bibliography.bib'))
  ) {
    file.copy(from = system.file("templates", 'bibliography.bib',
                                 package = "VISCtemplates"),
              to = "bibliography.bib",
              overwrite = FALSE)
  }

  bookdown::word_document2(
    toc = toc,
    fig_caption = fig_caption,
    keep_md = keep_md,
    reference_docx = word_style_path,
    number_sections = FALSE,
    ...)
}

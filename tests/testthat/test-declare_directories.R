#' Test when a template is generated it include declare_directories
#'
#' Sets up an ephemeral temporary directory, creates a VISC project in it,
#' creates a report of the specified type from the template, and knits it to the
#' specified output type. Then checks that within the docs folder created there is
#' a file "declare_directories.R"
#'
#' @param report_type Character, one of c('generic', 'empty', 'bama', 'nab')
#' @param outfile_ext Character, one of c('pdf', 'docx')
#'
#' @return Side effects only.
test_knit_report <- function(report_type, outfile_ext){
  stopifnot(
    report_type %in% c('generic', 'empty', 'bama', 'nab', 'adcc'),
    outfile_ext %in% c('pdf', 'docx')
  )
  report_name <- paste(report_type, outfile_ext, 'report', sep = '_')
  output_format <- c(pdf = 'VISCtemplates::visc_pdf_document',
                     docx = 'VISCtemplates::visc_word_document')[outfile_ext]
  test_context <- paste('knit', report_type, 'report', outfile_ext)
  suppressWarnings({
    # context() function is deprecated, but useful for test output readability
    testthat::context(test_context)
  })
  testthat::test_that(test_context, {
    # creates ephemeral directory that will be deleted upon function exit
    temp_dir <- withr::local_tempdir()
    create_visc_project(temp_dir, interactive = FALSE)
    local({
      # temporarily setwd() to temp_dir and undo upon exiting this local() block
      withr::local_dir(temp_dir)
      use_visc_report(report_name,
                      report_type = report_type,
                      interactive = FALSE
      )
    })
    expect_true(
      file.exists(paste0(temp_dir, 'docs', 'declare_directories.R'))
    )

  })
}

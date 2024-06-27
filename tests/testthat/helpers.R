#' Test knit from a report template
#'
#' @param report_type character, one of c('generic', 'empty', 'bama', 'nab')
#' @param outfile_ext character, one of c('pdf', 'docx')
#'
#' @return side effects only
test_knit_report <- function(report_type, outfile_ext){
  stopifnot(
    report_type %in% c('generic', 'empty', 'bama', 'nab'),
    outfile_ext %in% c('pdf', 'docx')
  )
  report_name <- paste(report_type, outfile_ext, 'report', sep = '_')
  output_format <- c(pdf = 'VISCtemplates::visc_pdf_document',
                     docx = 'VISCtemplates::visc_word_document')[outfile_ext]
  test_context <- paste('knit', report_type, 'report', outfile_ext)
  suppressWarnings({
    testthat::context(test_context)
  })
  testthat::test_that(test_context, {
    temp_dir <- withr::local_tempdir()
    create_visc_project(temp_dir, interactive = FALSE)
    local({
      withr::local_dir(temp_dir)
      use_visc_report(report_name,
                      report_type = report_type,
                      interactive = FALSE
      )
      expect_no_error(
        rmarkdown::render(file.path(report_name, paste0(report_name, '.Rmd')),
                          output_format = output_format,
                          quiet = TRUE,
                          clean = FALSE)
      )
      outfile_sans_ext <<- file.path(temp_dir, report_name, report_name)
    })
    expect_true(
      file.exists(paste0(outfile_sans_ext, '.', outfile_ext))
    )
    try_snapshot_ext <- list(
      pdf = c('pdf', 'log', 'tex', 'md', 'Rmd', 'knit.md'),
      docx = c('docx', 'md', 'knit.md', 'Rmd')
    )[[outfile_ext]]
    local({
      for (ext in try_snapshot_ext){
        outfile_path <- paste0(outfile_sans_ext, '.', ext)
        if (file.exists(outfile_path)){
          suppressWarnings({
            expect_snapshot_file(outfile_path)
          })
        }
      }
    })
  })
}

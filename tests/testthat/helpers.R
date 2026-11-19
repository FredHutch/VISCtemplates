#' Test knit from a report template
#'
#' Sets up an ephemeral temporary directory, creates a VISC project in it,
#' creates a report of the specified type from the template, and knits it to the
#' specified output type. Tests whether the report knits without errors or
#' warnings, whether the output file exists, and takes file snapshots of the
#' rendered output and/or intermediate debugging files to the
#' tests/testthat/_snaps directory. See the documentation in
#' test-use_visc_report.R for a description of what happens when testing in
#' different testing environments.
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
      # test knit in a separate R session
      rs <- callr::r_session$new()
      on.exit(rs$close(), add = TRUE)
      res <- rs$run_with_output(
        function(...) rmarkdown::render(envir = globalenv(), ...),
        args = list(
          file.path(report_name, paste0(report_name, '.Rmd')),
          output_format = output_format,
          quiet = TRUE,
          clean = FALSE
        )
      )
      # propagate full error stack from subprocess into main process
      if (!is.null(res$error)) {
        stop(paste(capture.output(res$error), collapse = '\n'))
      }
    })
    outfile_sans_ext <- file.path(temp_dir, report_name, report_name)
    expect_true(
      file.exists(paste0(outfile_sans_ext, '.', outfile_ext))
    )
    # we'll try to take file snapshots of these file types
    try_snapshot_ext <- list(
      pdf = c('pdf', 'log', 'tex', 'md', 'Rmd', 'knit.md'),
      docx = c('docx', 'md', 'knit.md', 'Rmd')
    )[[outfile_ext]]
    snapshot_dir <- file.path(getwd(), test_path('_snaps', 'use_visc_report'))
    if (! dir.exists(snapshot_dir)){
      dir.create(snapshot_dir, showWarnings = FALSE, recursive = TRUE)
    }
    for (ext in try_snapshot_ext){
      outfile_path <- paste0(outfile_sans_ext, '.', ext)
      if (file.exists(outfile_path)){
        file.copy(outfile_path, snapshot_dir)
        # avoid our custom snapshots from getting auto-deleted by testthat
        announce_snapshot_file(
          file.path(snapshot_dir, basename(outfile_path))
        )
      }
    }
  })
}


#' Test rendering a slide deck template
#'
#' Sets up an ephemeral temporary directory, creates a VISC project in it,
#' creates a slide deck of the specified type from the template, and renders
#' it to PPTX. Tests whether the deck renders without errors or warnings,
#' whether the output file exists, and takes file snapshots of the rendered
#' output and/or intermediate debugging files to the tests/testthat/_snaps
#' directory. See the documentation in test-use_slide_deck.R for a
#' description of what happens when testing in different testing
#' environments.
#'
#'
#' @return Side effects only.
test_render_slide_deck <- function(){
  deck_name <- "slide_deck"
  test_context <- paste('render slide deck')
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
      use_slide_deck(deck_name, interactive = FALSE)
      # test render in a separate R session
      rs <- callr::r_session$new()
      on.exit(rs$close(), add = TRUE)
      res <- rs$run_with_output(
        function(...) rmarkdown::render(envir = globalenv(), ...),
        args = list(
          file.path(deck_name, paste0(deck_name, '.Rmd')),
          # deck's own YAML front matter determines the output format (e.g.
          # powerpoint_presentation, with reference_doc: template.pptx for
          # branded decks), so no output_format override is passed here,
          # unlike test_knit_report()'s visc_pdf_document/visc_word_document
          quiet = TRUE,
          clean = FALSE
        )
      )
      # propagate full error stack from subprocess into main process
      if (!is.null(res$error)) {
        stop(paste(capture.output(res$error), collapse = '\n'))
      }
    })
    outfile_sans_ext <- file.path(temp_dir, deck_name, deck_name)
    expect_true(
      file.exists(paste0(outfile_sans_ext, '.pptx'))
    )
    # we'll try to take file snapshots of these file types
    try_snapshot_ext <- c('pptx', 'md', 'knit.md', 'Rmd')
    snapshot_dir <- file.path(getwd(), test_path('_snaps', 'use_slide_deck'))
    if (! dir.exists(snapshot_dir)){
      dir.create(snapshot_dir, showWarnings = FALSE, recursive = TRUE)
    }
    for (ext in try_snapshot_ext){
      outfile_path <- paste0(outfile_sans_ext, '.', ext)
      if (file.exists(outfile_path)){
        file.copy(outfile_path, snapshot_dir)
        # avoid our custom snapshots from getting auto-deleted by testthat
        announce_snapshot_file(
          file.path(snapshot_dir, basename(outfile_path))
        )
      }
    }
  })
}

#' Helper to detect [visc_compile()] default input file.
#'
#' @return The normalized path of the currently open Rstudio editor tab, or an error
visc_compile_input <- function(){
  rs <- rstudioapi::getSourceEditorContext()$path
  if (is.null(rs)){
    stop('Ensure your *.Rmd file is open in RStudio, or manually provide your *.Rmd path')
  } else {
    normalizePath(rs, winslash = '/')
  }
}

#' Helper to compute [visc_compile()] default output directory.
#'
#' @param input_file Input file from which to compute the output directory
#'
#' @return relative output directory for [visc_compile()]. Intended to be <project>/.../<this_report_folder>/
visc_compile_output_dir <- function(input_file){
  dirname(
    fs::path_rel(
      input_file,
      dirname(rprojroot::find_rstudio_root_file(path = input_file))
    )
  )
}

#' Knit VISC report to network folder
#'
#' @param input Path to Rmd file to knit. Defaults to currently open Rstudio editor tab
#' @param output_dir Path to write PDF, log, and ancillary knit files. Defaults to same relative path in VISC project as currently open Rstudio editor tab
#'
#' @return The directory to which files were written
#' @export
visc_compile <- function(
    input = visc_compile_input(),
    output_dir = visc_compile_output_dir(input)
){
  output_root <- networks_path('cavd/Temp/visc_compile_output')
  output_path <- file.path(output_root, output_dir)

  res <- callr::run(
    'Rscript',
    args = c(
      "-e",
      paste0(
        "rmarkdown::render('",
        input,
        "', output_dir = '",
        output_path,
        "')"
      )
    ),
    stderr_to_stdout = TRUE
  )

  log_path <- file.path(
    output_path,
    paste0(
      tools::file_path_sans_ext(basename(input)), '.Rout')
  )
  cat(res$stdout, file = log_path)

  output_path
}

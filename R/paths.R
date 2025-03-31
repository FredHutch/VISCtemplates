#' Construct networks path
#'
#' Requires environment variable `VISCTEMPLATES_NETWORKS_PATH` to be defined in
#' your `.Renviron` file. This will typically be `/networks` on Linux, `N:` on
#' Windows, and `/Volumes/networks` on macOS, but may vary depending on your
#' system's custom mapping. You can edit this file in Rstudio with
#' [usethis::edit_r_environ()].
#'
#' @param ... additional path components passed to [file.path()]; appended after the networks root path
#'
#' @return a character vector of the concatenated path
#' @export
networks_path <- function(...){
  p <- Sys.getenv('VISCTEMPLATES_NETWORKS_PATH')
  if (!nzchar(p)){
    stop('VISCTEMPLATES_NETWORKS_PATH not found. See `?VISCtemplates::networks_path`')
  }
  file.path(p, ...)
}

#' Construct trials path
#'
#' Requires environment variable `VISCTEMPLATES_TRIALS_PATH` to be defined in
#' your `.Renviron` file. This will typically be `/trials` on Linux, `T:` on
#' Windows, and `/Volumes/trials` on macOS, but may vary depending on your
#' system's custom mapping. You can edit this file in Rstudio with
#' [usethis::edit_r_environ()].
#'
#' @param ... additional path components passed to [file.path()]; appended after the trials root path
#'
#' @return a character vector of the concatenated path
#' @export
trials_path <- function(...){
  p <- Sys.getenv('VISCTEMPLATES_TRIALS_PATH')
  if (!nzchar(p)){
    stop('VISCTEMPLATES_TRIALS_PATH not found. See `?VISCtemplates::trials_path`')
  }
  file.path(p, ...)
}

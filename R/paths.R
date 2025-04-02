#' Construct networks path
#'
#' Requires environment variable `VISCTEMPLATES_NETWORKS_PATH` to be defined (on
#' its own line) in your `.Renviron` file. To make changes, edit this file in
#' Rstudio with [usethis::edit_r_environ()], save the file, then restart your R
#' session. Typical settings by operating system:
#' \itemize{
#' \item Windows
#' \preformatted{
#' VISCTEMPLATES_NETWORKS_PATH="N:"
#' }
#' \item macOS
#' \preformatted{
#' VISCTEMPLATES_NETWORKS_PATH="/Volumes/networks"
#' }
#' \item Linux
#' \preformatted{
#' VISCTEMPLATES_NETWORKS_PATH="/networks"
#' }
#' }
#'
#' @param ... additional path components passed to [file.path()]; appended after
#'   the networks root path
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
#' Requires environment variable `VISCTEMPLATES_TRIALS_PATH` to be defined (on
#' its own line) in your `.Renviron` file. To make changes, edit this file in
#' Rstudio with [usethis::edit_r_environ()], save the file, then restart your R
#' session. Typical settings by operating system:
#' \itemize{
#' \item Windows
#' \preformatted{
#' VISCTEMPLATES_TRIALS_PATH="T:"
#' }
#' \item macOS
#' \preformatted{
#' VISCTEMPLATES_TRIALS_PATH="/Volumes/trials"
#' }
#' \item Linux
#' \preformatted{
#' VISCTEMPLATES_TRIALS_PATH="/trials"
#' }
#' }
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

#' Construct networks path
#'
#' Requires environment variable `VISCTEMPLATES_NETWORKS_PATH` to be defined in
#' your `.Renviron` file. To do this,
#' \enumerate{
#' \item Edit this file in Rstudio with [usethis::edit_r_environ()]
#' \item Add a line to `.Renviron` defining `VISCTEMPLATES_NETWORKS_PATH`.
#' Only use the forward slash `/` as a path separator and do not use a trailing `/`.
#' Typical settings by operating system:
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
#' \item Save the file
#' \item Restart your R session
#' }
#'
#' @param ... additional path components passed to [file.path()]; appended after
#'   the networks root path
#'
#' @return a character vector of the concatenated path
#' @export
networks_path <- function(...){
  path_helper('VISCTEMPLATES_NETWORKS_PATH', 'VISCtemplates::networks_path', ...)
}

#' Construct trials path
#'
#' Requires environment variable `VISCTEMPLATES_TRIALS_PATH` to be defined in
#' your `.Renviron` file. To do this,
#' \enumerate{
#' \item Edit this file in Rstudio with [usethis::edit_r_environ()]
#' \item Add a line to `.Renviron` defining `VISCTEMPLATES_TRIALS_PATH`.
#' Only use the forward slash `/` as a path separator and do not use a trailing `/`.
#' Typical settings by operating system:
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
#' \item Save the file
#' \item Restart your R session
#' }
#'
#' @param ... additional path components passed to [file.path()]; appended after
#'   the trials root path
#'
#' @return a character vector of the concatenated path
#' @export
trials_path <- function(...){
  path_helper('VISCTEMPLATES_TRIALS_PATH', 'VISCtemplates::trials_path', ...)
}


#' Internal helper function for [networks_path()] and [trials_path()]
#'
#' @param envvar_nm Name of `.Renviron` variable
#' @param fn_nm Name of host function
#' @param ... Passed to [file.path()]
#'
#' @return Character vector of concatenated path elements
#' @noRd
path_helper <- function(envvar_nm, fn_nm, ...){
  p <- Sys.getenv(envvar_nm)
  if (!nzchar(p)){
    stop(sprintf('%s not defined in `.Renviron`. See `?%s()`', envvar_nm, fn_nm))
  }
  if (grepl('/$', p)){
    warning(
      sprintf(
        'Trailing path separator in `.Renviron` variable %s. See `?%s()`',
        envvar_nm, fn_nm
      )
    )
  }
  file.path(p, ...)
}

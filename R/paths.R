#' Construct paths
#'
#' Requires one-time setup of the environment variable
#' `VISCTEMPLATES_NETWORKS_PATH` or `VISCTEMPLATES_TRIALS_PATH` in your
#' `.Renviron` file. To do this,
#' \enumerate{
#' \item Open your `.Renviron` file for editing in Rstudio
#' with [usethis::edit_r_environ()]
#' \item Add needed line(s) to `.Renviron` defining `VISCTEMPLATES_NETWORKS_PATH`
#' and/or `VISCTEMPLATES_TRIALS_PATH` to reflect your operating system and your
#' drive mappings. Only use the forward slash `/` as a path
#' separator and do not use a trailing `/`. Typical settings:
#' \itemize{
#' \item Windows
#' \preformatted{
#' VISCTEMPLATES_NETWORKS_PATH="N:"
#' VISCTEMPLATES_TRIALS_PATH="T:"
#' }
#' \item macOS
#' \preformatted{
#' VISCTEMPLATES_NETWORKS_PATH="/Volumes/networks"
#' VISCTEMPLATES_TRIALS_PATH="/Volumes/trials"
#' }
#' \item Linux
#' \preformatted{
#' VISCTEMPLATES_NETWORKS_PATH="/networks"
#' VISCTEMPLATES_TRIALS_PATH="/trials" }
#' }
#' \item Save the file
#' \item Restart your R session (in Rstudio: `Session` > `Restart R`)
#' \item The function should now work for constructing paths
#' }
#'
#' @param ... additional path components passed to [file.path()]; appended after
#'   the networks or trials root path defined in your `.Renviron` file
#' @name paths
#' @return Character; the concatenated path
NULL

#' @rdname paths
#' @export
networks_path <- function(...) path_helper('networks', ...)

#' @rdname paths
#' @export
trials_path <- function(...) path_helper('trials', ...)

#' Internal helper function for [networks_path()] and [trials_path()]
#'
#' @param nm Short name of host function (`networks` or `trials`)
#' @param ... Passed to [file.path()]
#'
#' @return Character vector of concatenated path elements
#' @noRd
path_helper <- function(nm, ...){
  fn_help <- sprintf('See `?VISCtemplates::%s_path()`', nm)
  envvar_nm <- sprintf('VISCTEMPLATES_%s_PATH', toupper(nm))
  p_root <- Sys.getenv(envvar_nm)
  if (! nzchar(p_root)){
    stop(sprintf('%s not defined in `.Renviron`. %s', envvar_nm, fn_help))
  }
  if (grepl('/$', p_root)){
    warning(
      sprintf(
        'Trailing path separator in `.Renviron` variable %s. %s',
        envvar_nm, fn_help
      )
    )
  }
  file.path(p_root, ...)
}

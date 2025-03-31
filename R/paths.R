#' Construct networks path
#'
#' Requires environment variable VISCTEMPLATES_NETWORKS_PATH to be defined in
#' your .Renviron file. You can edit this file in Rstudio with
#' [usethis::edit_r_environ()].
#'
#' @param ... character vectors; path components passed to [file.path()]
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
#' Requires environment variable VISCTEMPLATES_TRIALS_PATH to be defined in
#' your .Renviron file. You can edit this file in Rstudio with
#' [usethis::edit_r_environ()].
#'
#' @param ... character vectors; path components passed to [file.path()]
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

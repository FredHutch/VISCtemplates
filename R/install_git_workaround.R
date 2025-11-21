#' Wrapper to use [remotes::install_git()] on network drive paths
#'
#' @param ... Arguments passed to [remotes::install_git()]
#'
#' @return Called for package installation side effect
#' @export
install_git_workaround = function(...){
  if(! file.exists(..1)){
    stop(sprintf('File not found: "%s"', ..1))
  } #nocov start
  # temporarily tweak working directory for remotes::install_git() bug
  current_dir = getwd()
  on.exit(setwd(current_dir))
  setwd(dirname(..1))
  a <- list(...)
  do.call(
    remotes::install_git,
    c(
      # tweak 1st argument for remotes::install_git() bug
      lapply(a[1L], basename),
      # rest of arguments, if present
      a[setdiff(seq_along(a), 1L)]
    )
  )
} # nocov end

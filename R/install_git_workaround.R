#' Wrapper to use [remotes::install_git()] on network drive paths
#'
#' @param repo_path Path to `.git` repo of (data)package to install
#' @param ... Additional arguments passed to [remotes::install_git()]
#'
#' @return Called for package installation side effect
#' @export
install_git_workaround = function(repo_path, ...){
  if(! file.exists(repo_path)){
    stop(sprintf('File not found: "%s"', repo_path))
  } #nocov start
  # temporarily tweak working directory for remotes::install_git() bug
  current_dir = getwd()
  on.exit(setwd(current_dir))
  setwd(dirname(repo_path))
  remotes::install_git(basename(repo_path), ...)
} # nocov end

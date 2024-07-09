# This function exists solely to avoid R CMD check warnings due to VISCfunctions
# being in Imports but only being used in Rmd template, not in actual package
# code. See:
# https://r-pkgs.org/dependencies-in-practice.html#how-to-not-use-a-package-in-imports
# We want VISCfunctions to be in Imports so that it will get auto-installed
# whenever someone installs VISCtemplates from github.
ignore_unused_imports <- function() {
  VISCfunctions::get_session_info
  invisible(NULL)
}

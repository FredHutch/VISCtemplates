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


#' Detect package names referenced with :: in text
#'
#' Scan an input character vector (or single string) for occurrences of
#' <pkg>::<symbol> or <pkg>:::<symbol> and return the unique package names.
#'
#' @param text Character vector or single string to scan.
#' @return Character vector of unique package names (may be length 0).
#' @examples
#' detect_namespaces_in_text("dplyr::filter(x)\nVISCfunctions::get_session_info()")
#' @export
#' @family utilities
detect_namespaces_in_text <- function(text){
  if (length(text) == 0) return(character(0))
  txt <- paste(text, collapse = "\n")
  # find occurrences like pkg:: or pkg:::
  m <- gregexpr("([[:alpha:].][[:alnum:]._]*)::+", txt, perl = TRUE)
  matches <- regmatches(txt, m)[[1]]
  if (length(matches) == 0) return(character(0))
  pkgs <- sub("::+$", "", matches)
  unique(pkgs)
}

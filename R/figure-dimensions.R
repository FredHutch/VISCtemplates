#' Validate an optional figure dimension
#'
#' @param x Optional dimension in inches.
#' @param arg Argument name for error messages.
#' @keywords internal
#' @noRd
check_figure_dimension <- function(x, arg) {
  if (is.null(x)) return(invisible(NULL))
  if (!is.numeric(x) || length(x) != 1L || !is.finite(x) || x <= 0) {
    stop(sprintf("%s must be NULL or a single finite positive number (in inches).", arg),
         call. = FALSE)
  }
  invisible(x)
}

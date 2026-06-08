#' knitr figure wrapper for ggplot2-type objects
#'
#' Inserts a figure as a knitr sub-chunk so that chunk options (such as
#' captions) can be set programmatically and looped runtime rather than being
#' hard-coded per figure. This is useful when figures are generated
#' inside a loop or function and you still want per-figure captions and
#' cross-referencing. When run interactively, the figure(s) are simply printed. This intended
#' for ggplot, patchwork, cowplot, grid/grob, gtable, or lattice-type plots. For use of base R plots
#' use this deprecated version: insert_fig_subchunk_deparse
#'
#' @param fig A plot object (e.g. a ggplot or any object with a print method)
#'   to be rendered in the sub-chunk. For base R plots, see ?insert_fig_subchunk_deparse
#' @param fig_chunk_name A character string giving the knitr chunk label for
#'   the generated sub-chunk (e.g., "fig-cd4-env-infg"). Must be unique within the document.
#' @param fig_caption_short A character string used as the short figure caption
#'   (passed to the `fig.scap` chunk option).
#' @param fig_caption_long A character string used as the full figure caption
#'   (passed to the `fig.cap` chunk option).
#' @param .interactive Logical; whether to treat the call as interactive. When
#'   `TRUE`, the figure is printed directly (useful when developing or running
#'   code interactively); when `FALSE`, the figure is emitted as a knitr
#'   sub-chunk. Defaults to [base::interactive()], so it normally reflects the
#'   current session. Recommended to leave at default.
#' @returns When run non-interactively it writes the knitted sub-chunk output via `cat()`;
#'   When run interactively it prints `fig` directly, and invisibly returns `NULL`.
#' @export
#'
#' @examples
#' \dontrun{
#' library(ggplot2)
#' p <- ggplot(mtcars, aes(wt, mpg)) + geom_point()
#' insert_fig_subchunk(
#'   fig               = p,
#'   fig_chunk_name    = "mtcars_scatter",
#'   fig_caption_short = "Weight vs. MPG",
#'   fig_caption_long  = "Scatterplot of car weight against fuel efficiency (mpg)."
#' )
#' }
insert_fig_subchunk = function(fig, fig_chunk_name, fig_caption_short, fig_caption_long,
                               .interactive = interactive()) {

  # check early for troubleshooting during interactive development
  .check_chunk_name(fig_chunk_name)
  .check_caption(fig_caption_short, "fig_caption_short")
  .check_caption(fig_caption_long, "fig_caption_long")

  # this assign() below only works for certain object types
  .is_printable_figure <- function(x) {
    inherits(x, c("ggplot", "patchwork", "grob", "gtable", "trellis"))
  }

  # inside insert_fig_subchunk, after the caption/label checks:
  if (!.is_printable_figure(fig)) {
    stop("`fig` is not a recognized printable graphic (ggplot, patchwork, ",
         "cowplot, grid/grob, gtable, or lattice). For base R plotting calls ",
         "or other deferred figures, use insert_fig_subchunk_deparse().",
         call. = FALSE)
  }

  # when working interactively, this will print the figure instead
  if(.interactive) {
    print(fig)
    return(invisible())
  }

  # Assign the live figure object into the environment knitr evaluates chunks
  # in, under a unique, syntactically-valid name derived from the chunk label.
  # The generated chunk then just prints this object -- nothing about the
  # figure is serialized to source code, so the chunk body stays a fixed,
  # trivial expression that is robust to code instrumentation (e.g. covr).
  fig_var <- make.names(paste0(".fig_subchunk_obj_", fig_chunk_name))
  assign(fig_var, fig, envir = knitr::knit_global())
  on.exit(
    suppressWarnings(rm(list = fig_var, envir = knitr::knit_global())),
    add = TRUE
  )

  fig_sub_chunk <- .build_fig_subchunk(
    chunk_body        = paste0("print(", fig_var, ")"),
    fig_chunk_name    = fig_chunk_name,
    fig_caption_short = fig_caption_short,
    fig_caption_long  = fig_caption_long
  )

  cat(knitr::knit(text = knitr::knit_expand(text = fig_sub_chunk), quiet = TRUE))
}

#' Assembles the sub-chunk header and body into the fenced chunk text.
#'
#' @param chunk_body A character string used verbatim as the chunk body.
#' @param fig_chunk_name Chunk label.
#' @param fig_caption_short Short caption (fig.scap).
#' @param fig_caption_long Long caption (fig.cap).
#' @return A length-1 character string: the fenced knitr chunk.
#' @keywords internal
#' @noRd
.build_fig_subchunk <- function(chunk_body, fig_chunk_name,
                               fig_caption_short, fig_caption_long) {
  paste0(
    "\n```{r ", fig_chunk_name, ", ",
    "fig.scap=", encodeString(as.character(fig_caption_short), quote = "'"), ", ",
    "fig.cap=",  encodeString(as.character(fig_caption_long),  quote = "'"), "}",
    "\n", chunk_body,
    "\n```\n"
  )
}

#' internal helper for insert_fig_subchunk, catches caption input for latex
#'
#' @param x string input (caption strings)
#' @param arg name of argument for error reporting
#' @keywords internal
#' @noRd
.check_caption <- function(x, arg = "caption") {
  x <- as.character(x)
  if (length(x) == 0 || is.na(x[1])) return(invisible(x))
  x1 <- x[1]

  # control / non-printable chars are the fingerprint of a single-backslash
  # LaTeX command in R source (e.g. "$\alpha$" -> \a became a control char).
  # The user almost certainly meant a double backslash ("$\\alpha$").
  if (grepl("[\x01-\x08\x0b\x0c\x0e-\x1f\x7f]", x1, perl = TRUE)) {
    stop(sprintf(
      "%s contains a control character, which usually means a LaTeX command was written with a single backslash (e.g. \"$\\alpha$\"). Use a double backslash in R strings: \"$\\\\alpha$\".",
      arg
    ), call. = FALSE)
  }

  # unbalanced math-mode delimiters
  delims <- gregexpr("(?<!\\\\)\\$", x1, perl = TRUE)[[1]]
  n <- if (length(delims) == 1 && delims[1] == -1) 0L else length(delims)
  if (n %% 2 != 0) {
    stop(sprintf(
      "%s has an odd number of unescaped '$' (%d) - a math-mode delimiter is unclosed, which will break LaTeX rendering: %s",
      arg, n, encodeString(x1, quote = '"')
    ), call. = FALSE)
  }

  invisible(x)
}


#' internal helper for insert_fig_subchunk, checks chunk naming
#'
#' @param x string input (chunk name)
#' @param arg name of argument for error reporting
#' @keywords internal
#' @noRd
.check_chunk_name <- function(x, arg = "fig_chunk_name") {
  if (length(x) != 1 || !is.character(x) || is.na(x) || !nzchar(x)) {
    stop(sprintf("%s must be a single non-empty string.", arg), call. = FALSE)
  }
  # characters that corrupt the chunk header's "label, opt=val" parsing
  if (grepl("[,\\s'\"`_]", x, perl = TRUE)) {
    stop(sprintf(
      "%s ('%s') contains spaces, commas, underscores, or quotes, which break the chunk header. Use letters, digits, hyphens, or periods.",
      arg, x
    ), call. = FALSE)
  }
  invisible(x)
}

#' Insert a figure sub-chunk (deparse version)
#'
#' `r lifecycle::badge("deprecated")`
#'
#' A historical implementation of [insert_fig_subchunk()] that captures the
#' figure by deparsing an expression rather than assigning a printable object.
#' It is less robust (fragile under code instrumentation) but supports a wider range of figure types, including base R
#' plots. Prefer [insert_fig_subchunk()] for ggplot and other printable
#' graphic objects; use this only when you must defer evaluation of a base R
#' plotting call.
#'
#' @inheritParams insert_fig_subchunk
#' @inherit insert_fig_subchunk return
#'
#' @seealso [insert_fig_subchunk()]
#' @keywords internal
#' @export
#'
#' @examples
#' \dontrun{
#' library(ggplot2)
#' p <- ggplot(mtcars, aes(wt, mpg)) + geom_point()
#' insert_fig_subchunk_deparse(
#'   fig               = p,
#'   fig_chunk_name    = "mtcars_scatter",
#'   fig_caption_short = "Weight vs. MPG",
#'   fig_caption_long  = "Scatterplot of car weight against fuel efficiency (mpg)."
#' )
#' }
# nocov start
insert_fig_subchunk_deparse = function(fig, fig_chunk_name, fig_caption_short, fig_caption_long,
                                       .interactive = interactive()) {

  # check early for troubleshooting during interactive development
  .check_chunk_name(fig_chunk_name)
  .check_caption(fig_caption_short, "fig_caption_short")
  .check_caption(fig_caption_long, "fig_caption_long")

  # when working interactively, this will print the figure instead
  if(.interactive) {
    print(fig)
    return(invisible())
  }

  fig_deparsed <- paste0(deparse(function(){fig}), collapse = '')

  fig_sub_chunk <-   paste0(
    "\n```{r ", fig_chunk_name, ", ",
    "fig.scap=", encodeString(as.character(fig_caption_short), quote = "'"), ", ",
    "fig.cap=",  encodeString(as.character(fig_caption_long),  quote = "'"), "}",
    "\n(", fig_deparsed, ")()",
    "\n```\n"
  )

  cat(knitr::knit(text = knitr::knit_expand(text = fig_sub_chunk), quiet = TRUE))
}
# nocov end

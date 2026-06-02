#' knitr figure wrapper
#'
#' Inserts a figure as a knitr sub-chunk so that chunk options (such as
#' captions) can be set programmatically and looped runtime rather than being
#' hard-coded per figure. This is useful when figures are generated
#' inside a loop or function and you still want per-figure captions and
#' cross-referencing. When run interactively, the figure(s) are simply printed.
#'
#' @param fig A plot object (e.g. a ggplot or any object with a print method)
#'   to be rendered in the sub-chunk.
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

  # when working interactively, this will print the figure instead
  if(.interactive) {
    print(fig)
    return(invisible())
  }

  fig_deparsed <- paste0(deparse(function(){fig}), collapse = '')
  fig_sub_chunk <- paste0(
    "\n```{r ", fig_chunk_name, ', ',
    "fig.scap='", fig_caption_short, "', ",
    "fig.cap='", fig_caption_long, "'}",
    "\n(", fig_deparsed, ")()", "\n```\n")
  cat(knitr::knit(text = knitr::knit_expand(text = fig_sub_chunk), quiet = TRUE))

}

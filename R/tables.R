#'
#' This file contains functions related to table creation for reports.
#'

#' Set kable warnings based on output type
#'
#' This can be used to set the `warning` option in R Markdown code chunks to
#' remove warnings created by knitr::kable() when knitting to a Word document.
#'
#' @param output_type character string of document output type
#'
#' @return logical
#' @export
#'
#' @examples
#' \dontrun{
#'
#' kable_warnings <- set_kable_warnings(output_type = get_output_type())
#'
#' ```{r chunk-label, warning=kable_warnings}
#'
#' ```
#'
#' }
set_kable_warnings <- function(output_type) {
  output_type == 'latex'
}

#' Add a short caption to a flextable object for PDF output only
#'
#' In LaTeX/PDF output, flextable captions don't support a separate short
#' caption for the list of tables. This function extracts the full caption
#' from the rendered LaTeX, inserts a short caption (auto-derived from the
#' first sentence if not supplied), and re-emits the LaTeX so it renders
#' correctly in the document. For HTML/Word output, the flextable is
#' returned unchanged.
#'
#' @param ft flextable object.
#' @param short character. Short caption to use in the LaTeX
#'   \code{\\caption[short]{full}} construct. If \code{NULL} (default), the
#'   first sentence of the full caption is used.
#'
#' @return For LaTeX output, a \code{knitr::asis_output} object containing
#'   the modified LaTeX so it renders correctly in the document chunk. For
#'   HTML/Word output, the original \code{ft} object, unchanged.
#' @export
#'
#' @examples
#' \dontrun{
#' ft <- flextable::flextable(head(mtcars)) |>
#'   flextable::set_caption("A caption. More detail follows.")
#' ft_add_short_caption(ft)
#' ft_add_short_caption(ft, short = "Custom short caption")
#' }
ft_add_short_caption <- function(ft, short = NULL) {

  if (!knitr::is_latex_output()) {
    return(ft)  # HTML/Word: return as-is
  }

  tex <- as.character(knitr::knit_print(ft))

  m <- regexec("\\\\caption\\{(.*?)\\}", tex)
  full <- regmatches(tex, m)[[1]][2]

  if (is.na(full)) {
    return(knitr::asis_output(tex))  # no caption set, nothing to shorten
  }

  if (is.null(short)) {
    short <- regmatches(full, regexpr("^[^.]+\\.", full))
    if (length(short) == 0) short <- full  # no sentence break found; fall back to full caption
  }
  short <- gsub("[\\[\\]]", "", short)  # avoid corrupting \caption[...] syntax

  tex <- sub("\\\\caption\\{", paste0("\\\\caption[", short, "]{"), tex)
  knitr::asis_output(tex)

}

#' Insert a table as a knitr sub-chunk
#'
#' Renders a `kable` or `flextable` object as its own fenced, captioned
#' sub-chunk, generated and knitted at call time. This allows tables to be
#' produced inside a loop (or any other repeated/programmatic context) within
#' a single parent chunk, since normal chunk-level options like captions
#' otherwise only apply once per chunk.
#'
#' Caption handling differs by table type: `kable` objects get their caption
#' from the `tab.cap`/`tab.scap` chunk options (read by bookdown's kable
#' hook). `flextable` objects ignore chunk options entirely, so their
#' caption and Word bookmark must already be set on the object (e.g. via
#' [flextable::set_caption()] and, for LaTeX short captions, `ft_add_short_caption()`)
#' before calling this function.
#'
#' @param tab A `kable` or `flextable` object to render. If `NULL`, the
#'   function returns without producing any output (loops sometimes generate
#'   `NULL` tables for skipped iterations). If this is a flextable object, caption should already be added.
#' @param tab_chunk_name Character. Unique chunk label for the generated sub-chunk.
#' @param tab_caption_short Character, optional. Short caption (will not have any effect for flextable objects).
#' @param tab_caption_long Character, optional. Full caption (will not have any effect for flextable objects).
#' @param .interactive Logical. If `TRUE` (the default when running
#'   interactively), `tab` is printed directly instead of being knitted as a
#'   sub-chunk, which is more convenient during interactive development.
#'
#' @return Invisibly `NULL`. Called for its side effect of printing or
#'   knitting `tab`.
#' @export
#'
#' @examples
#' \dontrun{
#' for (i in seq_along(my_tables)) {
#'   insert_tab_subchunk(
#'     tab               = my_tables[[i]],
#'     tab_chunk_name    = paste0("tab_", i),
#'     tab_caption_short = short_captions[[i]],
#'     tab_caption_long  = long_captions[[i]]
#'   )
#' }
#'
#' # flextable, caption already set on the object
#' my_flextable <- flextable::flextable(head(mtcars)) |>
#'   flextable::set_caption("A caption. More detail follows.") |>
#'   ft_add_short_caption(short = "Custom short caption")
#' insert_tab_subchunk(tab = my_flextable, tab_chunk_name = "tab_ft1")
#' }
insert_tab_subchunk <- function(tab,
                                tab_chunk_name,
                                tab_caption_short = NULL,
                                tab_caption_long = NULL,
                                .interactive = interactive()) {

  if (is.null(tab)) return(invisible(NULL)) # sometimes get null tables when looping

  # check early for troubleshooting during interactive development
  check_chunk_name(tab_chunk_name)
  if (!is.null(tab_caption_short)) { check_caption(tab_caption_short, "tab_caption_short") }
  if (!is.null(tab_caption_long)) { check_caption(tab_caption_long, "tab_caption_long") }

  # when working interactively, this will print the table instead
  if(.interactive) {
    print(tab)
    return(invisible())
  }

  tab_deparsed <- paste0(deparse(function(){tab}), collapse = '')
  tab_sub_chunk <- build_subchunk(
    chunk_body    = paste0(tab_deparsed),
    chunk_name    = tab_chunk_name,
    type          = "tab",
    caption_short = tab_caption_short,
    caption_long  = tab_caption_long
  )

  cat(knitr::knit(text = knitr::knit_expand(text = tab_sub_chunk), quiet = TRUE))

}

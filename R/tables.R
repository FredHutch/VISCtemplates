#
# This file contains functions related to table creation for reports.
#

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

#' Add a short caption to a flextable for PDF output
#'
#' Records a short caption without immediately rendering the table.
#' During knitting to PDF, the short caption is inserted into the
#' rendered LaTeX caption. Other output formats render normally.
#'
#' Apply this function after other flextable formatting operations.
#'
#' @param ft A flextable object.
#' @param short A single non-missing character string containing
#'   LaTeX-ready short-caption text. Escape LaTeX-special characters
#'   as needed, for example `"Response (50\\%)"`.
#'   If `NULL`, a short caption is derived from the rendered full
#'   caption using a sentence-boundary heuristic. This heuristic may
#'   split after abbreviations; supply `short` explicitly for complex captions.
#'
#' @return A flextable with deferred short-caption information.
#' @export
#'
#' @examples
#' \dontrun{
#' ft <- flextable::flextable(head(mtcars)) |>
#'   flextable::set_caption("A caption. More detail follows.") |>
#'   ft_add_short_caption(short = "Custom short caption")
#' ft
#' }
ft_add_short_caption <- function(ft, short = NULL) {
  if (!inherits(ft, "flextable")) {
    stop("ft must be a flextable object.", call. = FALSE)
  }

  if (!is.null(short) &&
      (!is.character(short) || length(short) != 1L || is.na(short))) {
    stop(
      "short must be NULL or a single non-missing character string.",
      call. = FALSE
    )
  }

  attr(ft, "visc_short_caption") <- list(short = short)
  class(ft) <- unique(c("visc_short_caption", class(ft)))
  ft
}

#' Render a flextable with a deferred short caption
#'
#' @param x A flextable marked by [ft_add_short_caption()].
#' @param ... Passed to the flextable rendering method.
#' @importFrom knitr knit_print
#' @export
#' @keywords internal
knit_print.visc_short_caption <- function(x, ...) {
  caption_info <- attr(x, "visc_short_caption")
  class(x) <- setdiff(class(x), "visc_short_caption")
  attr(x, "visc_short_caption") <- NULL

  rendered <- knitr::knit_print(x, ...)
  if (!knitr::is_latex_output()) {
    return(rendered)
  }

  tex <- paste(as.character(rendered), collapse = "\n")
  tex <- insert_latex_short_caption(tex, short = caption_info$short)
  cacheable <- attr(rendered, "knit_cacheable")

  knitr::asis_output(
    tex,
    meta = attr(rendered, "knit_meta"),
    cacheable = if (is.null(cacheable)) NA else cacheable
  )
}

#' Whether a character is escaped by an odd number of backslashes
#' @noRd
latex_char_is_escaped <- function(chars, pos) {
  n_backslashes <- 0L
  i <- pos - 1L
  while (i >= 1L && chars[i] == "\\") {
    n_backslashes <- n_backslashes + 1L
    i <- i - 1L
  }
  n_backslashes %% 2L == 1L
}

#' Find the closing brace for a LaTeX group
#' @noRd
find_latex_group_end <- function(chars, open_pos) {
  depth <- 0L
  for (i in seq.int(open_pos, length(chars))) {
    if (latex_char_is_escaped(chars, i)) next
    if (chars[i] == "{") {
      depth <- depth + 1L
    } else if (chars[i] == "}") {
      depth <- depth - 1L
      if (depth == 0L) return(i)
    }
  }
  NA_integer_
}

#' Derive a short caption without cutting a LaTeX group in half
#' @noRd
derive_latex_short_caption <- function(caption) {
  chars <- strsplit(caption, "", fixed = TRUE)[[1L]]
  if (!length(chars)) return("")

  depth <- 0L
  for (i in seq_along(chars)) {
    if (latex_char_is_escaped(chars, i)) next
    if (chars[i] == "{") {
      depth <- depth + 1L
    } else if (chars[i] == "}") {
      depth <- depth - 1L
    }
    next_is_boundary <- i == length(chars) ||
      grepl("[[:space:]]", chars[i + 1L])
    if (chars[i] == "." && depth == 0L && next_is_boundary) {
      return(substr(caption, 1L, i))
    }
  }
  caption
}

#' Insert a short caption into rendered LaTeX
#' @noRd
insert_latex_short_caption <- function(tex, short = NULL) {
  start <- regexpr("\\caption{", tex, fixed = TRUE)[1L]
  if (start == -1L) {
    if (!is.null(short)) {
      warning(
        "Could not find a supported LaTeX caption; ",
        "the requested short caption was not inserted.",
        call. = FALSE
      )
    }
    return(tex)
  }

  chars <- strsplit(tex, "", fixed = TRUE)[[1L]]
  open_pos <- start + nchar("\\caption")
  close_pos <- find_latex_group_end(chars, open_pos)
  if (is.na(close_pos)) {
    warning(
      "Could not locate the end of the LaTeX caption; ",
      "the rendered table was left unchanged.",
      call. = FALSE
    )
    return(tex)
  }

  full_caption <- substr(tex, open_pos + 1L, close_pos - 1L)
  if (is.null(short)) short <- derive_latex_short_caption(full_caption)

  paste0(
    substr(tex, 1L, open_pos - 1L),
    "[{", short, "}]",
    substr(tex, open_pos, nchar(tex))
  )
}

#' Insert a table as a knitr subchunk
#'
#' Renders a kable or flextable object in its own generated subchunk.
#' This allows tables to be produced inside loops and functions.
#'
#' Set captions on the table before calling this function, using
#' `knitr::kable(caption = ...)` or `flextable::set_caption()`.
#' For PDF short captions on flextables, additionally use
#' [ft_add_short_caption()].
#'
#' The calling R Markdown chunk must use `results = 'asis'`.
#' Use `echo = FALSE` on the calling chunk to hide the loop or
#' function call; generated table code is always hidden.
#'
#' @param tab A kable or flextable object, including a flextable
#'   marked by [ft_add_short_caption()]. If `NULL`, no output is produced.
#' @param tab_chunk_name A unique chunk label. Use letters, digits,
#'   hyphens, or periods; underscores are not allowed.
#' @param .interactive A single non-missing logical value.
#'   If `TRUE`, print the table directly rather than knitting a subchunk.
#'
#' @return Invisibly `NULL`, called for its output side effect.
#' @export
#'
#' @examples
#' \dontrun{
#' # In an R Markdown chunk with results='asis', echo=FALSE:
#' for (i in seq_along(my_tables)) {
#'   insert_tab_subchunk(
#'     tab = my_tables[[i]],
#'     tab_chunk_name = paste0("tab-", i)
#'   )
#' }
#'
#' my_flextable <- flextable::flextable(head(mtcars)) |>
#'   flextable::set_caption("A caption. More detail follows.") |>
#'   ft_add_short_caption(short = "Custom short caption")
#' insert_tab_subchunk(my_flextable, tab_chunk_name = "tab-ft1")
#' }
insert_tab_subchunk <- function(tab, tab_chunk_name,
                                .interactive = interactive()) {
  if (is.null(tab)) return(invisible(NULL))
  check_chunk_name(tab_chunk_name, arg = "tab_chunk_name")

  if (!is.logical(.interactive) || length(.interactive) != 1L ||
      is.na(.interactive)) {
    stop(
      ".interactive must be a single non-missing logical value.",
      call. = FALSE
    )
  }
  if (!inherits(tab, c("knitr_kable", "flextable"))) {
    stop(
      "tab must be NULL, a knitr kable, or a flextable object.",
      call. = FALSE
    )
  }
  if (.interactive) {
    print(tab)
    return(invisible(NULL))
  }

  tab_env <- new.env(parent = knitr::knit_global())
  assign(".visc_table", tab, envir = tab_env)
  tab_sub_chunk <- build_subchunk(
    chunk_body = ".visc_table",
    chunk_name = tab_chunk_name,
    type = "tab"
  )
  output <- knitr::knit_child(
    text = tab_sub_chunk,
    envir = tab_env,
    options = list(echo = FALSE),
    quiet = TRUE
  )
  cat(output, sep = "\n")
  invisible(NULL)
}

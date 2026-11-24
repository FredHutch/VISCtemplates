# ft_add_short_caption() -----------------------------------------------

test_that("short captions are stored without removing the flextable class", {
  skip_if_not_installed("flextable")
  ft <- flextable::flextable(head(mtcars))

  out <- ft_add_short_caption(ft, short = "Short caption")

  expect_s3_class(out, "flextable")
  expect_s3_class(out, "visc_short_caption")
  expect_identical(
    attr(out, "visc_short_caption"),
    list(short = "Short caption")
  )

  # NULL means derive the short caption later, during rendering
  out <- ft_add_short_caption(ft)
  expect_identical(
    attr(out, "visc_short_caption"),
    list(short = NULL)
  )
})

test_that("invalid short-caption inputs are rejected", {
  expect_error(
    ft_add_short_caption(data.frame(x = 1)),
    "ft must be a flextable"
  )

  skip_if_not_installed("flextable")
  ft <- flextable::flextable(head(mtcars))

  for (short in list(1, NA_character_, character(0), c("a", "b"))) {
    expect_error(
      ft_add_short_caption(ft, short = short),
      "short must be NULL or a single non-missing character string",
      fixed = TRUE
    )
  }
})


# LaTeX caption helpers ------------------------------------------------

test_that("an explicit short caption is inserted and the full caption is kept", {
  tex <- "\\caption{Full caption. More detail.}\\label{tab:example}"

  expect_identical(
    insert_latex_short_caption(tex, short = "Short caption"),
    "\\caption[{Short caption}]{Full caption. More detail.}\\label{tab:example}"
  )
})

test_that("the first sentence is used when no short caption is supplied", {
  expect_identical(
    insert_latex_short_caption("\\caption{First sentence. More detail.}"),
    "\\caption[{First sentence.}]{First sentence. More detail.}"
  )

  expect_identical(
    derive_latex_short_caption("Caption without a period"),
    "Caption without a period"
  )

  expect_identical(derive_latex_short_caption(""), "")
})

test_that("caption parsing handles nested groups and escaped braces", {
  tex <- "\\caption{A \\textbf{bold. phrase}. More detail.}"

  expect_identical(
    insert_latex_short_caption(tex),
    paste0(
      "\\caption[{A \\textbf{bold. phrase}.}]",
      "{A \\textbf{bold. phrase}. More detail.}"
    )
  )

  expect_identical(
    insert_latex_short_caption(
      "\\caption{An escaped \\} brace. More detail.}",
      short = "Short"
    ),
    "\\caption[{Short}]{An escaped \\} brace. More detail.}"
  )
})

test_that("missing or malformed captions are left unchanged", {
  tex <- "\\begin{tabular}{l}Example\\end{tabular}"

  expect_identical(insert_latex_short_caption(tex), tex)

  expect_warning(
    out <- insert_latex_short_caption(tex, short = "Short"),
    "Could not find a supported LaTeX caption",
    fixed = TRUE
  )
  expect_identical(out, tex)

  malformed <- "\\caption{Unclosed caption"

  expect_warning(
    out <- insert_latex_short_caption(malformed),
    "Could not locate the end of the LaTeX caption",
    fixed = TRUE
  )
  expect_identical(out, malformed)
})


# insert_tab_subchunk() ------------------------------------------------

test_that("NULL tables produce no output and return invisibly", {
  expect_output(
    result <- withVisible(insert_tab_subchunk(NULL)),
    NA
  )

  expect_null(result$value)
  expect_false(result$visible)
})

test_that("invalid table inputs are rejected", {
  expect_error(
    insert_tab_subchunk(data.frame(x = 1), "tab-example"),
    "tab must be NULL, a knitr kable, or a flextable object",
    fixed = TRUE
  )

  tab <- knitr::kable(data.frame(x = 1))

  expect_error(
    insert_tab_subchunk(tab, "tab_bad", .interactive = TRUE)
  )

  for (value in list(NA, 1, logical(0), c(TRUE, FALSE))) {
    expect_error(
      insert_tab_subchunk(tab, "tab-example", .interactive = value),
      ".interactive must be a single non-missing logical value",
      fixed = TRUE
    )
  }
})

test_that("interactive insertion prints the table and returns invisibly", {
  tab <- knitr::kable(data.frame(x = "example-value"), format = "pipe")

  expect_output(
    result <- withVisible(
      insert_tab_subchunk(tab, "tab-example", .interactive = TRUE)
    ),
    "example-value"
  )

  expect_null(result$value)
  expect_false(result$visible)
})

test_that("noninteractive insertion knits the table in a child environment", {
  tab <- knitr::kable(data.frame(value = "example-value"), format = "pipe")
  received <- NULL
  parent_env <- knitr::knit_global()
  local_mocked_bindings(
    knit_child = function(text, envir, options, quiet, ...) {
      received <<- list(text = text, envir = envir, options = options, quiet = quiet)
      c("rendered table", "second output line")
    },
    .package = "knitr"
  )
  out <- capture.output(
    result <- withVisible(
      insert_tab_subchunk(tab, tab_chunk_name = "table-child", .interactive = FALSE)
    )
  )
  expect_identical(out, c("rendered table", "second output line"))
  expect_null(result$value)
  expect_false(result$visible)
  expect_match(received$text, "```{r table-child}", fixed = TRUE)
  expect_match(received$text, ".visc_table", fixed = TRUE)
  expect_identical(get(".visc_table", envir = received$envir, inherits = FALSE), tab)
  expect_identical(parent.env(received$envir), parent_env)
  expect_identical(received$options, list(echo = FALSE))
  expect_true(received$quiet)
})

# Deferred short-caption rendering -------------------------------------

test_that("non-LaTeX rendering delegates without modifying the result", {
  skip_if_not_installed("flextable")
  ft <- flextable::flextable(data.frame(x = 1))
  wrapped <- ft_add_short_caption(ft, short = "Short")
  rendered <- knitr::asis_output(
    "<table>example</table>",
    meta = list(list(name = "example-dependency")), cacheable = FALSE
  )
  received <- NULL
  local_mocked_bindings(
    knit_print = function(x, ...) {
      received <<- list(x = x, dots = list(...))
      rendered
    },
    is_latex_output = function(...) FALSE,
    .package = "knitr"
  )
  out <- knit_print.visc_short_caption(wrapped, options = list(label = "table-html"))
  expect_identical(out, rendered)
  expect_identical(received$x, ft)
  expect_identical(received$dots$options, list(label = "table-html"))
})

test_that("LaTeX rendering inserts short captions and preserves attributes", {
  skip_if_not_installed("flextable")
  ft <- flextable::flextable(data.frame(x = 1))
  tex <- "\\caption{First sentence. More detail.}"
  cases <- list(
    list(short = "Custom short caption", cacheable = TRUE,
         expected = "\\caption[{Custom short caption}]{First sentence. More detail.}"),
    list(short = NULL, cacheable = FALSE,
         expected = "\\caption[{First sentence.}]{First sentence. More detail.}"),
    list(short = "Response (50\\%)", cacheable = NA,
         expected = "\\caption[{Response (50\\%)}]{First sentence. More detail.}")
  )
  local_mocked_bindings(
    knit_print = function(x, ...) rendered,
    is_latex_output = function(...) TRUE,
    .package = "knitr"
  )
  for (case in cases) {
    rendered <- knitr::asis_output(
      tex, meta = list(list(name = "example-dependency")),
      cacheable = case$cacheable
    )
    out <- knit_print.visc_short_caption(ft_add_short_caption(ft, short = case$short))
    expect_s3_class(out, "knit_asis")
    expect_identical(as.character(out), case$expected)
    expect_identical(attr(out, "knit_meta"), attr(rendered, "knit_meta"))
    expect_identical(attr(out, "knit_cacheable"), attr(rendered, "knit_cacheable"))
  }
})

test_that("LaTeX rendering accepts a missing cacheability attribute", {
  skip_if_not_installed("flextable")
  ft <- flextable::flextable(data.frame(x = 1))
  rendered <- knitr::asis_output("\\caption{Full caption.}")
  attr(rendered, "knit_cacheable") <- NULL
  local_mocked_bindings(
    knit_print = function(x, ...) rendered,
    is_latex_output = function(...) TRUE,
    .package = "knitr"
  )
  out <- knit_print.visc_short_caption(ft_add_short_caption(ft, short = "Short"))
  expect_identical(as.character(out), "\\caption[{Short}]{Full caption.}")
  expect_identical(attr(out, "knit_cacheable"), NA)
})

# Parent-to-child knitting integration ---------------------------------

test_that("tables inserted in a loop appear without exposing generated code", {
  env <- new.env(parent = globalenv())
  env$insert_table <- insert_tab_subchunk
  env$tables <- list(
    knitr::kable(data.frame(value = "first-table-marker"), format = "pipe"),
    knitr::kable(data.frame(value = "second-table-marker"), format = "pipe")
  )
  text <- paste(
    "```{r table-loop-parent, results='asis', echo=FALSE}",
    "for (i in seq_along(tables)) {",
    "  insert_table(",
    "    tables[[i]],",
    "    tab_chunk_name = paste0('loop-table-', i),",
    "    .interactive = FALSE",
    "  )",
    "}",
    "```", sep = "\n"
  )
  out <- knitr::knit(text = text, envir = env, quiet = TRUE)
  expect_match(out, "first-table-marker", fixed = TRUE)
  expect_match(out, "second-table-marker", fixed = TRUE)
  expect_false(grepl(".visc_table", out, fixed = TRUE))
  expect_false(grepl("insert_table(", out, fixed = TRUE))
})

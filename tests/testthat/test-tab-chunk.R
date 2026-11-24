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

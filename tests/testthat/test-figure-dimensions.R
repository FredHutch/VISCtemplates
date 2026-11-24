test_that("figure dimensions are omitted by default without changing chunks", {
  expect_identical(
    build_subchunk("plot(1)", "fig1", "fig", "Short", "Long"),
    "\n\n```{r fig1, fig.scap='Short', fig.cap='Long'}\n\nplot(1)\n\n```\n\n"
  )
  expect_identical(
    build_subchunk("x", "tab1", "tab", "Short", "Long"),
    "\n\n```{r tab1, tab.scap='Short', tab.cap='Long'}\n\nx\n\n```\n\n"
  )
})

test_that("build_subchunk includes each supplied figure dimension", {
  expect_identical(
    build_subchunk("x", "fig1", "fig", fig_height = 4),
    "\n\n```{r fig1, fig.height=4}\n\nx\n\n```\n\n"
  )
  expect_identical(
    build_subchunk("x", "fig1", "fig", fig_width = 6),
    "\n\n```{r fig1, fig.width=6}\n\nx\n\n```\n\n"
  )
  expect_identical(
    build_subchunk("x", "fig1", "fig", fig_height = 4, fig_width = 6),
    "\n\n```{r fig1, fig.height=4, fig.width=6}\n\nx\n\n```\n\n"
  )
})

test_that("dimension serialization uses a decimal point regardless of OutDec", {
  withr::local_options(OutDec = ",")
  out <- build_subchunk("x", "fig1", "fig", fig_height = 4.5, fig_width = 6.5)
  expect_match(out, "fig.height=4.5, fig.width=6.5", fixed = TRUE)
})

test_that("figure dimensions must be single finite positive numbers", {
  invalid <- list(0, -1, NA_real_, NaN, Inf, -Inf, numeric(), c(4, 6), "4", TRUE, list(4))
  for (value in invalid) {
    expect_error(
      build_subchunk("x", "fig1", "fig", fig_height = value),
      "fig_height must be NULL or a single finite positive number"
    )
    expect_error(
      build_subchunk("x", "fig1", "fig", fig_width = value),
      "fig_width must be NULL or a single finite positive number"
    )
    expect_error(
      insert_fig_subchunk(NULL, "fig1", "Short", "Long", TRUE, fig_height = value),
      "fig_height must be NULL or a single finite positive number"
    )
    expect_error(
      insert_fig_subchunk(NULL, "fig1", "Short", "Long", TRUE, fig_width = value),
      "fig_width must be NULL or a single finite positive number"
    )
  }
  expect_invisible(check_figure_dimension(NULL, "dimension"))
  expect_identical(check_figure_dimension(4L, "dimension"), 4L)
  expect_identical(check_figure_dimension(4.5, "dimension"), 4.5)
})

test_that("insert_fig_subchunk forwards dimensions to the knitted chunk", {
  captured <- NULL
  knit_env <- new.env(parent = baseenv())
  testthat::local_mocked_bindings(
    knit_global = function(...) knit_env,
    knit_expand = function(text, ...) text,
    knit = function(text, ...) {
      captured <<- text
      "knitted output"
    },
    .package = "knitr"
  )
  fig <- structure(list(), class = "grob")
  out <- capture.output(
    insert_fig_subchunk(fig, "sized-fig", "Short", "Long", FALSE,
                        fig_height = 4, fig_width = 6)
  )
  expect_identical(out, "knitted output")
  expect_match(captured, "fig.height=4, fig.width=6", fixed = TRUE)
  expect_length(ls(knit_env, all.names = TRUE), 0L)
})

test_that("interactive printing preserves the existing fifth positional argument", {
  printed <- NULL
  testthat::local_mocked_bindings(
    print = function(x, ...) { printed <<- x; invisible(x) },
    .package = "base"
  )
  fig <- structure(list(), class = "grob")
  expect_invisible(
    insert_fig_subchunk(fig, "interactive-fig", "Short", "Long", TRUE,
                        fig_height = 4, fig_width = 6)
  )
  expect_identical(printed, fig)
})

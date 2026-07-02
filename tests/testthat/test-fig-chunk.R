# tests/testthat/test-insert_fig_subchunk.R
#
# Unit tests for insert_fig_subchunk() and the extracted string-builder
# build_fig_subchunk(). End-to-end rendering of templated Rmds is covered
# separately by the CI report-build tests; these tests focus on the pure
# string-assembly logic and branch behavior that is awkward to diagnose
# from a failed render.

# ---------------------------------------------------------------------------
# insert_fig_subchunk(): branch behavior
# ---------------------------------------------------------------------------

test_that("interactive: draws the figure and does not knit", {
  skip_if_not_installed("ggplot2")
  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()
  pdf(NULL); on.exit(dev.off(), add = TRUE)

  knit_called <- FALSE
  local_mocked_bindings(
    knit = function(...) { knit_called <<- TRUE; "" },
    knit_expand = function(text, ...) text,
    .package = "knitr"
  )

  out <- capture.output(
    expect_invisible(
      insert_fig_subchunk(p, "chunk1", "short", "long", .interactive = TRUE)
    )
  )
  expect_false(knit_called)
  expect_length(out, 0)
})

test_that("non-interactive: assembles a chunk and cats the knitted result", {
  skip_if_not_installed("ggplot2")
  # build the plot BEFORE mocking base functions, so ggplot2's load hooks
  # run against the real cat/print
  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()

  local_mocked_bindings(
    knit_expand = function(text, ...) text,
    knit        = function(text, quiet = TRUE, ...) text,
    .package = "knitr"
  )
  captured <- NULL
  local_mocked_bindings(
    cat = function(...) captured <<- paste0(...),
    .package = "base"
  )

  insert_fig_subchunk(p, "myChunk", "Short cap", "Long cap", .interactive = FALSE)

  expect_match(captured, "```\\{r myChunk,")
  expect_match(captured, "fig\\.scap='Short cap'")
  expect_match(captured, "fig\\.cap='Long cap'")
  expect_match(captured, "```\\s*$")
  # body now references the assigned object rather than a deparsed closure
  expect_match(captured, "print\\(\\.fig_subchunk_obj_myChunk\\)")
})

test_that("default for .interactive is interactive()", {
  # getting interactive() to cooperate with check() and test() was a pain
  expect_equal(formals(insert_fig_subchunk)$.interactive, quote(interactive()))
})

# Verifies that insert_fig_subchunk() accepts the figure types its assign/print
# path can handle (self-contained printable graphics) and rejects others with a
# clear error directing the user to insert_fig_subchunk_deparse().
#
# helper: call insert_fig_subchunk non-interactively with knitting stubbed out,
# so we exercise the type guard + chunk assembly without a real render.
call_insert <- function(fig, name = "test-fig") {
  local_mocked_bindings(
    knit_expand = function(text, ...) text,
    knit        = function(text, quiet = TRUE, ...) text,
    .package = "knitr"
  )
  local_mocked_bindings(cat = function(...) invisible(NULL), .package = "base")
  insert_fig_subchunk(
    fig               = fig,
    fig_chunk_name    = name,
    fig_caption_short = "short",
    fig_caption_long  = "long",
    .interactive      = FALSE
  )
}

# ---- accepted figure types --------------------------------------------------

test_that("accepts a ggplot object", {
  skip_if_not_installed("ggplot2")
  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()
  expect_no_error(call_insert(p))
})

test_that("accepts a ggpairs (ggmatrix) object", {
  skip_if_not_installed("GGally")
  p <- GGally::ggpairs(mtcars[1:3])
  expect_no_error(call_insert(p))
})

# ---- rejected figure types: error redirects to the deparse version ----------


test_that("rejects base R plot", {
  expect_error(call_insert(plot(1:5)), "insert_fig_subchunk_deparse")
})


test_that("rejects base R plot", {
  expect_error(insert_fig_subchunk(
    fig               = plot(1:5),
    fig_chunk_name    = "x",
    fig_caption_short = "short",
    fig_caption_long  = "long",
    .interactive      = TRUE
  ), "insert_fig_subchunk_deparse")
})


test_that("rejects a data frame and points to insert_fig_subchunk_deparse", {
  expect_error(call_insert(mtcars), "insert_fig_subchunk_deparse")
})

test_that("rejects NULL (the value a base R plot call returns)", {
  expect_error(call_insert(NULL), "insert_fig_subchunk_deparse")
})


test_that("rejects a model object", {
  expect_error(call_insert(lm(mpg ~ wt, mtcars)), "insert_fig_subchunk_deparse")
})

test_that("rejects an atomic vector", {
  expect_error(call_insert(1:10), "insert_fig_subchunk_deparse")
})

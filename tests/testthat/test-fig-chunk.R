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

test_that("interactive: prints the figure, returns invisibly, no knitting", {
  printed <- NULL
  local_mocked_bindings(
    print = function(x, ...) printed <<- x,
    .package = "base"
  )
  # guards: these must NOT be touched on the interactive path
  cat_called <- FALSE
  local_mocked_bindings(
    cat = function(...) cat_called <<- TRUE,
    .package = "base"
  )

  expect_invisible(
    insert_fig_subchunk("FIGURE", "chunk1", "short", "long", .interactive = TRUE)
  )
  expect_identical(printed, "FIGURE")
  expect_false(cat_called)
})

test_that("non-interactive: assembles a chunk and cats the knitted result", {
  # Intercept knitting so we test the string handed to knitr, not knitr's
  # output. knit_expand / knit are passed through unchanged here.
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

  insert_fig_subchunk(quote(plot(1)), "myChunk", "Short cap", "Long cap", .interactive = FALSE)

  expect_match(captured, "```\\{r myChunk,")
  expect_match(captured, "fig\\.scap='Short cap'")
  expect_match(captured, "fig\\.cap='Long cap'")
  expect_match(captured, "```\\s*$")
})

test_that("default for .interactive is interactive()", {
  # getting interactive() to cooperate with check() and test() was a pain
  expect_equal(formals(insert_fig_subchunk)$.interactive, quote(interactive()))
})

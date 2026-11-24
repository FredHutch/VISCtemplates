
test_that("captions and label generate correct chunk specification, caption order", {
  out <- build_subchunk("print(x)", "myChunk", "fig", "Short", "Long")
  expect_match(out, "```\\{r myChunk, fig\\.scap='Short', fig\\.cap='Long'\\}")
  expect_match(out, "print\\(x\\)", fixed = FALSE)
  expect_match(out, "fig\\.scap='Short'")
  expect_match(out, "fig\\.cap='Long'")
  expect_false(grepl("fig\\.cap='Short'", out))
})

# helper: pull the chunk header line and confirm its options parse as valid R
expect_parseable_chunk_options <- function(out) {
  header <- regmatches(out, regexpr("(?<=\\{r )[^}]*", out, perl = TRUE))
  # header looks like: "c, fig.scap='...', fig.cap='...'"
  # the first token is the label; the rest are name=value options.
  opts <- sub("^[^,]*,\\s*", "", header)
  expect_silent(parse(text = paste0("list(", opts, ")")))
}

test_that("apostrophe in caption yields a parseable chunk option", {
  out <- build_subchunk("print(x)", "c", "fig", "Donor's titer", "Long")
  expect_parseable_chunk_options(out)
})

test_that("embedded double quote yields a parseable chunk option", {
  out <- build_subchunk("print(x)", "c", "fig", 'The "high" dose', "Long")
  expect_parseable_chunk_options(out)
})

test_that("backslash in caption yields a parseable chunk option", {
  out <- build_subchunk("print(x)", "c", "fig", "path\\to\\fig", "Long")
  expect_parseable_chunk_options(out)
})

test_that("glue() caption is coerced and lands in the option", {
  cap <- glue::glue("n = {n}", n = 12)
  out <- build_subchunk("print(x)", "c", "fig", cap, "Long")
  expect_parseable_chunk_options(out)
  expect_match(out, "n = 12", fixed = TRUE)
})

test_that("empty-string caption yields a parseable chunk option", {
  out <- build_subchunk("print(x)", "c", "fig", "", "Long")
  expect_parseable_chunk_options(out)
})

test_that("LaTeX-special chars survive as valid chunk options (rendering covered by report tests)", {
  out <- build_subchunk("print(x)", "c", "fig", "50% response & p<0.05", "Long")
  expect_parseable_chunk_options(out)
  expect_match(out, "50% response & p<0.05", fixed = TRUE)
  # NB: correct LaTeX rendering of % and & is verified by the Rmd render tests.
})

test_that("Variable passing and more latex (rendering covered by report tests)", {
  i <- "test"
  out <- build_subchunk("print(x)", "c", "fig", "short",
                        paste0("Looped long caption for ", i, ". With it's special character examples: _ $\\alpha$.")
  )
  expect_parseable_chunk_options(out)
  expect_match(out, "With it\\'s special character examples: _ $\\\\alpha$.", fixed = TRUE)
})


test_that("unbalanced $ in caption errors and incorrect escpate", {
  expect_error(check_caption("$\\alpha < 5", "fig_caption_long"), "unclosed")
  expect_error(check_caption("$\alpha < 5$", "fig_caption_long"), "double backslash")
  expect_error(check_caption("$\\alpha < 5$ and $\\beta = ", "fig_caption_long"), "unclosed")
})

test_that("balanced $ passes", {
  expect_silent(check_caption("$\\alpha < 5$ and $\\beta$", "fig_caption_long"))
})


test_that("check_chunk_name rejects invalid labels and accepts valid", {
  expect_error(check_chunk_name("fig label"),      "spaces")   # space
  expect_error(check_chunk_name("fig,label"),      "commas")   # comma
  expect_error(check_chunk_name("fig_label"),      "under")    # underscore
  expect_error(check_chunk_name('fig"label'),      "quotes")   # double quote
  expect_error(check_chunk_name(""),               "non-empty")# empty string

  expect_silent(check_chunk_name("example-plot-loop"))
  expect_silent(check_chunk_name("fig.scatter.1"))
  expect_silent(check_chunk_name("Figure3"))
})


test_that("check_caption handles empty and NA captions", {
  expect_invisible(check_caption(character(0), "fig_caption_short"))
  expect_invisible(check_caption(NA_character_, "fig_caption_short"))
})

test_that("figure dimensions are included only when supplied", {
  cases <- list(
    list(height = NULL, width = NULL),
    list(height = 4, width = NULL),
    list(height = NULL, width = 6),
    list(height = 4.5, width = 6.25)
  )
  for (case in cases) {
    out <- build_subchunk(
      chunk_body = "print(x)", chunk_name = "dimension-test",
      type = "fig", fig_height = case$height, fig_width = case$width
    )
    expect_parseable_chunk_options(out)
    if (is.null(case$height)) {
      expect_false(grepl("fig.height=", out, fixed = TRUE))
    } else {
      expect_match(out, paste0("fig.height=", case$height), fixed = TRUE)
    }
    if (is.null(case$width)) {
      expect_false(grepl("fig.width=", out, fixed = TRUE))
    } else {
      expect_match(out, paste0("fig.width=", case$width), fixed = TRUE)
    }
  }
})

test_that("invalid figure dimensions are rejected", {
  invalid <- list(0, -1, NA_real_, NaN, Inf, -Inf,
                  "4", TRUE, numeric(0), c(4, 6))
  for (value in invalid) {
    expect_error(
      build_subchunk("print(x)", "dimension-test", "fig", fig_height = value),
      "fig_height must be NULL or a single finite positive number", fixed = TRUE
    )
    expect_error(
      build_subchunk("print(x)", "dimension-test", "fig", fig_width = value),
      "fig_width must be NULL or a single finite positive number", fixed = TRUE
    )
  }
})

test_that("table chunks use table caption options", {
  out <- build_subchunk(
    chunk_body = ".visc_table", chunk_name = "table-test", type = "tab",
    caption_short = "Short", caption_long = "Long"
  )
  expect_match(out, "tab.scap='Short'", fixed = TRUE)
  expect_match(out, "tab.cap='Long'", fixed = TRUE)
  expect_false(grepl("fig.cap=", out, fixed = TRUE))
  expect_parseable_chunk_options(out)
})

test_that("unsupported subchunk types are rejected", {
  expect_error(build_subchunk("x", "test-chunk", type = "unsupported"), "arg")
})

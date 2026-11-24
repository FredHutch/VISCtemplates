test_that("ft_add_short_caption preserves tex with unbalanced caption braces", {
  tex <- "\\caption{An unfinished caption"

  testthat::local_mocked_bindings(
    is_latex_output = function(...) TRUE,
    knit_print = function(x, ...) tex,
    .package = "knitr"
  )

  out <- ft_add_short_caption(structure(list(), class = "flextable"))

  expect_s3_class(out, "knit_asis")
  expect_identical(as.character(out), tex)
})

test_that("insert_tab_subchunk accepts supplied captions", {
  tab <- data.frame(x = 1, y = 2)

  out <- capture.output(
    insert_tab_subchunk(
      tab,
      tab_chunk_name = "tab-with-captions",
      tab_caption_short = "Short caption",
      tab_caption_long = "Long caption.",
      .interactive = TRUE
    )
  )

  expect_true(any(grepl("x", out, fixed = TRUE)))
  expect_true(any(grepl("y", out, fixed = TRUE)))
})

test_that("insert_tab_subchunk rejects invalid supplied captions", {
  tab <- data.frame(x = 1)

  expect_error(
    insert_tab_subchunk(
      tab,
      tab_chunk_name = "tab-invalid-short",
      tab_caption_short = "Unclosed $math",
      .interactive = TRUE
    ),
    "tab_caption_short"
  )

  expect_error(
    insert_tab_subchunk(
      tab,
      tab_chunk_name = "tab-invalid-long",
      tab_caption_long = "Unclosed $math",
      .interactive = TRUE
    ),
    "tab_caption_long"
  )
})

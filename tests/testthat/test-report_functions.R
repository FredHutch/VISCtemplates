test_that("insert_ref returns NULL with a warning outside knit context", {
  # knitr option is NULL by default outside a knit context, but be explicit
  knitr::opts_knit$set(rmarkdown.pandoc.to = NULL)

  expect_warning(
    result <- insert_ref("my-ref"),
    "called outside a knit context"
  )
  expect_null(result)
})

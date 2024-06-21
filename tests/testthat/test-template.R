test_that("generic report knits", {
  # temporary directory deleted after test_that block
  foo <- withr::local_tempdir()
  create_visc_project(foo, interactive = FALSE)
  # temporarily setwd() during test_that block
  withr::local_dir(foo)
  use_visc_report(report_type = "generic", interactive = FALSE)
  expect_no_error(
    rmarkdown::render(file.path('PT-Report', 'PT-Report.Rmd'), quiet = TRUE)
  )
  expect_true(
    file.exists(file.path("PT-Report", "PT-Report.pdf"))
  )
})

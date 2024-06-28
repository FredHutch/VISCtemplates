testthat::test_that('no error when repos option unset, e.g. in knit session', {
  withr::local_options(list(repos = NULL))
  withr::with_temp_libpaths({
    # long-lived CRAN package we don't have, with few dependencies
    expect_no_error(install_load_cran_packages('tensor'))
  }
  )
})

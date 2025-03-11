test_that("declare_directories works", {

  # check when we choose folders = "networks"
  expect_error(declare_directories(folder)) #expect error vs expect stop()?

  expect_no_error()

  # check when we choose folders = "networks"
  expect_error(declare_directories(folder))

  expect_no_error()

})

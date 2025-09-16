test_that("create_visc_project works as expected in default mode", {
  # creates ephemeral directory that will be deleted upon function exit
  temp_dir <- withr::local_tempdir()
  create_visc_project(temp_dir, interactive = FALSE)
  # check that proper README files got rendered and deleted
  expect_true(
    file.exists(file.path(temp_dir, 'README.md'))
  )
  expect_false(
    file.exists(file.path(temp_dir, 'README.Rmd'))
  )
  expect_false(
    file.exists(file.path(temp_dir, 'README.html'))
  )
  # verify that package-specific files are not created
  expect_false(
    file.exists(file.path(temp_dir, 'DESCRIPTION'))
  )
  expect_false(
    file.exists(file.path(temp_dir, 'NAMESPACE'))
  )
})

test_that("create_visc_project works in pacakge mode", {
  # creates ephemeral directory that will be deleted upon function exit
  temp_dir <- withr::local_tempdir()
  create_visc_project(temp_dir, interactive = FALSE, package = TRUE)
  # check for package-specific files
  expect_true(
    file.exists(file.path(temp_dir, 'DESCRIPTION'))
  )
  expect_true(
    file.exists(file.path(temp_dir, 'NAMESPACE'))
  )
})

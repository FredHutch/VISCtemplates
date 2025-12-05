test_that("install_git_workaround", {
  expect_error(
    install_git_workaround(file.path(tempfile(), 'nofile')),
    'File not found'
  )
})

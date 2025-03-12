test_that("get_server_path returns the expected networks, trials or forced location", {

  # default behavior is to return networks path
  expect_true(get_server_path() %in% c("N:/", "/networks/", "/Volumes/networks/"))

  # default behavior is to return networks path
  expect_true(get_server_path(folder = "trials") %in% c("T:/", "/trials/", "/Volumes/trials/"))

  # force_windows_path provides entry for windows path to output
  expect_equal(get_server_path(force_windows_path = "test/path"),
               "test/path")

  # cant test alt_root or alt_folder without setting up folders to check for in CI enviro
})


test_that("get_os returns expected string", {
  # confirm that output of get_os() is one of our three expected string outputs
  expect_true(get_os() %in% c("windows", "linux", "osx"))

})

test_that("get_root returns expected string", {
  # confirm that output of get_root() is one of our three expected string outputs
  # note depends on get_os() which is tested before
  expect_true(get_root(get_os()) %in% c("/", "/Volumes/", ""))

})

test_that(".try_paths throws error when no paths exist", {

  # we get stop message when none of the root and path combos exist
  expect_error(.try_paths(root = c("fake_dir", "not_real", "nope"),
                          path = c("folder1", "folder2")))
})

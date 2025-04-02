test_that("paths functions work", {
  null_envvars <- c(
    VISCTEMPLATES_NETWORKS_PATH = NA,
    VISCTEMPLATES_TRIALS_PATH = NA
  )
  withr::with_envvar(null_envvars, {
    # error when envvar not yet set
    expect_error(networks_path(), 'VISCTEMPLATES_NETWORKS_PATH')
    expect_error(trials_path(), 'VISCTEMPLATES_TRIALS_PATH')
  })
  if (.Platform$OS.type == 'windows'){
    trailing_envvars <- c(
      VISCTEMPLATES_NETWORKS_PATH = 'N:\\',
      VISCTEMPLATES_TRIALS_PATH = 'T:\\'
    )
    withr::with_envvar(trailing_envvars, {
      expect_warning(networks_path(), 'Trailing.*VISCTEMPLATES_NETWORKS_PATH')
      expect_warning(trials_path(), 'Trailing.*VISCTEMPLATES_TRIALS_PATH')
    })
    windows_envvars <- c(
      VISCTEMPLATES_NETWORKS_PATH = 'N:',
      VISCTEMPLATES_TRIALS_PATH = 'T:'
    )
    withr::with_envvar(windows_envvars, {
      expect_equal(networks_path('cavd', 'Studies'), 'N:/cavd/Studies')
      expect_equal(trials_path('dir', 'file.txt'), 'T:/dir/file.txt')
    })
  }
  # macOS not tested here, but uses same unix-style path construction
  if (.Platform$OS.type == 'unix'){
    trailing_envvars <- c(
      VISCTEMPLATES_NETWORKS_PATH = '/networks/',
      VISCTEMPLATES_TRIALS_PATH = '/trials/'
    )
    withr::with_envvar(trailing_envvars, {
      expect_warning(networks_path(), 'Trailing.*VISCTEMPLATES_NETWORKS_PATH')
      expect_warning(trials_path(), 'Trailing.*VISCTEMPLATES_TRIALS_PATH')
    })
    linux_envvars <- c(
      VISCTEMPLATES_NETWORKS_PATH = '/networks',
      VISCTEMPLATES_TRIALS_PATH = '/trials'
    )
    withr::with_envvar(linux_envvars, {
      expect_equal(networks_path('cavd', 'Studies'), '/networks/cavd/Studies')
      expect_equal(trials_path('dir', 'file.txt'), '/trials/dir/file.txt')
    })
  }
})

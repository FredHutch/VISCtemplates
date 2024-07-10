# use these options for testthat tests, interactively or non-interactively,
# and restore previously set options when tests are finished
# https://testthat.r-lib.org/articles/special-files.html
withr::local_options(
  list(
    DataPackageR_interact = FALSE,
    DataPackageR_packagebuilding = FALSE,
    DataPackageR_verbose = FALSE
  ),
  .local_envir = teardown_env()
)

# Delete existing report template snapshots before testing. These are binary
# files that change with each knit, so we don't want to programmatically compare
# them and we only want to save the fresh ones. This, along with adding this
# directory to .gitignore and .Rbuildignore, enables keeping our local snapshots
# folder clean and up to date when interactively running the same tests that
# will be run on CI. See additional info in
# tests/testthat/test-use_visc_report.R
local({
  template_snaps_dir <- testthat::test_path('_snaps', 'use_visc_report')
  if (dir.exists(template_snaps_dir)){
    unlink(template_snaps_dir, recursive = TRUE)
  }
})

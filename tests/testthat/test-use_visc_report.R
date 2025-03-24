test_that("use_visc_report() creates main report .Rmd file and assay and report level README files, even if specified path does not already exist", {
  temp_dir <- withr::local_tempdir()
  create_visc_project(temp_dir, interactive = FALSE)
  local({
    withr::local_dir(temp_dir)
    report_name <- "Caskey820_BAMA_PT_Report"
    report_type <- "bama"
    path <- "BAMA"
    expect_no_warning(
      use_visc_report(
        report_name, path = path, report_type = report_type, interactive = FALSE
      )
    )
    expect_true(
      file.exists(file.path(path, report_name, paste0(report_name, ".Rmd")))
    )
    expect_true(
      # report level readme file exists
      file.exists(file.path(path, report_name, "README.md"))
    )
    expect_true(
      # assay level readme file exists
      file.exists(file.path(path, "README.md"))
    )
  })
})

test_that("use_visc_report() creates main report .Rmd file and assay and report level README files, even if report_type not specified and report_name doesn't use correct formatting", {
  temp_dir <- withr::local_tempdir()
  create_visc_project(temp_dir, interactive = FALSE)
  local({
    withr::local_dir(temp_dir)
    report_name <- "NonstandardReportName"
    expect_no_warning(
      use_visc_report(
        report_name, interactive = FALSE
      )
    )
    expect_true(
      file.exists(file.path(report_name, paste0(report_name, ".Rmd")))
    )
    expect_true(
      # report level readme file exists
      file.exists(file.path(report_name, "README.md"))
    )
    expect_true(
      # assay level readme file exists
      file.exists(file.path("README.md"))
    )
  })
})

test_that("use_visc_report() throws error if subdirectory included in report_name argument", {
  temp_dir <- withr::local_tempdir()
  create_visc_project(temp_dir, interactive = FALSE)
  local({
    withr::local_dir(temp_dir)
    report_name <- "BAMA/Caskey820_BAMA_PT_Report"
    expect_error(
      use_visc_report(
        report_name, report_type = "bama", interactive = FALSE
      )
    )
  })
})

# This will test knitting all template report types, both pdf and docx. What
# happens with file snapshots varies a bit depending on the testing context:
#
# When tests are run interactively via devtools::test(), all existing snapshots
# in tests/testthat/_snaps/use_visc_report in your VISCtemplates source repo are
# deleted (because tests/testthat/setup.R is automatically run first) and
# replaced with new snapshots. You shouldn't notice any changes in your git repo
# because these are already .gitignored and .Rbuildignored.
#
# When tests are run inside R CMD check locally, e.g. via devtools::check(), the
# testing happens from a temporary directory, so any existing files in
# tests/testthat/_snaps/use_visc_report within your VISCtemplates package source
# tree are not changed. Check timestamps if you're confused.
#
# When the tests run on GitHub Actions CI, the snapshot files are uploaded as
# artifacts for online viewing. Currently, if any of the tests fail, the file
# snapshots will be buried within a larger results artifact, but when all tests
# succeed, they will be in a snapshots artifact. Hopefully soon this will be
# changed to always have the latter behavior regardless of test success.
#
# This sets a custom test context(), so should go last in this test file
local({
  for (report_type in c('generic', 'empty', 'bama', 'nab', 'adcc')){
    for (output_ext in c('pdf', 'docx')){
      test_knit_report(report_type, output_ext)
    }
  }
})

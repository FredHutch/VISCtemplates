test_that("use_slide_deck() creates main slide deck .Rmd file, template.pptx (for branded decks), and a folder README when the specified path does not already exist", {
  temp_dir <- withr::local_tempdir()
  create_visc_project(temp_dir, interactive = FALSE)
  local({
    withr::local_dir(temp_dir)
    deck_name <- "VDCnnn_assay_Slides"
    path <- "slides"
    expect_no_warning(
      use_slide_deck(
        deck_name, path = path, interactive = FALSE
      )
    )
    expect_true(
      file.exists(file.path(path, deck_name, paste0(deck_name, ".Rmd")))
    )
    expect_true(
      # branded decks copy template.pptx alongside the .Rmd so reference_doc
      # resolves with no edits
      file.exists(file.path(path, deck_name, "template.pptx"))
    )
    expect_true(
      # path-level README is created because `path` did not already exist
      file.exists(file.path(path, "README.md"))
    )
  })
})

test_that("use_slide_deck() creates main slide deck .Rmd file even if deck_name doesn't use correct formatting", {
  temp_dir <- withr::local_tempdir()
  create_visc_project(temp_dir, interactive = FALSE)
  local({
    withr::local_dir(temp_dir)
    deck_name <- "NonstandardDeckName"
    expect_no_warning(
      use_slide_deck(
        deck_name, interactive = FALSE
      )
    )
    expect_true(
      file.exists(file.path(deck_name, paste0(deck_name, ".Rmd")))
    )
  })
})

test_that("use_slide_deck() does not create a README if the specified path already exists", {
  temp_dir <- withr::local_tempdir()
  create_visc_project(temp_dir, interactive = FALSE)
  local({
    withr::local_dir(temp_dir)
    path <- "slides"
    dir.create(path)
    deck_name <- "VDCnnn_assay_Slides"
    expect_no_warning(
      use_slide_deck(
        deck_name, path = path, interactive = FALSE
      )
    )
    expect_true(
      file.exists(file.path(path, deck_name, paste0(deck_name, ".Rmd")))
    )
    expect_false(
      # path already existed, so use_slide_deck() should skip README creation
      file.exists(file.path(path, "README.md"))
    )
  })
})

test_that("use_slide_deck() throws error if subdirectory included in deck_name argument", {
  temp_dir <- withr::local_tempdir()
  create_visc_project(temp_dir, interactive = FALSE)
  local({
    withr::local_dir(temp_dir)
    deck_name <- "slides/VDCnnn_assay_Slides"
    expect_error(
      use_slide_deck(
        deck_name, interactive = FALSE
      )
    )
  })
})

# This will test rendering/drafting template slide decks. What happens with
# file snapshots varies a bit depending on the testing context:
#
# When tests are run interactively via devtools::test(), all existing
# snapshots in tests/testthat/_snaps/use_slide_deck in your package source
# repo are deleted (because tests/testthat/setup.R is automatically run
# first) and replaced with new snapshots. You shouldn't notice any changes in
# your git repo because these are already .gitignored and .Rbuildignored.
#
# When tests are run inside R CMD check locally, e.g. via devtools::check(),
# the testing happens from a temporary directory, so any existing files in
# tests/testthat/_snaps/use_slide_deck within your package source tree are
# not changed. Check timestamps if you're confused.
#
# When the tests run on GitHub Actions CI, the snapshot files are uploaded as
# artifacts for online viewing. Currently, if any of the tests fail, the file
# snapshots will be buried within a larger results artifact, but when all
# tests succeed, they will be in a snapshots artifact.
#
# This sets a custom test context(), so should go last in this test file
local({
    test_render_slide_deck()
})

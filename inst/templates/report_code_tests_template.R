# This file contains QC tests for the code underlying {{ report_name }}
# Run all tests by navigating to the 'tests' folder this file is in and running
# testthat::test_file('test_report_code.R')
# Feel free to edit and add tests as appropriate for the given report.

library(spelling)
library(lintr)

lint_printer <- function(lints) {
  for (lint_item in lints) {
    cat(sprintf("Line %d: %s [%s]\n",
                lint_item$line_number,
                lint_item$message,
                lint_item$linter))
  }
}

# read custom wordlist for use in spellcheck
custom_wordlist_path <- file.path("..", "..", "..", "inst", "WORDLIST")
if (file.exists(custom_wordlist_path)) {
  custom_wordlist <- readLines(custom_wordlist_path)
} else {
  custom_wordlist <- character(0)
}

# get path for both the main report Rmd file and any child Rmd documents
report_folder <- file.path("..")
main_rmd_path <- file.path(report_folder, paste0("{{ report_name }}", ".Rmd"))
other_rmd_paths <- list.files(
  path = file.path(report_folder, "child-docs"),
  pattern = "\\.Rmd$",
  full.names = TRUE
)
all_rmd_paths <- c(main_rmd_path, other_rmd_paths)


for (file_path in all_rmd_paths) {

  # warning=F should be used sparingly
  test_that(paste("Checking for warning=F in", file_path), {
    content <- readLines(file_path)
    expect_false(any(grepl("warning\\s*=\\s*F", content)))
  })

  # eval=F should be used sparingly
  test_that(paste("Checking for eval=F in", file_path), {
    content <- readLines(file_path)
    if (file_path == main_rmd_path) {
      # one eval=F expected for loading in data package
      expect_lte(sum(grepl("eval\\s*=\\s*F", content)), 1)
    } else {
      # no eval=F expected in any child Rmd files
      expect_false(any(grepl("eval\\s*=\\s*F", content)))
    }
  })

  test_that(paste("Checking for commented out code in", file_path), {
    commented_code_lints <- lint(file_path, linters = commented_code_linter())
    lint_printer(commented_code_lints)
    expect_length(commented_code_lints, 0)
  })

  test_that(paste("Checking for TODO, FIXME, and similar comments in", file_path), {
    code_debt_lints <- lint(file_path, linters = todo_comment_linter())
    lint_printer(code_debt_lints)
    expect_length(code_debt_lints, 0)
  })

  test_that(paste("Checking spelling in", file_path), {
    spelling_errors <- spell_check_files(file_path, ignore = custom_wordlist, lang = "en_US")
    expect(
      nrow(spelling_errors) == 0,
      failure_message = paste(capture.output(print(spelling_errors)), collapse = "\n")
    )
  })

  test_that(paste("Checking line lengths in", file_path), {
    line_length_lints <- lint(file_path, linters = line_length_linter(length = 100L))
    lint_printer(line_length_lints)
    expect_length(line_length_lints, 0)
  })

  test_that(paste("Checking for non-portable or non-relative file paths in", file_path), {
    file_path_lints <- lint(file_path, linters = list(absolute_path_linter(),
                                                      nonportable_path_linter()))
    lint_printer(file_path_lints)
    expect_length(file_path_lints, 0)
  })

  test_that("Checking object names", {
    object_name_lints <- lint(file_path, linters = list(object_length_linter(),
                                                        object_name_linter(),
                                                        object_overwrite_linter()))
    lint_printer(object_name_lints)
    expect_length(object_name_lints, 0)
  })


}

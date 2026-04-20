# This file contains QC tests for the code underlying {{ report_name }}
# Run all tests by navigating to the 'tests' folder this file is in and running
# testthat::test_file('test_report_code.R')
# Feel free to edit and add tests as appropriate for the given report.

library(lintr)

# Locate the custom WORDLIST using rprojroot so this works regardless of how
# deeply the report folder is nested within the project.
custom_wordlist_path <- tryCatch(
  rprojroot::find_rstudio_root_file("inst", "WORDLIST"),
  error = function(e) NULL
)
custom_wordlist <- if (!is.null(custom_wordlist_path) && file.exists(custom_wordlist_path)) {
  readLines(custom_wordlist_path)
} else {
  character(0)
}

# Paths for the main report Rmd and any child Rmds. list.files() on a
# nonexistent or empty child-docs/ directory quietly returns character(0),
# which is the intended behavior.
main_rmd_path <- file.path("..", "{{ report_name }}.Rmd")
other_rmd_paths <- list.files(
  path = file.path("..", "child-docs"),
  pattern = "\\.Rmd$",
  full.names = TRUE
)
all_rmd_paths <- c(main_rmd_path, other_rmd_paths)

# Helper: format a set of lints as a single string suitable for `info = `
format_lints <- function(lints) {
  paste(capture.output(print(lints)), collapse = "\n")
}


for (file_path in all_rmd_paths) {

  # warning=F should be used sparingly
  test_that(paste("Checking for warning=F in", file_path), {
    skip_if_not(file.exists(file_path), "Rmd not found")
    content <- readLines(file_path)
    expect_false(any(grepl("warning\\s*=\\s*F", content)))
  })

  # eval=F should be used sparingly (one instance allowed in the main Rmd for
  # loading the data package; none expected in child docs).
  test_that(paste("Checking for eval=F in", file_path), {
    skip_if_not(file.exists(file_path), "Rmd not found")
    content <- readLines(file_path)
    eval_f_count <- sum(grepl("eval\\s*=\\s*F", content))
    if (file_path == main_rmd_path) {
      expect_lte(eval_f_count, 1)
    } else {
      expect_equal(eval_f_count, 0)
    }
  })

  test_that(paste("Checking for commented out code in", file_path), {
    skip_if_not(file.exists(file_path), "Rmd not found")
    lints <- lintr::lint(file_path, linters = lintr::commented_code_linter())
    expect_equal(length(lints), 0, info = format_lints(lints))
  })

  test_that(paste("Checking for TODO, FIXME, and similar comments in", file_path), {
    skip_if_not(file.exists(file_path), "Rmd not found")
    lints <- lintr::lint(file_path, linters = lintr::todo_comment_linter())
    expect_equal(length(lints), 0, info = format_lints(lints))
  })

  test_that(paste("Checking for non-portable or non-relative file paths in", file_path), {
    skip_if_not(file.exists(file_path), "Rmd not found")
    # absolute_path_linter() covers the portability case as well, so we don't
    # need nonportable_path_linter() in addition.
    lints <- lintr::lint(file_path, linters = lintr::absolute_path_linter())
    expect_equal(length(lints), 0, info = format_lints(lints))
  })

  # note: spellcheck is also run on the pdf, but checking the code can help
  # pinpoint where the issues are coming from.
  test_that(paste("Checking spelling in", file_path), {
    skip_if_not(file.exists(file_path), "Rmd not found")
    spelling_errors <- spelling::spell_check_files(
      file_path, ignore = custom_wordlist, lang = "en_US"
    )
    expect_equal(
      nrow(spelling_errors), 0,
      info = paste(capture.output(print(spelling_errors)), collapse = "\n")
    )
  })

}

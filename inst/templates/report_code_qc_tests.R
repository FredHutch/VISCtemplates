# This is a template for QC tests run on report code (Rmd files)

library(spelling)
library(lintr)

custom_wordlist <- file.path("..", "..", "inst", "WORDLIST")
if (file.exists(custom_wordlist)) {
  ignore_words <- readLines(custom_wordlist)
} else {
  ignore_words <- character(0)
}

report_folder <- file.path("..", "..", "{{ path }}", "{{ report_name }}")
main_rmd_path <- file.path(report_folder, paste0("{{ report_name }}", ".Rmd"))
other_rmd_paths <- list.files(
  path = file.path(report_folder, "methods"),
  pattern = "\\.Rmd$",
  full.names = TRUE
)
all_rmd_paths <- c(main_rmd_path, other_rmd_paths)


for (file_path in all_rmd_paths) {


  test_that(paste("Checking for warning=F in", file_path), {

    content <- readLines(file_path)
    expect_false(any(grepl("warning\\s*=\\s*F", content)))

  })


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


  test_that(paste("Checking spelling in", file_path), {

    spelling_errors <- spell_check_files(file_path, ignore = ignore_words, lang = "en_US")
    expect(
      nrow(spelling_errors) == 0,
      failure_message = paste(capture.output(print(spelling_errors)), collapse = "\n")
    )

  })


  test_that(paste("Checking for commented out code in", file_path), {

    lints <- lint(file_path, linters = commented_code_linter())
    expect_length(lints, 0)

  })


  test_that(paste("Checking for TODO, FIXME, and similar comments in", file_path), {

    lints <- lint(file_path, linters = todo_comment_linter())
    expect_length(lints, 0)

  })


  test_that(paste("Checking for dplyr pipe use instead of base R pipe in", file_path), {

    lines <- readLines(file_path, warn = FALSE)
    base_pipe_lines <- grep("%>%", lines, value = TRUE)
    expect_length(base_pipe_lines, 0)

  })


  test_that(paste("Checking for use of '<-' instead of '=' for assignment in", file_path), {

    lints <- lint(file_path, linters = assignment_linter())
    expect_length(lints, 0)

  })


  test_that(paste("Checking line lengths in", file_path), {

    lints <- lint(file_path, linters = line_length_linter(length = 80L))
    expect_length(lints, 0)

  })


  test_that(paste("Checking for non-portable or non-relative file paths in", file_path), {

    lints <- lint(file_path, linters = list(absolute_path_linter(),
                                            nonportable_path_linter()))
    expect_length(lints, 0)

  })


  test_that("Library calls are correct and appropriately placed", {

    if (file_path == main_rmd_path) {

      # library calls in main Rmd file are at together at the beginning

      lints <- lint(file_path, linters = list(missing_package_linter(),
                                              unused_import_linter(),
                                              library_call_linter(allow_preamble = TRUE)))
      expect_length(lints, 0)

    }
    else {

      # no library calls in child Rmd files

      library_call_linter_custom <- function(source_file) {
        lints <- list()
        lines <- readLines(source_file)
        for (i in seq_along(lines)) {
          if (grepl("library\\(", lines[i])) {
            lints <- c(lints, Lint(
              filename = source_file,
              line_number = i,
              column_number = 1,
              type = "warning",
              message = "Avoid using library() calls in child Rmd documents.",
              line = lines[i]
            ))
          }
        }
        return(lints)
      }

      lints <- lint(file_path, linters = list(missing_package_linter(),
                                              unused_import_linter(),
                                              library_call_linter_custom()))
      expect_length(lints, 0)

    }

  })


  test_that("Object names are reasonable", {

    lints <- lint(file_path, linters = list(object_length_linter(),
                                            object_name_linter(),
                                            object_overwrite_linter()))
    expect_length(lints, 0)

  })


}


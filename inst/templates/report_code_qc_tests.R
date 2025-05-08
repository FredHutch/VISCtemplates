
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

for (fname in all_rmd_paths) {


  test_that(paste("Checking for warning=F in", fname), {

    content <- readLines(fname)
    expect_false(any(grepl("warning\\s*=\\s*F", content)))

  })


  test_that(paste("Checking for eval=F in", fname), {

    content <- readLines(fname)
    expect_false(any(grepl("eval\\s*=\\s*F", content)))

  })


  test_that(paste("Checking spelling in", fname), {

    spelling_errors <- spell_check_files(fname, ignore = ignore_words, lang = "en_US")
    expect(
      nrow(spelling_errors) == 0,
      failure_message = paste(capture.output(print(spelling_errors)), collapse = "\n")
    )

  })


  test_that(paste("Checking for commented out code in", fname), {

    lints <- lint(fname, linters = commented_code_linter())
    expect_length(lints, 0)

  })


  test_that(paste("Checking for TODO, FIXME, and similar comments in", fname), {

    lints <- lint(fname, linters = todo_comment_linter())
    expect_length(lints, 0)

  })


  test_that(paste("Checking for dplyr pipe use instead of base R pipe in", fname), {

    lines <- readLines(file_path, warn = FALSE)
    base_pipe_lines <- grep("%>%", lines, value = TRUE)
    expect_length(base_pipe_lines, 0)

  })


  test_that(paste("Checking for use of '<-' instead of '=' for assignment in", fname), {

    lints <- lint(fname, linters = assignment_linter())
    expect_length(lints, 0)

  })


  test_that(paste("Checking line lengths in", fname), {

    lints <- lint(fname, linters = line_length_linter())
    expect_length(lints, 0)

  })


  test_that(paste("Checking for non-portable or non-relative file paths in", fname), {

    non_portable_path_linter <- function() {
      regex_linter(
        pattern = "(\\b[A-Z]:/|/Users/|/home/|\\\\)",
        message = "Avoid absolute or non-portable file paths. Use `here::here()` or `file.path()` instead."
      )
    }

    lints <- lint(fname, linters = list(non_portable_path_linter()))
    expect_length(lints, 0)

  })



}


# TODO: functions are organized and well-documented, with explanations of purpose, inputs, and ouput

# TODO: check variable names (within reason)
# Object names are meaningful, descriptive, and use only alphanumeric characters and underscores (no dots)
# Object names are unique (no overwriting of previous variables)
# should be able to use object_name_linter()

# TODO: the most recent releases of VISCfunctions and VISCtemplates are used

# TODO: check for magic numbers and hard-coding

# TODO: Rmd code chunk names are descriptive and use dashes (not underscores or spaces)



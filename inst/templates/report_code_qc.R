
library(spelling)

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


  test_that(paste("Checking spelling in", fname), {

    spelling_errors <- spell_check_files(fname, ignore = ignore_words, lang = "en_US")
    expect(
      nrow(spelling_errors) == 0,
      failure_message = paste(capture.output(print(spelling_errors)), collapse = "\n")
    )

  })


  test_that(paste("Checking for commented out code in", fname), {

    lines <- readLines(fname, warn = FALSE)
    comment_lines <- grep("^\\s*#", lines, value = TRUE)

    # Heuristic: look for common code patterns in comments
    code_patterns <- c("<-", "=", "\\(", "\\)", "\\{", "\\}", "function", "if", "for", "while", "library\\(", "require\\(")
    pattern <- paste(code_patterns, collapse = "|")

    commented_code <- grep(pattern, comment_lines, value = TRUE)

    expect_length(commented_code, 0, info = paste("Commented-out code found:\n", paste(commented_code, collapse = "\n")))

  })


  test_that(paste("Checking for TODO and FIXME in", fname), {

    lines <- readLines(fname, warn = FALSE)
    todo_and_fixme_lines <- grep("TODO|FIXME", lines, ignore.case = TRUE, value = TRUE)
    expect_length(todo_and_fixme_lines, 0)

  })


}


# TODO: functions are organized and well-documented, with explanations of purpose, inputs, and ouput

# TODO: eval = F chunks

# TODO: line lengths
# Strive to limit your code to 80 characters per line (100 max)

# TODO: Use <- not = for assignment

# TODO: Use base R pipe instead of dplyr

# TODO: check variable names (within reason)
# Object names are meaningful, descriptive, and use only alphanumeric characters and underscores (no dots)
# Object names are unique (no overwriting of previous variables)

# TODO: check for non-portable / non-relative file paths

# TODO: the most recent releases of VISCfunctions and VISCtemplates are used

# TODO: check for magic numbers and hard-coding

# TODO: Rmd code chunk names are descriptive and use dashes (not underscores or spaces)



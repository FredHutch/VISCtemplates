

###### setup


library(spelling)
library(pdftools)

custom_wordlist <- file.path("..", "..", "inst", "WORDLIST")
if (file.exists(custom_wordlist)) {
  ignore_words <- readLines(custom_wordlist)
} else {
  ignore_words <- character(0)
}

report_folder <- file.path("..", "..", "{{ path }}", "{{ report_name }}")
main_rmd_path <- file.path(report_folder, paste0("{{ report_name }}", ".Rmd"))
pdf_path <- file.path(report_folder, paste0("{{ report_name }}", ".pdf"))

other_rmd_paths <- list.files(
  path = file.path(report_folder, "methods"),
  pattern = "\\.Rmd$",
  full.names = TRUE
)

all_rmd_paths <- c(main_rmd_path, other_rmd_paths)


###### run tests


test_that("Checking that PDF was generated after last updates to main Rmd file", {

  rmd_datetime <- file.info(main_rmd_path)$mtime
  pdf_datetime <- file.info(pdf_path)$mtime
  expect_lt(rmd_datetime, pdf_datetime)

})


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

}


test_that(paste("Checking spelling in", pdf_path), {

  pdf_text <- pdf_text(pdf_path)
  pdf_text <- pdf_text[3:length(pdf_text)] # skip title page and table of contents
  pdf_text <- pdf_text[c(1:6, 9:length(pdf_text))] # skip lab and data processing methods
  pdf_text <- pdf_text[1:(length(pdf_text) - 1)] # skip references
  pdf_text <- pdf_text[c(1:(length(pdf_text) - 3), length(pdf_text))] # skip reproducibility tables

  spelling_errors_raw <- spell_check_text(pdf_text, ignore = ignore_words, lang = "en_US")$word

  # checking also after collapsing line breaks and hyphens
  text_combined <- paste(pdf_text, collapse = "\n")
  text_cleaned <- gsub("\\s*-\\s*\n\\s*", "", text_combined)
  spelling_errors_cleaned <- spell_check_text(text_cleaned, ignore = ignore_words, lang = "en_US")$word

  # final set of spelling errors: present in both raw and cleaned version
  spelling_errors_final <- spelling_errors_raw[spelling_errors_raw %in% spelling_errors_cleaned]

  expect(
    length(spelling_errors_final) == 0,
    failure_message = paste("Possible spelling errors after rendering to PDF: \n ", paste(spelling_errors_final, collapse = ", "))
  )

})


test_that(paste("Checking", pdf_path, "for broken references"), {

  pdf_text <- pdf_text(pdf_path)
  missing_refs_check <- grepl("\\?\\?", pdf_text)
  expect(
    sum(missing_refs_check) == 0,
    failure_message = paste("Broken references on PDF pages:", paste(which(missing_refs_check), collapse = ", "))
  )

})


test_that(paste("Checking", pdf_path, "for code output (messages, warnings, etc.)"), {

  pdf_text <- pdf_text(pdf_path)
  code_output_check <- grepl("#", pdf_text)
  expect(
    sum(code_output_check) == 0,
    failure_message = paste("Code output found on PDF pages:", paste(which(code_output_check), collapse = ", "))
  )

})


test_that(paste(pdf_path, "has no blank pages"), {

  pdf_text <- pdf_text(pdf_path)
  blank_pages <- which(trimws(pdf_text) == "")
  expect_length(blank_pages, 0)

})


test_that(paste(pdf_path, "has correct page count"), {

  pdf_text <- pdf_text(pdf_path)

  actual_page_count <- length(pdf_text)
  last_page_text <- pdf_text[[actual_page_count]]

  # Use regex to find the largest number near the bottom of the page
  page_number_footer <- stringr::str_extract_all(last_page_text, "Page [0-9]+ of [0-9]+")[[1]]
  last_page_footer_x <- stringr::str_remove_all(stringr::str_remove_all(page_number_footer, "Page "), " of [0-9]+")
  last_page_footer_y <- stringr::str_remove_all(page_number_footer, "Page [0-9]+ of ")

  expect_equal(actual_page_count, as.numeric(last_page_footer_x))
  expect_equal(actual_page_count, as.numeric(last_page_footer_y))

})


for (fname in all_rmd_paths) {

  test_that(paste("Checking for commented out code in", fname), {

    lines <- readLines(fname, warn = FALSE)
    comment_lines <- grep("^\\s*#", lines, value = TRUE)

    # Heuristic: look for common code patterns in comments
    code_patterns <- c("<-", "=", "\\(", "\\)", "\\{", "\\}", "function", "if", "for", "while", "library\\(", "require\\(")
    pattern <- paste(code_patterns, collapse = "|")

    commented_code <- grep(pattern, comment_lines, value = TRUE)

    expect_length(commented_code, 0, info = paste("Commented-out code found:\n", paste(commented_code, collapse = "\n")))

  })

}


# Comments do not include unaddressed debt
for (fname in all_rmd_paths) {

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

# TODO: The correct tense (generally past tense) is used throughout the report

# TODO: report content is not running off the page into the margins

# TODO: checks for figures
# see: https://github.com/FredHutch/VISCtemplates/pull/231/files




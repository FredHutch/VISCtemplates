# This file contains QC tests for the PDF output of {{ report_name }}
# Run all tests by navigating to the 'tests' folder this file is in and running
# testthat::test_file('test_report_pdf.R')
# Feel free to edit and add tests as appropriate for the given report.

library(spelling)
library(pdftools)

# read custom wordlist for use in spellcheck
custom_wordlist_path <- file.path("..", "..", "..", "inst", "WORDLIST")
if (file.exists(custom_wordlist_path)) {
  custom_wordlist <- readLines(custom_wordlist_path)
} else {
  custom_wordlist <- character(0)
}

# read pdf
report_folder <- file.path("..")
pdf_path <- file.path(report_folder, paste0("{{ report_name }}", ".pdf"))
pdf_text <- pdf_text(pdf_path)


test_that(paste("Checking spelling in", pdf_path), {

  n_pages <- length(pdf_text)
  exclude_pages <- c(1, n_pages - 1, n_pages) # exclude cover page, repro. tables, references and acknowledgments
  pdf_text_truncated <- pdf_text[-exclude_pages]

  # Remove URLs from each page
  pdf_text_truncated <- stringr::str_remove_all(pdf_text_truncated, "https?://\\S+")

  spelling_errors_raw <- spell_check_text(pdf_text_truncated, ignore = ignore_words, lang = "en_US")

  # checking also after collapsing line breaks and hyphens
  text_combined <- paste(pdf_text_truncated, collapse = "\n")
  text_cleaned <- gsub("\\s*-\\s*\n\\s*", "", text_combined)
  spelling_errors_cleaned <- spell_check_text(text_cleaned, ignore = ignore_words, lang = "en_US")

  spelling_errors_final <- spelling_errors_raw |>
    filter(word %in% spelling_errors_cleaned$word, nchar(word) > 2)

  expect(
    nrow(spelling_errors_final) == 0,
    failure_message = paste("Possible spelling errors in PDF: \n", paste(spelling_errors_final$word, collapse = "\n "))
  )

})


test_that(paste("Checking", pdf_path, "for broken references"), {

  missing_refs_check <- grepl("\\?\\?", pdf_text)
  expect(
    sum(missing_refs_check) == 0,
    failure_message = paste("Broken references on PDF pages:", paste(which(missing_refs_check), collapse = ", "))
  )

})


test_that(paste("Checking", pdf_path, "for code output (messages, warnings, etc.)"), {

  code_output_check <- grepl("#", pdf_text)
  expect(
    sum(code_output_check) == 0,
    failure_message = paste("Code output found on PDF pages:", paste(which(code_output_check), collapse = ", "))
  )

})


test_that(paste(pdf_path, "has no blank pages"), {

  blank_pages <- which(trimws(pdf_text) == "")
  expect_length(blank_pages, 0)

})


test_that(paste(pdf_path, "has correct page count"), {

  actual_page_count <- length(pdf_text)
  last_page_text <- pdf_text[[actual_page_count]]

  # Use regex to find the largest number near the bottom of the page
  page_number_footer <- stringr::str_extract_all(last_page_text, "Page [0-9]+ of [0-9]+")[[1]]
  last_page_footer_x <- stringr::str_remove_all(stringr::str_remove_all(page_number_footer, "Page "), " of [0-9]+")
  last_page_footer_y <- stringr::str_remove_all(page_number_footer, "Page [0-9]+ of ")

  expect_equal(actual_page_count, as.numeric(last_page_footer_x))
  expect_equal(actual_page_count, as.numeric(last_page_footer_y))

})


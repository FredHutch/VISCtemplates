# This is a template for QC tests run on report outputs (PDF, Word)

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
docx_path <- file.path(report_folder, paste0("{{ report_name }}", ".docx"))

pdf_text <- pdf_text(pdf_path)


test_that("Checking that main Rmd, PDF, and docx are all in sync", {

  rmd_datetime <- file.info(main_rmd_path)$mtime
  pdf_datetime <- file.info(pdf_path)$mtime
  docx_datetime <- file.info(docx_path)$mtime

  first_page_text <- pdf_text[[1]]
  pdf_date_in_document <- stringr::str_extract_all(first_page_text, "Date:\\s+.+\\n")[[1]]
  pdf_date_in_document <- stringr::str_remove_all(pdf_date_in_document, "Date:\\s+")
  pdf_date_in_document <- stringr::str_remove_all(pdf_date_in_document, "\\n")
  pdf_date_in_document <- as.Date.character(pdf_date_in_document, format = "%B %d, %Y")

  expect_lt(rmd_datetime, pdf_datetime)
  expect_lt(pdf_datetime - docx_datetime, as.difftime(0.5, units = "days"))
  expect_equal(pdf_date_in_document, as.Date(pdf_datetime))

})


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


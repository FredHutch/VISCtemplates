# This file contains QC tests for the PDF output of {{ report_name }}
# Run all tests by navigating to the 'tests' folder this file is in and running
# testthat::test_file('test_report_pdf.R')
# Feel free to edit and add tests as appropriate for the given report.

library(spelling)
library(pdftools)

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

pdf_path <- file.path("..", "{{ report_name }}.pdf")

test_that(paste("Checking spelling in", pdf_path), {
  skip_if_not(file.exists(pdf_path), "PDF not yet rendered")
  pdf_pages <- pdftools::pdf_text(pdf_path)
  n_pages <- length(pdf_pages)
  skip_if(n_pages < 3, "PDF too short to exclude cover/reproducibility pages")

  # Exclude cover page plus the reproducibility/references/acknowledgements
  # tail. We find the reproducibility section by header text rather than
  # trusting a fixed page offset, since report length varies.
  repro_page_start <- which(grepl("Reproducibility Software Information", pdf_pages))[1]
  exclude_pages <- if (!is.na(repro_page_start)) {
    unique(c(1, seq.int(from = repro_page_start, to = n_pages)))
  } else {
    # Fallback to the original behavior if the repro header isn't found
    unique(c(1, n_pages - 1, n_pages))
  }
  pdf_text_truncated <- pdf_pages[-exclude_pages]

  # Remove URLs from each page so domain names don't trigger spelling errors
  pdf_text_truncated <- stringr::str_remove_all(pdf_text_truncated, "https?://\\S+")

  spelling_errors_raw <- spell_check_text(
    pdf_text_truncated, ignore = custom_wordlist, lang = "en_US"
  )
  # Re-check after collapsing hyphenated line breaks, so "back-\nground" isn't
  # flagged as two words. Only words that fail BOTH checks are reported.
  text_combined <- paste(pdf_text_truncated, collapse = "\n")
  text_cleaned <- gsub("\\s*-\\s*\n\\s*", "", text_combined)
  spelling_errors_cleaned <- spell_check_text(
    text_cleaned, ignore = custom_wordlist, lang = "en_US"
  )
  spelling_errors_final <- spelling_errors_raw |>
    dplyr::filter(word %in% spelling_errors_cleaned$word, nchar(word) > 2)

  expect_equal(
    nrow(spelling_errors_final), 0,
    info = paste0(
      "Possible spelling errors in PDF:\n  ",
      paste(spelling_errors_final$word, collapse = "\n  ")
    )
  )
})

test_that(paste("Checking", pdf_path, "for broken references"), {
  skip_if_not(file.exists(pdf_path), "PDF not yet rendered")
  pdf_pages <- pdftools::pdf_text(pdf_path)

  missing_refs_check <- grepl("\\?\\?", pdf_pages)
  expect_equal(
    sum(missing_refs_check), 0,
    info = paste(
      "Broken references on PDF pages:",
      paste(which(missing_refs_check), collapse = ", ")
    )
  )
})

test_that(paste("Checking", pdf_path, "for code output (messages, warnings, etc.)"), {
  skip_if_not(file.exists(pdf_path), "PDF not yet rendered")
  pdf_pages <- pdftools::pdf_text(pdf_path)

  # knitr prefixes unsuppressed chunk output with "## " at the start of a line.
  # Look for that specifically rather than any "#", which appears legitimately
  # in prose (hashes, ordinals, etc.).
  code_output_check <- grepl("(^|\\n)##\\s", pdf_pages)
  expect_equal(
    sum(code_output_check), 0,
    info = paste(
      "Code output found on PDF pages:",
      paste(which(code_output_check), collapse = ", ")
    )
  )
})

test_that(paste(pdf_path, "has no blank pages"), {
  skip_if_not(file.exists(pdf_path), "PDF not yet rendered")
  pdf_pages <- pdftools::pdf_text(pdf_path)

  blank_pages <- which(trimws(pdf_pages) == "")
  expect_length(blank_pages, 0)
})

test_that(paste(pdf_path, "has correct page count"), {
  skip_if_not(file.exists(pdf_path), "PDF not yet rendered")
  pdf_pages <- pdftools::pdf_text(pdf_path)

  actual_page_count <- length(pdf_pages)
  last_page_text <- pdf_pages[[actual_page_count]]

  # Extract "Page N of M" from the last page footer using a capture group.
  footer_match <- stringr::str_match(last_page_text, "Page ([0-9]+) of ([0-9]+)")
  skip_if(is.na(footer_match[1, 1]), "No 'Page N of M' footer found on last page")

  current_page <- as.integer(footer_match[1, 2])
  total_pages  <- as.integer(footer_match[1, 3])

  expect_equal(actual_page_count, current_page)
  expect_equal(actual_page_count, total_pages)
})



###### setup


library(spelling)
library(pdftools)

custom_wordlist <- file.path("..", "..", "inst", "WORDLIST")
if (file.exists(custom_wordlist)) {
  ignore_words <- readLines(custom_wordlist)
} else {
  ignore_words <- character(0)
}

report_folder <- file.path("..", "..", "bcell", "Caskey904_920_Bcell_PTreport")
main_rmd_path <- file.path(report_folder, paste0(report_folder, ".Rmd"))
main_pdf_path <- file.path(report_folder, paste0(report_folder, ".pdf"))

child_rmd_paths <- list.files(
  path = file.path(report_folder, "child-docs"),
  pattern = "\\.Rmd$",
  full.names = TRUE
)

all_rmd_paths <- c(main_rmd_path, child_rmd_paths)


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


# TODO: blank page test

# TODO: page number test

# TODO: eval = F chunks
# TODO: commented out code

# TODO: functions are properly documented

# TODO: code follows the style guide

# TODO: no TODO or FIXME

# TODO: other code linting

# save as, for example, tests/testthat/test-spelling.R

library(testthat)
library(spelling)

test_that("All Rmd files are free of spelling errors", {
  # Define the path to the Rmd files
  rmd_files <- list.files(path = ".", pattern = "\\.Rmd$", full.names = TRUE, recursive = TRUE)
  
  # Define custom wordlist
  custom_wordlist <- system.file("templates", WORDLIST, package = "VISCtemplates") # can update to use a project-specific wordlist instead
  if (file.exists(custom_wordlist)) {
    ignore_words <- readLines(custom_wordlist)
  } else {
    ignore_words <- character(0)
  }

  # Perform spell check on each Rmd file
  for (file in rmd_files) {
    spelling_errors <- spell_check_files(file, ignore = ignore_words, lang = "en_US")
    if (length(spelling_errors$word) > 0) {
      error_message <- paste("Spelling errors found in file:", file, "\n", 
                             paste(spelling_errors$word, collapse = ", "))
      fail(error_message)
    }
  }

  expect_true(length(spelling_errors$word) == 0, info = "No spelling errors found in any Rmd files.")
})

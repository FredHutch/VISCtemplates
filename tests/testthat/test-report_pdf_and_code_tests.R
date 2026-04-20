# Meta-tests for the report test templates shipped in inst/templates/.
#
# These verify that the assertions embedded in report_code_tests_template.R and
# report_pdf_tests_template.R actually fire on the defects they're meant to
# catch, and that they pass on clean inputs. Strategy:
#
#   1. Scaffold a minimal VISC project in a tempdir and run
#      use_visc_report_tests() to generate real, placeholder-substituted
#      test_report_code.R and test_report_pdf.R files (the same ones a user
#      would get).
#   2. Write fixture .Rmd files and fixture .pdf files at the paths those
#      generated tests expect (../{{report_name}}.Rmd and .pdf, relative to the
#      tests/ folder).
#   3. Run the generated test file via testthat::test_file() and inspect the
#      result to confirm which assertions fail vs. pass.
#
# PDFs are produced with grDevices::pdf() + text() rather than rendered via
# pandoc/LaTeX, so these tests are fast and need no external toolchain.

# ---- helpers ----------------------------------------------------------------

# Set up a tempdir containing a VISC project plus a report folder with
# generated tests, and return paths needed by individual test cases.
scaffold_report_with_tests <- function(env = parent.frame(),
                                       report_name = "Test001_BAMA_PT_Report",
                                       path = "BAMA") {
  temp_dir <- withr::local_tempdir(.local_envir = env)
  create_visc_project(temp_dir, interactive = FALSE)
  report_dir <- file.path(temp_dir, path, report_name)
  dir.create(report_dir, recursive = TRUE)

  withr::with_dir(temp_dir, {
    use_visc_report_tests(report_name = report_name, path = path)
  })

  list(
    temp_dir    = temp_dir,
    report_dir  = report_dir,
    tests_dir   = file.path(report_dir, "tests"),
    rmd_path    = file.path(report_dir, paste0(report_name, ".Rmd")),
    pdf_path    = file.path(report_dir, paste0(report_name, ".pdf")),
    code_test   = file.path(report_dir, "tests", "test_report_code.R"),
    pdf_test    = file.path(report_dir, "tests", "test_report_pdf.R")
  )
}

# Write a minimal valid Rmd that should pass all code-template tests.
write_clean_rmd <- function(path) {
  writeLines(c(
    "---",
    "title: Clean Report",
    "---",
    "",
    "```{r setup, include=FALSE}",
    "knitr::opts_chunk$set(echo = FALSE)",
    "```",
    "",
    "# Introduction",
    "",
    "This is a short paragraph with correctly spelled words.",
    ""
  ), path)
}

# Write a minimal PDF from a vector of page-text character strings.
# Uses grDevices::pdf() so we don't need pandoc or LaTeX.
write_fixture_pdf <- function(path, pages) {
  grDevices::pdf(path, width = 8.5, height = 11, onefile = TRUE)
  on.exit(grDevices::dev.off())
  for (page_text in pages) {
    graphics::plot.new()
    graphics::par(mar = c(0, 0, 0, 0))
    # split into lines and render top-to-bottom
    lines <- strsplit(page_text, "\n", fixed = TRUE)[[1]]
    if (length(lines) == 0) lines <- ""
    n <- length(lines)
    ys <- seq(0.95, 0.05, length.out = max(n, 1))[seq_len(n)]
    for (i in seq_along(lines)) {
      graphics::text(x = 0.05, y = ys[i], labels = lines[i],
                     adj = c(0, 0.5), cex = 0.9)
    }
  }
}

# Run a generated test file in a clean testthat reporter and return the
# per-test pass/fail summary as a data frame.
run_generated_tests <- function(test_file) {
  # SilentReporter + stop_reporter = FALSE so failing expectations don't
  # propagate out and abort the enclosing test.
  reporter <- testthat::SilentReporter$new()
  withr::with_dir(
    dirname(test_file),
    testthat::test_file(test_file, reporter = reporter, stop_on_failure = FALSE)
  )
  results <- as.data.frame(reporter$get_results())
  # testthat gives us one row per expectation; collapse to one per test_that()
  # block, where "failed" means any expectation in that block failed.
  if (nrow(results) == 0) {
    return(data.frame(test = character(), failed = logical(),
                      stringsAsFactors = FALSE))
  }
  agg <- stats::aggregate(
    failed ~ test,
    data = data.frame(test = results$test, failed = results$failed > 0),
    FUN = any
  )
  agg
}

# Convenience: did any test whose description matches `pattern` fail?
any_matching_test_failed <- function(results, pattern) {
  hits <- results[grepl(pattern, results$test), , drop = FALSE]
  if (nrow(hits) == 0) {
    stop("No generated test matched pattern: ", pattern,
         "\nAvailable tests:\n  ",
         paste(results$test, collapse = "\n  "))
  }
  any(hits$failed)
}


# ---- code template: clean Rmd should pass -----------------------------------

test_that("report_code tests all pass on a clean Rmd", {
  s <- scaffold_report_with_tests()
  write_clean_rmd(s$rmd_path)

  results <- run_generated_tests(s$code_test)
  expect_false(any(results$failed),
               info = paste("Unexpected failures:",
                            paste(results$test[results$failed], collapse = "; ")))
})


# ---- code template: individual defects should each be caught ----------------

test_that("report_code tests flag warning=F", {
  s <- scaffold_report_with_tests()
  write_clean_rmd(s$rmd_path)
  # inject the defect
  content <- readLines(s$rmd_path)
  content <- c(content,
               "```{r bad, warning=F}",
               "1 + 1",
               "```")
  writeLines(content, s$rmd_path)

  results <- run_generated_tests(s$code_test)
  expect_true(any_matching_test_failed(results, "warning=F"))
})

test_that("report_code tests flag excess eval=F in main Rmd", {
  # One eval=F is allowed in the main Rmd (for the data package load). Two
  # should trip the expect_lte(.., 1) assertion.
  s <- scaffold_report_with_tests()
  write_clean_rmd(s$rmd_path)
  content <- readLines(s$rmd_path)
  content <- c(content,
               "```{r load1, eval=F}", "x <- 1", "```",
               "```{r load2, eval=F}", "y <- 2", "```")
  writeLines(content, s$rmd_path)

  results <- run_generated_tests(s$code_test)
  expect_true(any_matching_test_failed(results, "eval=F"))
})

test_that("report_code tests allow a single eval=F in main Rmd", {
  s <- scaffold_report_with_tests()
  write_clean_rmd(s$rmd_path)
  content <- readLines(s$rmd_path)
  content <- c(content,
               "```{r load-data, eval=F}",
               "x <- 1",
               "```")
  writeLines(content, s$rmd_path)

  results <- run_generated_tests(s$code_test)
  expect_false(any_matching_test_failed(results, "eval=F"))
})

test_that("report_code tests flag commented-out code", {
  s <- scaffold_report_with_tests()
  write_clean_rmd(s$rmd_path)
  content <- readLines(s$rmd_path)
  content <- c(content,
               "```{r}",
               "# x <- mean(c(1, 2, 3))",
               "1 + 1",
               "```")
  writeLines(content, s$rmd_path)

  results <- run_generated_tests(s$code_test)
  expect_true(any_matching_test_failed(results, "commented"))
})

test_that("report_code tests flag TODO/FIXME comments", {
  s <- scaffold_report_with_tests()
  write_clean_rmd(s$rmd_path)
  content <- readLines(s$rmd_path)
  content <- c(content,
               "```{r}",
               "# TODO: clean this up before release",
               "1 + 1",
               "```")
  writeLines(content, s$rmd_path)

  results <- run_generated_tests(s$code_test)
  expect_true(any_matching_test_failed(results, "TODO"))
})

test_that("report_code tests flag absolute file paths", {
  s <- scaffold_report_with_tests()
  write_clean_rmd(s$rmd_path)
  content <- readLines(s$rmd_path)
  content <- c(content,
               "```{r}",
               'dat <- read.csv("/Users/someone/data/raw.csv")',
               "```")
  writeLines(content, s$rmd_path)

  results <- run_generated_tests(s$code_test)
  expect_true(any_matching_test_failed(results, "non-portable|non-relative"))
})

test_that("report_code tests flag spelling errors in Rmd", {
  s <- scaffold_report_with_tests()
  writeLines(c(
    "---", "title: Clean Report", "---", "",
    "# Introduction",
    "",
    # two implausible non-words that shouldn't be in any en_US dict or WORDLIST
    "This paragraph contains zqxjklm and flibbertigibbetx as typos.",
    ""
  ), s$rmd_path)

  results <- run_generated_tests(s$code_test)
  expect_true(any_matching_test_failed(results, "spelling"))
})


# ---- pdf template: clean PDF should pass ------------------------------------

# Build a "clean" PDF that satisfies every pdf-template assertion:
#   - page 1 is a cover (excluded from spellcheck)
#   - middle pages have normal prose, no "??", no "## ", not blank
#   - second-to-last page starts the "Reproducibility Software Information"
#     section so the spellcheck-exclusion logic finds it
#   - last page has a correct "Page N of M" footer
make_clean_pdf <- function(path) {
  pages <- c(
    # page 1: cover
    "Cover Page\n\nStudy Title",
    # page 2: content
    paste(
      "Introduction",
      "This study reports on participants and the endpoints of interest.",
      "Results are summarized in the following sections.",
      sep = "\n"
    ),
    # page 3: more content
    paste(
      "Methods",
      "Samples were collected and analyzed using standard procedures.",
      sep = "\n"
    ),
    # page 4: reproducibility section (excluded from spellcheck)
    "Reproducibility Software Information\n\nR version and packages.",
    # page 5: last page with footer
    "References\n\nPage 5 of 5"
  )
  write_fixture_pdf(path, pages)
}

test_that("report_pdf tests all pass on a clean fixture PDF", {
  s <- scaffold_report_with_tests()
  make_clean_pdf(s$pdf_path)

  results <- run_generated_tests(s$pdf_test)
  expect_false(any(results$failed),
               info = paste("Unexpected failures:",
                            paste(results$test[results$failed], collapse = "; ")))
})


# ---- pdf template: individual defects should each be caught -----------------

test_that("report_pdf tests flag broken references (??)", {
  s <- scaffold_report_with_tests()
  pages <- c(
    "Cover Page",
    "See Table ?? for details.",        # broken ref
    "More content.",
    "Reproducibility Software Information",
    "Page 4 of 4"
  )
  write_fixture_pdf(s$pdf_path, pages)

  results <- run_generated_tests(s$pdf_test)
  expect_true(any_matching_test_failed(results, "broken references"))
})

test_that("report_pdf tests flag stray code output (## ...)", {
  s <- scaffold_report_with_tests()
  pages <- c(
    "Cover Page",
    "Introduction text here.\n## [1] 42",  # unsuppressed chunk output
    "More content.",
    "Reproducibility Software Information",
    "Page 4 of 4"
  )
  write_fixture_pdf(s$pdf_path, pages)

  results <- run_generated_tests(s$pdf_test)
  expect_true(any_matching_test_failed(results, "code output"))
})

test_that("report_pdf tests flag blank pages", {
  s <- scaffold_report_with_tests()
  pages <- c(
    "Cover Page",
    "Content on page two.",
    "   ",                               # effectively blank
    "Reproducibility Software Information",
    "Page 5 of 5"
  )
  write_fixture_pdf(s$pdf_path, pages)

  results <- run_generated_tests(s$pdf_test)
  expect_true(any_matching_test_failed(results, "blank pages"))
})

test_that("report_pdf tests flag incorrect page count in footer", {
  s <- scaffold_report_with_tests()
  pages <- c(
    "Cover Page",
    "Content page.",
    "More content.",
    "Reproducibility Software Information",
    "Page 5 of 4"                        # footer claims 4 pages; actual is 5
  )
  write_fixture_pdf(s$pdf_path, pages)

  results <- run_generated_tests(s$pdf_test)
  expect_true(any_matching_test_failed(results, "page count"))
})

test_that("report_pdf tests flag spelling errors in PDF body", {
  s <- scaffold_report_with_tests()
  pages <- c(
    "Cover Page",
    "This paragraph has zqxjklm and flibbertigibbetx in it.",
    "More content.",
    "Reproducibility Software Information",
    "Page 5 of 5"
  )
  write_fixture_pdf(s$pdf_path, pages)

  results <- run_generated_tests(s$pdf_test)
  expect_true(any_matching_test_failed(results, "spelling"))
})

test_that("report_pdf tests ignore spelling errors on the reproducibility page", {
  # The template explicitly excludes pages from the "Reproducibility Software
  # Information" header onward, so typos there shouldn't trip the spellcheck.
  s <- scaffold_report_with_tests()
  pages <- c(
    "Cover Page",
    "Clean body content.",
    "More clean content.",
    "Reproducibility Software Information\nzqxjklm flibbertigibbetx",
    "Page 5 of 5"
  )
  write_fixture_pdf(s$pdf_path, pages)

  results <- run_generated_tests(s$pdf_test)
  expect_false(any_matching_test_failed(results, "spelling"))
})

testthat::test_that("detect_namespaces_in_text and file work", {
  txt <- c(
    "dplyr::filter(x)",
    "VISCfunctions::get_session_info()",
    "somepkg:::hidden()",
    "string with no namespace",
    "also pkg.name::fn()"
  )

  out <- detect_namespaces_in_text(txt)
  expect_true(length(out) == 4)
  expect_true(all(c("dplyr", "VISCfunctions", "somepkg", "pkg.name") %in% out))

  # write to temp file and test file-based function
  tf <- tempfile(fileext = ".Rmd")
  writeLines(txt, tf)
  on.exit(unlink(tf), add = TRUE)
  out2 <- detect_namespaces_in_file(tf)
  expect_true(length(out2) == 4)
  expect_true(all(c("dplyr", "VISCfunctions", "somepkg", "pkg.name") %in% out2))
})

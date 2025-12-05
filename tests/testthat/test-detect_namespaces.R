testthat::test_that("detect_namespaces_in_text works", {
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

})

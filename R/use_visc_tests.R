
use_visc_test_suite <- function() {

  usethis::use_testthat()

  # use custom wordlist

  usethis::use_template(
    template = "report_qc_tests.R",
    save_as = "tests/testthat/report_qc_tests.R",
    data = list(),
    package = "VISCtemplates"
  )

  # setup CI to run
  usethis::use_github_action("check-release")

}

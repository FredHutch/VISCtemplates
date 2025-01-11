
use_visc_spell_check_test <- function() {
  usethis::use_template(
    template = "test-spelling.R",
    save_as = "tests/testthat/test-spelling.R",
    data = list(),
    package = "VISCtemplates"
  )
}

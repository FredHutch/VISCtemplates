#' Add a pull request template to a hidden .github directory
#'
#' @return saves .md template for use on GitHub
#' @export
#'
use_visc_pr_template <- function() {
  # create a hidden directory for templates
  usethis::use_directory(".github")

  usethis::use_template(
    template = "pull_request_template.md",
    save_as = ".github/pull_request_template.md",
    data = list(),
    package = "VISCtemplates"
  )
}

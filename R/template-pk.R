#' Use a Monolix PK Pre-Processing Template
#'
#' @param save_as where to save
#'
#' @export
#'
#' @examples
#' \dontrun{
#' use_monolix_preprocess(save_as = here::here("elisa", "01-preprocess.Rmd"))
#' }
use_monolix_preprocess <- function(save_as = "01-preprocess.Rmd") {
  usethis::use_template(
    template = "monolix-step-01-preprocess.Rmd",
    save_as = save_as,
    package = "VISCtemplates"
  )
}

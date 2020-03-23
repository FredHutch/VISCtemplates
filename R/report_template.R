#' Check for package, install if needed, and load
#'
#' @param packages character vector of package names
#'
#' @return packages will be loaded into environment
#' @export
#'
#' @examples
#' \dontrun{load_install_cran_packages(c("tidyr", "dplyr"))}
install_load_cran_packages <- function(packages) {
  lapply(packages, FUN = function(package) {
    if (!require(package, character.only = TRUE)) {
      if (package %in% c("VISCfunctions", "VISCtemplates")) {
        stop(paste0("The package ", package, " must be installed through GitHub:
                  https://github.com/FredHutch/", package, ".git"))
      } else {
        install.packages(package, repos = "http://cran.us.r-project.org")
      }
    }
    library(package, character.only = TRUE)
  })
}


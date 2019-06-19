
#' Create a VISC project
#'
#' @param path file path
#' @param study_name name of study
#'
#' @return opens a new RStudio session with template project directory
#' @export
create_visc_project <- function(path, study_name){

  # create package
  usethis::create_package(
    path = path
  ) # add check for existing package

  # add .gitignore
  use_visc_gitignore()

  # use readme template
  use_visc_readme(study_name = study_name)

  # add protocol directories
  # use_visc_protocol()

}


use_visc_gitignore <- function() {

  # files that we frequently don't want to track
  usethis::use_git_ignore(
    ignores = c(
      "README.html",
      "~$*.doc*",
      "~$*.xls*",
      "~$*.ppt*",
      "*.xlk",
      ".DS_Store",
      ".DS_Store?",
      "._*",
      ".Spotlight-V100",
      ".Trashes",
      "ehthumbs.db",
      "Thumbs.db",
      # files from Latex
      "*.log",
      "**/figure-latex/*.pdf"
      )
    )

}

use_visc_readme <- function(study_name) {

  usethis::use_template(
    template = "visc-project-readme.Rmd",
    save_as = "README.Rmd",
    data = list(study_name = study_name),
    package = "VISCtemplates"
  )

}

use_visc_protocol <- function() {

  usethis::use_directory("protocol")
  usethis::use_directory("protocol/presentations")

  # use template for background

  # use template for objectives

  # group colors function

  # study schema template
}

rstudio_visc_project <- function(path, ...) {

  dots <- list(...)

  VISCtemplates::create_visc_project(
    path = path,
    study_name = dots[["study_name"]]
  )
}

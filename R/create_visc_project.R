#' Create a VISC project
#'
#' @param path file path
#'
#' @return opens a new RStudio session with template project directory
#' @export
create_visc_project <- function(path){

  # top level folder should follow VDCNNNAnalysis format
  repo_name <- basename(path)

  # get "VDCNNN" if it exists
  # this is a variable that is inserted into templates
  if (grepl("Analysis", repo_name, ignore.case = TRUE)) {
    study_name <- stringr::str_replace(repo_name, pattern = "Analysis", "")
  } else {
    study_name <- repo_name
  }

  # create package
  usethis::create_package(
    path = path
  ) # add check for existing package

  # must set active project otherwise it is <no active project>
  usethis::proj_set(path = path)

  # add .gitignore
  use_visc_gitignore()

  # use readme template
  use_visc_readme(study_name = study_name)

  # add protocol directories and templates
  use_visc_docs(study_name = study_name)

  # add pull request template to hidden folder
  use_visc_pr_template()

  # common scientific words for spell check to remember
  usethis::use_directory("inst")
  usethis::use_template(
    template = "WORDLIST",
    save_as = "inst/WORDLIST",
    package = "VISCtemplates"
  )

}



# Set up project with RStudio GUI ----------------------------------------------

rstudio_visc_project <- function(path, ...) {

  dots <- list(...)

  VISCtemplates::create_visc_project(
    path = path
  )
}

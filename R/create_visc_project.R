#' Create a VISC project
#'
#' Creates a new R project with a VISC analysis project structure.
#'
#' @param path file path
#' @param interactive TRUE by default. FALSE is for non-interactive unit testing
#'   only.
#'
#' @return opens a new RStudio session with template project directory
#' @export
create_visc_project <- function(path, interactive = TRUE){

  challenge_directory(path, interactive)

  # top level folder should follow VDCNNNAnalysis format
  repo_name <- basename(path)
  challenge_visc_name(repo_name, interactive)

  # get "VDCNNN" if it exists
  # this is a variable that is inserted into templates
  if (grepl("Analysis", repo_name, ignore.case = TRUE)) {
    study_name <- stringr::str_replace(repo_name, pattern = "Analysis", "")
  } else {
    study_name <- repo_name
  }

  # suppress usethis output when non-interactive
  old_usethis_quiet <- getOption('usethis.quiet')
  on.exit(options(usethis.quiet = old_usethis_quiet))
  options(usethis.quiet = ! interactive)

  # create package
  usethis::create_package(
    path = path,
    rstudio = TRUE,
    open = interactive,
    # fields override for usethis 3.0.0 ORCID placeholder that errored in R 4.5
    # https://github.com/r-lib/usethis/issues/2059
    fields = list(
      `Authors@R` = paste0(
        "person(\"First\", \"Last\", email = \"first.last",
        "@example.com\", role = c(\"aut\", \"cre\"))"
      )
    )
  )

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

  # save common scientific words for spell check to remember
  usethis::use_directory("inst")
  usethis::use_template(
    template = "WORDLIST",
    save_as = "inst/WORDLIST",
    package = "VISCtemplates"
  )

  # initialize test folder and spelling test
  dir.create('tests/testthat', recursive = TRUE)
  usethis::use_template(
    template = "test-spelling.R",
    save_as = "tests/testthat/test-spelling.R",
    package = "VISCtemplates"
  )
  
}
}


challenge_directory <- function(path, interactive = TRUE) {

  path <- fs::path_expand(path)

  dir_exists <- dir.exists(path)

  if (dir_exists && interactive) {

    continue <- usethis::ui_yeah("
      The directory {path} already exists.
      Would you like to continue?")

    if (!continue) {
      usethis::ui_stop("Stopping `create_visc_project()`")
    } else if (continue) {
      usethis::ui_warn("
        Creating new VISC project in {path}, which already exists.
        Be sure to check the directory for unexpected files.")
    }
  }
}


challenge_visc_name <- function(repo_name, interactive = TRUE) {
  if (! interactive) return(invisible(NULL))

  continue <- usethis::ui_yeah("
    Creating a new VISC project called {repo_name}.
    At VISC, we use a naming convention for analysis projects, VDCnnnAnalysis,
    where 'VDC' is the CAVD PI name, and 'nnn' is the CAVD project number.
    Would you like to continue?")

  if (!continue) {
    usethis::ui_stop("Stopping `create_visc_project()`")
    }
}

# Set up project with RStudio GUI ----------------------------------------------

rstudio_visc_project <- function(path, ...) {

  dots <- list(...)

  VISCtemplates::create_visc_project(
    path = path
  )
}

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
    open = interactive
  )

  # must set active project otherwise it is <no active project>
  usethis::proj_set(path = path)

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

  # git and .gitignore
  use_visc_gitignore()
  usethis::use_git()

  # set up unit tests and continuous integration
  usethis::use_testthat()
  # usethis::use_github_action("check-release")

}


#' Use a VISC README template for the project
#'
#' @param study_name name of study in VDCNNN format
#' @param save_as where to save README.Rmd. Defaults to top-level.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' use_visc_readme("Gallo477")
#' }
use_visc_readme <- function(study_name, save_as = "README.Rmd") {
  usethis::use_template(
    template = "visc-project-readme.Rmd",
    save_as = save_as,
    data = list(study_name = study_name),
    package = "VISCtemplates"
  )
  # knit the md from the Rmd on request of SRA team
  rmarkdown::render(
    usethis::proj_path('README.Rmd'),
    quiet = TRUE
  )
  # remove Rmd at request of SRA team; they just manually edit the *.md
  # so the Rmd file merely clutters their working directory
  unlink(
    usethis::proj_path(
      paste0(
        'README',
        c('.Rmd', '.html')
      )
    )
  )
}


#' Create a VISC docs directory with template files
#'
#' Creates the docs/ directory and presentations/ directory with templates
#' for the project background, objectives, group colors, study schema, and
#' project-level bib file.
#'
#' @param study_name name of study in VDCNNN format
#'
#' @export
#'
#' @examples
#' \dontrun{
#' use_visc_docs("Gallo477")
#' }
use_visc_docs <- function(study_name) {

  usethis::use_directory("docs")
  usethis::use_directory("docs/presentations")

  # use template for background
  use_project_background(study_name)

  # use template for objectives
  use_project_objectives(study_name)

  # group colors template code
  use_colors_and_shapes(study_name)

  # study schema template
  use_study_schema(study_name)

  # project-level bib file
  use_bib(study_name)
}


#################################################

# Utility functions for creating a VISC project

################################################


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


# Set up project with RStudio GUI
rstudio_visc_project <- function(path, ...) {

  dots <- list(...)

  VISCtemplates::create_visc_project(
    path = path
  )
}


use_project_background <- function(study_name) {
  usethis::use_template(
    template = "visc-project-background.Rmd",
    save_as = "docs/background.Rmd",
    data = list(study_name = study_name),
    package = "VISCtemplates"
  )
}

use_project_objectives <- function(study_name) {
  usethis::use_template(
    template = "visc-project-objectives.Rmd",
    save_as = "docs/objectives.Rmd",
    data = list(study_name = study_name),
    package = "VISCtemplates"
  )
}

use_colors_and_shapes <- function(study_name) {
  usethis::use_template(
    template = "visc-project-colors-and-shapes.R",
    save_as = "R/colors-and-shapes.R",
    data = list(study_name = study_name),
    package = "VISCtemplates"
  )
}

use_study_schema <- function(study_name) {
  usethis::use_template(
    template = "visc-project-study-schema.R",
    save_as = "R/study_schema.R",
    data = list(study_name = study_name),
    package = "VISCtemplates"
  )
}

use_bib <- function(study_name) {
  usethis::use_template(
    template = "visc-project-bibliography.bib",
    save_as = "docs/bibliography.bib",
    data = list(study_name = study_name),
    package = "VISCtemplates"
  )
}

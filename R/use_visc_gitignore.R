#' Add to .gitignore file
#'
#' Adds common files that are ignored in VISC statistical reports.
#'
#' @export
#'
#' @param directory Directory relative to active project to set ignores.
#' Defaults to current project directory.
#'
#' @examples
#' \dontrun{
#' use_visc_gitignore()
#' }
use_visc_gitignore <- function(directory = ".") {

  # files that we frequently don't want to track
  usethis::use_git_ignore(
    ignores = c(
      # Default RStudio entries
      ".Rproj.user",
      ".Rhistory",
      ".RData",
      ".Ruserdata",
      # VISCtemplates specific entries
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
      "*.aux",
      "*.toc",
      "*.lof",
      "*.lot",
      "*.out",
      "**/figure-latex/*.pdf",
      "**/figure-docx/*.pdf",
      "*.zip",
      "data-raw/*.html",
      # cache files
      "*_cache/",
      # other
      ".smbdelete*"
    ),
    directory = directory
  )

}

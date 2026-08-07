#' Use a Slide Deck Template
#'
#' Creates a template R Markdown file for a slide presentation (PPTX/PDF),
#' based on the layout in `slides_template.Rmd`.
#'
#' @param deck_name name of the file/folder (character, no extension, no subdirectory)
#' @param path folder within the active project where the deck should be created
#' @param interactive TRUE by default; FALSE for non-interactive unit testing only
#'
#' @export
#'
#' @examples
#' \dontrun{
#' use_slide_deck(
#'   deck_name = "McElrath708_TeamMeeting_Slides",
#'   path = "slides"
#' )
#' }
use_slide_deck <- function(deck_name = "VDCnnn_assay_slides",
                           path = ".",
                           interactive = TRUE) {
  if (dirname(deck_name) != ".") {
    stop("deck_name cannot include a subdirectory; use the path argument instead.")
  }

  old <- options(usethis.quiet = !interactive)
  on.exit(options(old))

  if (!dir.exists(path)) {
    dir.create(path, recursive = TRUE)
    usethis::use_template(
      template = "README_slides_folder.md",
      data = list(deck_name = deck_name),
      save_as = file.path(path, "README.md"),
      package = "yourPackage"   # <- replace with your package name
    )
  }

  # rmarkdown::draft() copies the whole skeleton/ folder for this template
  # (including template.pptx for "branded"), so reference_doc just works.
  rmarkdown::draft(
    file = file.path(path, deck_name),
    template = system.file("templates", "slides", "slides_template.Rmd", package = "VISCtemplates"),

    edit = FALSE
  )

  usethis::ui_done(glue::glue("Created slide deck at '{file.path(path, deck_name)}'"))
}

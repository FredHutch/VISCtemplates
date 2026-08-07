#' Use a Slide Deck
#'
#' Creates a template R Markdown file for a slide presentation (PPTX)
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
#'   deck_name = "VDCnnn_Assay_Slides",
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

  # create subdirectory, if doesn't yet exist
  if (!dir.exists(path)) {
    dir.create(path, recursive = TRUE)
  }

  # note: rmarkdown::draft() copies the whole skeleton/ folder for this template
  rmarkdown::draft(
    file = file.path(path, deck_name),
    template = system.file("templates", "slides", package = "VISCtemplates"),
    edit = FALSE
  )

  usethis::ui_done(glue::glue("Created slide deck at '{file.path(path, deck_name)}'"))
}

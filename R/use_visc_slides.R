#' Use a Slide Deck Template
#'
#' This function creates a template R Markdown file for a slide presentation
#' (rendering to PPTX and/or PDF), based on the custom slide layout defined
#' in `slides_template.Rmd`. When `deck_type = "branded"`, the accompanying
#' `template.pptx` reference document is copied alongside the new .Rmd so the
#' `reference_doc:` path in the YAML resolves without edits.
#'
#' @param deck_name name of the file/folder (character, no extension, no
#'   subdirectory)
#' @param path path of the folder within the active project where the deck
#'   should be created
#' @param deck_type "empty" (no reference_doc, PowerPoint default theme) or
#'   "branded" (ships with `template.pptx` already wired into the YAML)
#' @param interactive TRUE by default. FALSE is for non-interactive unit
#'   testing only.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' use_slide_deck(
#'   deck_name = "McElrath708_TeamMeeting_Slides",
#'   path = "slides",
#'   deck_type = "branded"
#' )
#' }
use_slide_deck <- function(deck_name = "VDCnnn_assay_slides",
                           path = ".",
                           deck_type = c("empty", "branded"),
                           interactive = TRUE) {
  deck_type <- match.arg(deck_type)

  if (dirname(deck_name) != ".") {
    stop("deck_name cannot include a subdirectory. you can instead specify a subdirectory using the path argument of use_slide_deck().")
  }

  # suppress usethis output when non-interactive
  old_usethis_quiet <- getOption("usethis.quiet")
  on.exit(options(usethis.quiet = old_usethis_quiet))
  options(usethis.quiet = !interactive)

  challenge_slide_deck(deck_name, path, interactive)

  # create parent folder (specified in path) and readme, if they don't yet exist
  if (!dir.exists(path)) {
    dir.create(path, recursive = TRUE)
    usethis::use_template(
      template = "README_slides_folder.md",
      data = list(deck_name = deck_name),
      save_as = file.path(path, "README.md"),
      package = "yourPackage"   # <- replace with your package name
    )
  }

  # rmarkdown::draft() copies the *entire* skeleton/ folder registered for
  # this template -- including skeleton.Rmd (renamed to <deck_name>.Rmd) and,
  # for the "branded" template, template.pptx -- so the reference_doc lands
  # right next to the new .Rmd with no manual copying required.
  rmarkdown_template <- paste0("slide_deck_", deck_type)

  rmarkdown::draft(
    file = file.path(path, deck_name),
    template = system.file(
      "rmarkdown", "templates", rmarkdown_template,
      package = "yourPackage"   # <- replace with your package name
    ),
    edit = FALSE
  )

  usethis::ui_done(
    glue::glue("Created {deck_type} slide deck at '{file.path(path, deck_name)}'")
  )
}

#' Confirm overwrite of an existing slide deck
#'
#' Small helper mirroring the "challenge" pattern from use_visc_report():
#' warns / asks for confirmation if the target file or folder already exists.
#'
#' @param deck_name name of the file/folder to be created
#' @param path path of the parent folder
#' @param interactive whether to prompt the user (FALSE for automated tests)
#' @keywords internal
challenge_slide_deck <- function(deck_name, path, interactive) {
  target <- file.path(path, deck_name)
  if (dir.exists(target) || file.exists(paste0(target, ".Rmd"))) {
    if (interactive) {
      proceed <- usethis::ui_yeah(
        glue::glue("'{target}' already exists. Overwrite it?")
      )
      if (!proceed) usethis::ui_stop("Aborting: deck not created.")
    } else {
      stop(glue::glue("'{target}' already exists."))
    }
  }
  invisible(TRUE)
}

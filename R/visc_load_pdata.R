#' @title Load a VISC pdata object and check data hash
#' @description Allows for loading a pdata object either from active project
#'   repo (e.g., during review) or from the library installed location. This
#'   facilitates task switching when transitioning from ad hoc review to
#'   production reporting.
#' @param .data pdata as name or character, e.g., PKGNAME_ASSAY or
#'   "PKGNAME_ASSAY"
#' @param proj_or_datapackage whether to load the data from an installed
#'   datapackage (`datapackage`, the default) or the current project repo
#'   (`proj` or `repo`)
#' @param criteria NULL (default) or a character string containing exactly 32
#'   lowercase hexadecimal characters: the expected hash of the loaded R
#'   object, computed with [digest::digest()]. Not a package version or file hash.
#' @param package only used in `datapackage` mode. NULL (default; standard VISC
#'   pdata naming) or character. If NULL, look for pdata named `.data` in
#'   package <portion of `.data` before the first underscore>. If not NULL, look
#'   for pdata named `.data` in package `package`.
#' @param lib.loc library path(s) to search in `datapackage` mode. Passed to
#'   package lookup and [utils::data()]. NULL uses the default library search
#'   locations; supply an explicit path to select a designated data library.
#' @details
#' A valid supplied hash is checked in both installed-datapackage and
#' project/repository modes. If `criteria` is NULL, a warning is issued and the
#' data are returned without checking. A malformed hash also causes a warning
#' and skips checking; it does not stop loading. A valid hash that does not match
#' the loaded object causes an error. A match returns the object.
#'
#' Establish the expected hash from an independently verified data object and
#' record it in the analysis. Do not recompute the expected hash from newly
#' loaded data on every report run: that would not detect an unexpected change.
#' The hash identifies the R object under the digest settings used, not the
#' datapackage version or the bytes of its source file.
#' @return pdata object
#' @examples
#' \dontrun{
#' # Requires an installed study datapackage. Missing criteria warns and skips checking.
#' pdata <- visc_load_pdata("Hassell750_ics")
#'
#' # After independently verifying this data version, obtain and record its hash:
#' digest::digest(pdata)
#'
#' # Illustrative valid syntax only; replace with the recorded, verified hash.
#' expected_hash <- "0123456789abcdef0123456789abcdef"
#' visc_load_pdata("Hassell750_ics", criteria = expected_hash)
#'
#' # In the active data-package source repository, the same validation applies:
#' visc_load_pdata("Hassell750_ics", proj_or_datapackage = "proj",
#'   criteria = expected_hash)
#' }
#' @export
visc_load_pdata <- function(.data,
                            proj_or_datapackage = c("datapackage", "proj", "repo"),
                            criteria = NULL,
                            package = NULL,
                            lib.loc = NULL){
  proj_or_datapackage <- match.arg(proj_or_datapackage)

  # switch for pdata given as name or character
  pdata_name <- if (is.name(substitute(.data))){
    deparse(substitute(.data))
  } else if (is.character(.data)){
    .data
  } else stop('`.data` must be an unquoted name or a character string')

  # data() loads pdata into this environment before returning
  pdata_env <- new.env(parent = emptyenv())

  # switch for proj/repo mode vs. installed datapackage mode
  if(proj_or_datapackage %in% c("proj", "repo")){
    # project / source repo mode
    message("Loading ", pdata_name, " from current project/repo")
    dp <- rprojroot::find_package_root_file("data", paste0(pdata_name, ".rda"))
    load(dp, envir = pdata_env)
    message("Found file ", dp)
  } else {
    # installed datapackage mode

    # switch for standard/non-standard pdata naming
    if (is.null(package)){
      pkg_name <- strsplit(pdata_name, "_")[[1]][1]
    } else {
      pkg_name <- package
    }

    # check package is installed
    if (! pkg_name %in% .packages(all.available = TRUE, lib.loc = lib.loc)){
      stop(paste0("Data package '", pkg_name, "' is not installed"))
    }
    message(
      sprintf(
        'Loading %s from installed datapackage\nFound library %s',
        pdata_name,
        find.package(pkg_name, lib.loc = lib.loc)
      )
    )
    withr::with_options(
      # create error from warning if pdata_name doesn't exist in package
      list(warn = 2),
      # load pdata_name from data package
      utils::data(
        list = pdata_name,
        package = pkg_name,
        envir = pdata_env,
        lib.loc = lib.loc
      )
    )
  }

  # check R object name same as pdata file name
  if (! exists(pdata_name, pdata_env)){
    stop(
      sprintf(
        "Data file `%s` exists but does not contain an R object named `%s`",
        pdata_name,
        pdata_name
      )
    )
  }

  # extract pdata from temporary environment
  pdata <- get(pdata_name, envir = pdata_env)

  # if criteria missing, skip check. Warn, but return pdata anyway
  if (is.null(criteria)) {
    warning("No criteria provided. Ignoring data check")
    return(pdata)
  }

  # if criteria not a valid hash, skip check. Warn, but return pdata anyway
  if (! grepl("^[0-9a-f]{32}$", criteria)) {
    warning("Ignoring criteria check. Incorrect criteria syntax provided.")
    return(pdata)
  }

  # return pdata if hash check is successful
  pdata_digest <- digest::digest(pdata)
  if (!identical(pdata_digest, criteria)) {
    stop(
      sprintf(
        "Data hash mismatch: expected %s, got %s",
        criteria,
        pdata_digest
      ),
      call. = FALSE
    )
  }
  message("Data hash ", criteria, " matches!")
  return(pdata)
}

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
#' @param criteria character, a 32-digit hexadecimal data hash with lowercase
#'   letters
#' @param package only used in `datapackage` mode. NULL (default; standard VISC
#'   pdata naming) or character. If NULL, look for pdata named `.data` in
#'   package <portion of `.data` before the first underscore>. If not NULL, look
#'   for pdata named `.data` in package `package`.
#' @param lib.loc library path from which to load the data package. Passed
#'   internally to `utils::data()`. Default is `NULL`, which uses the first
#'   element of `.libPaths()`
#' @return pdata object
#' @examples
#' \dontrun{
#' # default behavior: loads a pdata from the currently installed package, no criteria checking
#' visc_load_pdata(Hassell750_ics)
#'
#' ## add a check against hash
#' visc_load_pdata(Hassell750_ics, criteria = "4f054442a6549bffcd947af4b0da9155")
#'
#' # load a pdata from the active project repo, not installed
#' visc_load_pdata(Hassell750_ics, proj_or_datapackage = "proj")
#'
#' ## add check against hash
#' visc_load_pdata(Hassell750_ics, proj_or_datapackage = "proj",
#'   criteria = "09ab8a5a3831e854d21144d89557ccb1")
#' ## skips criteria check if looking at datapackage
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
    load(rprojroot::find_package_root_file("data", paste0(pdata_name, ".rda")),
         envir = pdata_env)
  } else {
    # installed datapackage mode

    # switch for standard/non-standard pdata naming
    if (is.null(package)){
      pkg_name <- strsplit(pdata_name, "_")[[1]][1]
    } else {
      pkg_name <- package
    }

    # check package is installed
    if (! pkg_name %in% rownames(utils::installed.packages(lib.loc = lib.loc))){
      stop(paste0("Data package '", pkg_name, "' is not installed"))
    }
    message(
      sprintf(
        'Loading pdata from installed datapackage %s in library %s',
        pkg_name,
        dirname(find.package(pkg_name, lib.loc = lib.loc))
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
  message("Loading ", pdata_name, " from ", proj_or_datapackage)
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
  testthat::expect_equal(pdata_digest, criteria)
  message("Hash: ", criteria, " matches!")
  return(pdata)
}

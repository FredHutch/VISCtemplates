#' @title Load a VISC pdata object and check data hash
#' @description Allows for loading a pdata object either from active project
#'   repo (during review) or from the library installed location. This
#'   facilitates task switching when transitioning from ad hoc review to
#'   production reporting.
#' @param .data pdata as name or character, e.g., PKGNAME_ASSAY or "PKGNAME_ASSAY"
#' @param proj_or_datapackage whether to load the data from the current project
#'   repo or an installed datapackage
#' @param criteria character, a 32-digit hexadecimal data hash with lowercase letters
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
                            proj_or_datapackage = "datapackage",
                            criteria = NULL){
  pdata_name <- if (is.name(substitute(.data))){
    deparse(substitute(.data))
  } else if (is.character(.data)){
    .data
  } else stop('`.data` must be an unquoted name or a character string')

  pkg_name <- strsplit(pdata_name, "_")[[1]][1]

  # r/o picnic
  if (is.null(criteria)) {
    warning("No criteria provided. Ignoring data check")
  } else if (!grepl("^[0-9a-f]{32}$", criteria)) {
    warning("Ignoring criteria check. Incorrect criteria syntax provided.")
    criteria <- NULL
  }

  pdata_env <- new.env(parent = emptyenv())
  if(tolower(proj_or_datapackage) %in% c("proj", "repo")){
    # data package project / source folder method
    load(DataPackageR::project_data_path(paste0(pdata_name, ".rda")),
         envir = pdata_env)

  } else {
    # installed datapackage method
    if (! pkg_name %in% rownames(utils::installed.packages())){
      stop(paste0("Data package '", pkg_name, "' is not installed"))
    }
    utils::data(list = pdata_name, package = pkg_name, envir = pdata_env)
    if (! exists(pdata_name, pdata_env)){
      stop(
        sprintf(
          "Unable to find data object '%s' in package '%s'",
          pdata_name,
          pkg_name
        )
      )
    }
  }

  message("Loading ", pdata_name, " from ", proj_or_datapackage)
  pdata <- get(pdata_name, envir = pdata_env)

  if(! is.null(criteria)){
    pdata_digest <- digest::digest(pdata)
    testthat::expect_equal(pdata_digest, criteria)
    message("Hash: ", criteria, " matches!")
  }

  return(pdata)

}

#' @title Load a VISC pdata object and check version by datapackage or hash
#' @description Allows for loading a pdata object either from active project
#'   repo (during review) or from the libarary installed location. This
#'   facilitates task switching when transitioning from adhoc review to
#'   production reporting.
#' @param .data pdata name e.g. PKGNAME_ASSAY
#' @param proj_or_datapackage whether to load the data from the current project
#'   repo or an installed datapackage
#' @param criteria 32 digit hash or data package version 0.1.X.
#' @return pdata object
#' @examples
#' \dontrun{
#' # default behavior: loads a pdata from the currently installed package, no criteria checking
#' visc_load_pdata(Hassell750_ics)
#'
#' ## add a check against hash
#' visc_load_pdata(Hassell750_ics, criteria = "4f054442a6549bffcd947af4b0da9155")
#' ## add a check against dataversion
#' visc_load_pdata(Hassell750_ics, criteria = "0.1.68")
#'
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

  pdata_name <- deparse(substitute(.data))
  pkg_name <- stringr::str_split(pdata_name, pattern = "_")[[1]][1]

  # r/o picnic
  if (is.null(criteria)) {
    warning("No criteria provided. Ignoring data check")
  } else if(tolower(proj_or_datapackage) %in% c("proj", "repo") &&
            grepl(pattern = "0\\.1\\.\\d{1,2}", criteria)){
    warning("Ignoring criteria check. Criteria is from data version but source is repo.",
            "Did you mean to use the hash criteria?")
    criteria <- NULL
  } else if (nchar(criteria) != 32 &
             !grepl(pattern = "0\\.1\\.\\d{1,2}", criteria)) {
    warning("Ignoring criteria check. Incorrect criteria syntax provided.")
    criteria <- NULL

  }

  pdata_env <- new.env()
  if(tolower(proj_or_datapackage) %in% c("proj", "repo")){
    # data package project / source folder method
    load(DataPackageR::project_data_path(paste0(pdata_name, ".rda")),
         envir = pdata_env)

  } else {
    # installed datapackage method
    if (! pkg_name %in% rownames(utils::installed.packages())){
      stop(paste0("Data package '", pkg_name, "' is not installed"))
    }
    rda <- system.file(file.path('data', paste0(pdata_name, ".rda")),
                       package = pkg_name)
    lz_rd <- system.file(file.path('data', 'Rdata'), package = pkg_name)
    lzd <- utils::packageDescription(pkg_name)$LazyData
    if (nzchar(rda) && file.exists(rda)) {
      # single rda file for data object in data/
      load(system.file(file.path('data', paste0(pdata_name, ".rda")),
        package = pkg_name), envir = pdata_env)
    } else if (nzchar(lz_rd) && file.exists(lz_rd) &&
                 !is.null(lzd) && tolower(lzd) == 'true'){
      # undocumented import method from legacy code. Ever needed? Untested.
      lazyLoad(filebase = system.file(file.path('data', 'Rdata'),
                 package = pkg_name), envir = pdata_env)
    } else {
      stop(
        sprintf(
          "Unable to find data object '%s' in package '%s'",
          pdata_name,
          pkg_name
        )
      )
    }
  }


  pdata <- get(pdata_name, envir = pdata_env)
  message("Loading ", pdata_name, " from ", proj_or_datapackage)

  if(!is.null(criteria)){
    if(nchar(criteria) == 32){
      pdata_digest <- digest::digest(pdata)
      testthat::expect_equal(pdata_digest,
                             criteria)
      message("Hash: ", criteria, " matches!")
    } else {
      DataPackageR::assert_data_version(pkg_name, version_string = criteria)
      message("Asserted data version: ", criteria)
    }
  }

  return(pdata)

}

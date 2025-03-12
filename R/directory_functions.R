#' Declare Directories to Load in for Unix/Mac versus Windows Operating System
#'
#' @param folder string for either networks or trials. defaults to networks
#' @param alt_root string alternative root to find networks or trials file location.
#' @param alt_folder string alternative folder mapping to find networks or trials file location.
#' @param force_windows_path string forces a windows path
#'
#' @returns defaults to "networks" path based on OS.
#' @export
#'
#' @examples install_git(file.path(get_server_path(),'cavd', 'Studies', 'cvdNNN', 'pdata', 'VDCNNN.git'))
get_server_path <- function(folder = c("networks", "trials"),
                             alt_root = "",
                             alt_folder = "",
                             force_windows_path){

  # stop and return message if more than one are declared as TRUE
  folder <- match.arg(folder)

  stopifnot(is.character(alt_folder))

  os <- get_os()

  if (os == "windows") {
    if (!missing(force_windows_path)) {
      return(force_windows_path)
    }
    # windows is mapped to N or T
    return(switch(folder,
           "networks" = "N:/",
           "trials" = "T:/"
           ))
  }

  root <- get_root(os)

  test_dir <- file.path(root, folder)

  if (dir.exists(test_dir)) {
    return(test_dir)
  }

  # check all combinations of root and alt_root with folder and alt_folder
  dir_exist <- .try_paths(c(root, alt_root), c(folder, alt_folder))

  if (length(dir_exist) > 1) {
    return(dir_exist)
  } else {
    warning("Multiple possible file paths were found. Returning the first one.")
    return(dir_exist[1])
  }

}


#' Get operating system
#'
#' @returns one of "linux" "windows" or "osx"
#' @export
#'
#' Replaces .Platform$OS.type which only return "windows" or "unix".
# '
#'
#' @examples get_os()
get_os <- function(){
  sysinf <- Sys.info()
  if (!is.null(sysinf)) {
    os <- sysinf['sysname']
    if (os == 'Darwin')
      os <- "osx"
  } else {
    os <- .Platform$OS.type
    if (grepl("^darwin", R.version$os))
      os <- "osx"
    if (grepl("linux-gnu", R.version$os))
      os <- "linux"
  }
  unname(tolower(os))
}

#' Get root path based on operating system
#'
#' @param os can use get_os() to return one of "linux", "osx" or "windows" to return relevant root path
#'
#' @returns string for root path to try based on operating system
#' @export
#'
#' @examples get_root(get_os())
get_root <- function(os) {

  stopifnot(is.character(os))

  switch(os,
         "linux" = "/",
         "osx" = "/Volumes/",
          "" #no root for windows or other
         )
}

#' Try different combinations of roots and folders for directories that exist
#'
#' @param root root to check. joined to path options.
#' @param path path to check. joined to root options.
#'
#' Used in get_server_path() to check all combos of alt_root and alt_path.
#'
#' @returns vector of root path combinations that exist or if none exist, exists with stop message
#' @export
#'
#' @examples .try_paths("N:/", "folder_location")
.try_paths <- function(root, path){
  all <- expand.grid(root, path) #get all combos of root and path

  try_paths <- unique(file.path(all[,1], all[,2])) #create file.path list

  # create vector of booleans for which directories exist in try_path
  check_paths <- unlist(lapply(try_paths, dir.exists))
  if (!any(check_paths)) stop("no directories found, try changing alt_root or alt_path")

  try_paths[check_paths]
}

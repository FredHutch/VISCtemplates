
#' Declare Directories to Load in for Unix/Mac versus Windows Operating System
#'
#' @param trials boolean. FALSE by default. if set to TRUE will return variable trials_directory.
#' only one of trials or networks should be TRUE.
#' @param networks boolean. FALSE by default. if set to TRUE will return variable network_directory.
#' only one of trials or networks should be TRUE.
#'
#' @returns returns network_directory or trials_directory. returns error if both are set to TRUE.
#' returns nothing if both are set to FALSE or default to FALSE
#' @export
#'
#' @examples
#' t_dir <- declare_directories(folder = "trials")
#' CVDXX_adata <-  read_csv(file.path(t_dir, folder_location, "DATE_adata.csv")
#'  or
# remotes::install_git(file.path(declare_directories(folder = "networks"),
#                                'cavd', 'Studies', 'cvdNNN', 'pdata', 'VDCNNN.git'),
#                      ref = 'main', # may need to change this to a different branch/tag/SHA to reproduce a specific analysis - see reproducibility tables in previous reports if appropriate
#                      git = 'external',
#                      lib = my_data_package_lib)
declare_directories <- function(folder = c("networks", "trials"),
                                alt_folder = "",
                                alt_root = ""){

  # stop and return message if more than one are declared as TRUE
  folder = match.arg(folder)

  stopifnot(is.character(alt_paths))

  os <- get_os

  if (os == "windows") {
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
  .try_paths(c(root, alt_root), c(folder, alt_folder))

}


#' Get operating system
#'
#' @returns one of "linux" "windows" or "osx"
#' @export
#'
#' Replaces .Platform$OS.type which only return "windows" or "unix".
# '
#'
#' @examples
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
  tolower(os)
}

#' Get root path based on operating system
#'
#' @param os can use get_os to return one of "linux", "osx" or "windows" to return relevant root path
#'
#' @returns
#' @export
#'
#' @examples
get_root <- function(os) {
  switch(os,
         "linux" = "/",
         "osx" = "/Volumes/",
          "" #no root for windows or other
         )
}

#' Try different combinations of roots and folders for directories that exist
#'
#' @param root root path to check
#' @param folder
#'
#' Used in declare_directories() to check all combos of alt_root and alt_path.
#'
#' @returns
#' @export
#'
#' @examples
.try_paths <- function(root, path){
  all <- expand.grid(root, path) #get all combos of root and path

  try_paths <- unique(file.path(all[,1], all[,2])) #create file.path list

  check_paths <- unlist(lapply(try_paths, dir.exists))
  if (!any(check_paths)) stop("no directories found, try changing alt_root or alt_path")

  try_paths[check_paths]
}

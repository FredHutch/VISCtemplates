
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
#' # assuming this file is located in the docs folder of the repository
#' source(here::here("docs", "declare_directories.R"))
#' t_dir <- declare_directories(trials = TRUE)
#' CVDXX_adata <-  read_csv(file.path(t_dir, folder_location, "DATE_adata.csv")
#'  or 
#' CVDXX_adata <-  read_csv(file.path(declare_directories(trials = TRUE), folder_location, "DATE_adata.csv")
declare_directories <- function(trials = FALSE,
                                networks = FALSE){

  # stop and return message if more than one are declared as TRUE
  if (sum(trials, networks) > 1) {
    stop("Error: Only one of trials or networks should be TRUE.")
  }
  
  # if trials == TRUE then load in OS or
  if (trials) {
    if (.Platform$OS.type == 'unix') {
      trials_directory <- "/Volumes/trials/"
    } else {
      trials_directory <- "T:/"
    }
    return(trials_directory)}
    
    # if trials == TRUE then load in OS or
    if (networks) {
      if (.Platform$OS.type == 'unix') {
        networks_directory <- "/Volumes/networks/"
      } else {
        networks_directory <- "N:/"
      }
      return(networks_directory)}
      
}

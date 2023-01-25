#' @title Compare two data objects from git commits 
#' @description Compare two data objects from different commits.
#' data_object can either be selected from choices, typed in as text, or rda object can be used as well
#' SHA1 corresponds to commit of data object that will be compared. SHA1 can either be SHA or commit short form or long form. SHA1 can be null (useful for situations where pdata has just been updated and comparison is being done with previous version)
#' SHA2 can be NULL or have another commit. NULL is useful when you have a current pdata object loaded in workspace. non-null SHA2 is useful for when comparing 2 objects from different commits.
#' objects are compared through package {diffdf}.
#' @section Last updated by:
#' Valeria Duran
#' @section Last updated date:
#' 01/11/2013
#' @param data_object the data object name
#' @param SHA1 first commit id
#' @param SHA2 second commit id
#' @param simplify Should the "differences" output contain detailed comparisons? Defaults to FALSE
#' @return a list of:
#' \item{repo}{The remote repository}
#' \item{branch}{The current branch}
#' \item{SHA_1}{First commit ID}
#' \item{SHA_2}{Second commit ID}
#' \item{object_name}{Name of the object}
#' \item{differences}{Output of diffdf}
#' @importFrom git2r repository_head remote_url checkout stash status stash_pop
#' @importFrom diffdf diffdf
#' @details working directory must be pointed to repo clone
#' @examples
#' # Lusso847
#' repoList <- git_object_compare(data_object = "nab", SHA1 = "f199ca8" , SHA2 = "30aa5d5")
#' @export
git_object_compare <-
  function(data_object = NULL,
           SHA1 = NULL,
           SHA2 = NULL,
           simplify = FALSE
  ) {
    
    repo_info <- list(
      "repo" = NULL,
      "branch" = NULL,
      "SHA_1" = NULL,
      "SHA_2" = NULL,
      "object_name" = NULL,
      "differences" = NULL 
    )
    
    ## get branch name
    
    git_branch <- repository_head(".")$name
    
    repo_info$branch <- git_branch
    
    ## get all rda objects
   object_names <- sort(unique(gsub(".*/","",system2("git" ,"ls-files '*.rda'" , stdout = TRUE))))
    
    
    ### Give choice to select object name
    if (is.null(data_object)) {
      
      cat(do.call(paste, c(sprintf("%d. %s", seq_along(object_names), object_names), list(sep = '\n'))), sep = '\n')
      
      
      object_selection <- readline("Enter # for pdata: ")
      object_selection <-
        tryCatch(
          as.integer(object_selection),
          warning = function(c)
            "integer typed incorrectly."
        )
      
      ## if branch selection out of bounds then return selection menu
      while (!any(object_selection == 1:length(object_names))) {
        object_selection <- readline("Enter # for pdata: ")
      }
      
      pdata_object <- object_names[object_selection]
    } else if (all(class(data_object) %in% c("character"))) {
      ## if user types in object name then filter to that selection
      pdata_object <- grep(data_object, object_names, value = TRUE, ignore.case = TRUE)
      
      
      
    } else if (any(grepl("tbl|data", class(data_object)))) {
      #if user inserts object then don't ask for selection input
      data_object_1 <- data_object
      pdata_object_1 <- deparse(substitute(data_object))
      pdata_object <- paste0(pdata_object_1, ".rda")
    }
    
    if (length(pdata_object) < 1) {
      stop("Object not found. Input should contain text found in pdata object name.")
    }
    
    # store object name in list
    repo_info$object_name <- pdata_object
    
    
    # get commit information on the object
    
    ## get SHAs to compare
    ### IF SHA1 NULL then grab most recent pdata commit
    if (is.null(SHA1)) {
      SHA_1 <- system2("git" ,paste0("log -n 1 --pretty=format:%h -- ","*",pdata_object), stdout = TRUE)
      
    } else if (!is.null(SHA1)) {
      ## if SHA1 isn't null then grab full SHA text
      SHA_1 <- system2("git" ,paste("rev-parse", SHA1), stdout = TRUE)
      
      if (length(SHA_1) < 1) {
        stop("Commit not found. Input should be a commit or SHA.")
      }
      
    }
    
    ## store SHA1 in list
    repo_info$SHA_1 <- SHA_1
    
    ## if comparing object from two different commits, insert SHA2
    if (!is.null(SHA2)) {
      SHA_2 <- system2("git" ,paste("rev-parse", SHA2), stdout = TRUE)
      
    } else if (is.null(SHA2)) {
      #if not comparing SHA2 then make blank
      SHA_2 <- ""
      
    }
    # store SHA2 in list
    repo_info$SHA_2 <- SHA_2
    
    
    ## Get repository remote url
    
    repo <-
      ifelse(length(remote_url()) == 1, remote_url(), "")
    
    # store repository remote url in list
    repo_info$repo <- repo
    
    
    ### checkout to SHA1 and store pdata object to compare
    # stash files if needed
    
    if (!is.null(unlist(status()))) {
      stash_selection <- readline("Stash changes? [Y/N]: ")
      
      if (stash_selection == 'Y') {
        git_stash <- stash(".")
      } else if (stash_selection == 'N') {
        stop("Need to save or remove changes before checking out.")
      }
    } else if (is.null(unlist(status()))) {
      git_stash <- NULL
    }
    
    
    
    data_file <- system2("git" ,paste0("ls-files ","*",pdata_object), stdout = TRUE)
    # if SHA2 is null then assign checked-out object as object2
    if (is.null(SHA2)) {
      checkout(".", SHA_1)
      
      load(file = data_file)
      data_object_2 <- get(gsub(".rda", "", pdata_object))
      
      
      
    } else if (!is.null(SHA2)) {
      ## if SHA2 isn't null then assign SHA1 object as object1 and SHA2 object as object2
      checkout(".", SHA_1)
      load(file = data_file)
      data_object_1 <- get(gsub(".rda", "", pdata_object))
      
      
      checkout(".", SHA_2)
      load(file = data_file)
      data_object_2 <- get(gsub(".rda", "", pdata_object))
      
    }
    
    ## checkout to HEAD to go back to current branch state
    
    checkout(".", git_branch)
    
    ## stash pop 
    if(!is.null(git_stash)){
      stash_pop(git_stash)
    }
    
    
    ## check differences of data objects
    
    differences <- obj_compare(data_object_1, data_object_2, simplify = simplify)
    
    
    
    repo_info$differences <- differences
    return(repo_info)
    
    
  }



#' @title Compare two data objects
#' @description Compare two data objects
#'    These are objects that are in environment,
#'    NOT with git commits.
#'
#' @section Last updated by:
#' Valeria Duran
#' @section Last updated date:
#' 01/11/2023
#' @param data_object_1 data object to compare
#' @param data_object_2 data object to compare against
#' @param simplify Should the "differences" output contain detailed comparisons? Defaults to FALSE
#' @return a list indicating the differences between the two data frames. If no differences are found, a character string is returned. 
#' @importFrom diffdf diffdf
#'
#' @examples
#'
#' df<-data.frame(x=c(1:10),y=c(6:15))
#' df2<-data.frame(x=c(1:10), y=c(15:24))
#' obj_compare(df,df2)
#' obj_compare(df,df2, simplify = TRUE)
#' obj_compare(df,df)
#' @export

obj_compare <- function(data_object_1, data_object_2, simplify = FALSE){
  if(!simplify){
    
    if(length(invisible(capture.output(diffdf(data_object_1, data_object_2, suppress_warnings = TRUE)))) == 1){
      capture.output(diffdf(data_object_1, data_object_2))
    } else{
      withCallingHandlers(
        diffdf(data_object_1, data_object_2),
        warning = function(w)
          conditionMessage(w)
      )
    }
  } else {
    if(length(invisible(capture.output(diffdf(data_object_1, data_object_2, suppress_warnings = TRUE)))) == 1){
      capture.output(diffdf(data_object_1, data_object_2))
    } else{
      tryCatch(
        withCallingHandlers(#diffdf(data_object_1, data_object_2),
          diffdf(data_object_1, data_object_2),
          warning = function(w){warn <- conditionMessage(w)
          } ),
        warning = function(c){
          invisible(c)
          warning("Not all Values Compared Equal", call. = FALSE)
          return("Not all Values Compared Equal")
          
        }
        
      )
      
    }
    
  }
}

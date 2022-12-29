
### The goal of the function is to compare 2 data objects from different commits.
# dataObject can either be selected from choices, typed in as text, or rda object can be used as well
# SHA1 corresponds to commit of data object that will be compared. SHA1 can either be SHA or commit short form or long form. SHA1 can be null (useful for situations where pdata has just been updated and comparison is being done with previous version)
# SHA2 can be NULL or have another commit. NULL is useful when you have a current pdata object loaded in workspace. non-null SHA2 is useful for when comparing 2 objects from different commits.
# objects are compared through package {diffdf}.

#' Compare data objects from two different commits.
#' @param dataobject the data object name
#' @param SHA1 first commit id
#' @param SHA2 second commit id
#' @return a list of:
#' \item{
#'
#' }
#' @importFrom git2r repository_head odb_blobs remote_url checkout stash status
#' @importFrom diffdf diffdf
#' @details working directory must be pointed to repo clone
#' @examples
#' # Lusso847
#' repoList <- object_compare(dataObject = "nab", SHA1 = "f199ca8" , SHA2 = "30aa5d5")
#' @export
object_compare <-
  function(data_object = NULL,
           SHA1 = NULL,
           SHA2 = NULL) {

    repo_info <- list(
      "repo" = NULL,
      "branch" = NULL,
      "SHA1" = NULL,
      "SHA2" = NULL,
      "object_name" = NULL,
      "differences" = NULL #ideally I'd like the function to output the warning message, but will save here for now
    )

    ## get branch name

    git_branch <- repository_head(".")$name

    repo_info$branch <- git_branch

    ## get all rda objects
    object_names <-
      sort(unique(subset(
        odb_blobs(), grepl(".rda", name)
      )$name))



    ### Give choice to select object name
    if (is.null(data_object)) {
      for (i in 1:length(object_names)) {
        cat(sprintf("%d. %s\n", i, object_names[i]))
      }

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
    } else if (class(data_object) == "character") {
      ## if user types in object name then filter to that selection
      pdata_object <- grep(data_object, object_names, value = TRUE)



    } else if (class(data_object) == "data.frame") {
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
    files <- subset(odb_blobs(), name == pdata_object)
    ## get SHAs to compare
    ### IF SHA1 NULL then grab most recent pdata commit
    if (is.null(SHA1)) {
      get_first <- sort(files$when, decreasing = TRUE)[1]

      SHA1 <- unique(subset(files, when == get_first)$commit)

    } else if (!is.null(SHA1)) {
      ## if SHA1 isn't null then grab full SHA text
      SHA1 <-
        unique(subset(odb_blobs(), grepl(SHA1, sha) |
                        grepl(SHA1, commit))$commit)

      if (length(SHA1) < 1) {
        stop("Commit not found. Input should be a commit or SHA.")
      }

    }

    ## store SHA1 in list
    repo_info$SHA1 <- SHA1

    ## if comparing object from two different commits, insert SHA2
    if (!is.null(SHA2)) {
      SHA2 <-
        unique(subset(odb_blobs(), grepl(SHA2, sha) |
                        grepl(SHA2, commit))$commit)

    } else if (is.null(SHA2)) {
      #if not comparing SHA2 then make blank
      SHA2 <- ""

    }
    # store SHA2 in list
    repo_info$SHA2 <- SHA2


    ## Get repository remote url

    repo <-
      ifelse(length(remote_url()) == 1, remote_url(), "")

    # store repository remote url in list
    repo_info$repo <- repo


    ### checkout to SHA1 and store pdata object to compare
    #TODO: stash files if needed

    if (length(status(".")$unstaged) > 0) {
      stash_selection <- readline("Stash changes? [Y/N]: ")

      if (stash_selection == 'Y') {
        stash(".")
      } else if (stash_selection == 'N') {
        stop("Need to save or remove changes before checking out.")
      }
    }



    data_file <- paste('data/', pdata_object, sep = "")
    # if SHA2 is null then assign checked-out object as object2
    if (is.null(SHA2)) {
      checkout(".", SHA1)

      load(file = dataFile)
      data_object_2 <- pdata_object



    } else if (!is.null(SHA2)) {
      ## if SHA2 isn't null then assign SHA1 object as object1 and SHA2 object as object2
      checkout(".", SHA1)
      load(file = data_file)
      data_object_1 <- get(gsub(".rda", "", pdata_object))


      checkout(".", SHA2)
      load(file = data_file)
      data_object_2 <- get(gsub(".rda", "", pdata_object))



      ## checkout to HEAD to go back to current branch state

      checkout(".", git_branch)

      ###TODO: check differences of data objects
      differences <- diffdf(data_object_1, data_object_2)

      ##TODO: fix below
      withCallingHandlers(
        diffdf(data_object_1, data_object_2),
        warning = function(w)
          print(w$message)
      )

      repo_info$differences <- differences
      return(repo_info)

    }
}





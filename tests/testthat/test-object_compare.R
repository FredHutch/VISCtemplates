# tests for comparison of data objects
context("test-git_object_compare")

test_that("use full pdata name and suffix", {

  # TODO: this can probably be abstracted to a minimum simple example
  # using withr to create a temp directory see example:
  # https://github.com/phuse-org/valtools/blob/main/tests/testthat/test-create_validation_packet.R

  #Lusso847
  repoList1 <- object_compare(dataObject = "nab", SHA1 = "f199ca8" , SHA2 = "30aa5d5")

  repoList2 <- object_compare(dataObject = "Lusso847_nab", SHA1 = "f199ca8" , SHA2 = "30aa5d5")

})



test_that("Warning Message is Shown When Differences Are Detected",{
  df<-data.frame(x=c(1:10),y=c(6:15))
  df2<-data.frame(x=c(1:10), y=c(15:24))
  expect_warning(
    obj_compare(df,df2),
    "Not all Values Compared Equal"
  )
})


test_that("Character String Outputed When No Differences Detected",{
  df<-data.frame(x=c(1:10),y=c(6:15))
 expect_equal(
    obj_compare(df,df),
   "No issues were found!"
  )
})

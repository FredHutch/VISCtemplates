# tests for comparison of data objects

test_that("use full pdata name and suffix", {

  # TODO: this can probably be abstracted to a minimum simple example
  # using withr to create a temp directory see example:
  # https://github.com/phuse-org/valtools/blob/main/tests/testthat/test-create_validation_packet.R

  #Lusso847
  repoList1 <- object_compare(dataObject = "nab", SHA1 = "f199ca8" , SHA2 = "30aa5d5")

  repoList2 <- object_compare(dataObject = "Lusso847_nab", SHA1 = "f199ca8" , SHA2 = "30aa5d5")

})

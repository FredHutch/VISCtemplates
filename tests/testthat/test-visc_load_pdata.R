test_that("visc_load_pdata works", {
  td <- withr::local_tempdir()
  file <- system.file("extdata", "tests", "subsetCars.Rmd",
                      package = "VISCtemplates"
  )
  DataPackageR::datapackage_skeleton(
    name = "Visc777",
    path = td,
    code_files = file,
    r_object_names = "Visc777_cars"
  )
  suppressMessages({
    pb_res <- DataPackageR::package_build(file.path(td, "Visc777"))
  })
  expect_equal(basename(pb_res), "Visc777_1.0.tar.gz")
  expect_no_error(
    suppressMessages({
      proj_loaded_pdata <- visc_load_pdata(Visc777_cars,
                            'proj',
                            '3ccb5b0aaa74fe7cfc0d3ca6ab0b5cf3'
      )
    })
  )
  expect_equal(proj_loaded_pdata, subset(cars, speed > 20))
})

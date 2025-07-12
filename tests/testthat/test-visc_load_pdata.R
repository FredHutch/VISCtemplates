test_that("visc_load_pdata works", {
  # make and build test datapackage
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
  # test with local source "project" datapackage
  # right hash
  expect_no_error(
    suppressMessages({
      proj_loaded_pdata <- visc_load_pdata(Visc777_cars,
                            'proj',
                            '3ccb5b0aaa74fe7cfc0d3ca6ab0b5cf3'
      )
    })
  )
  expect_equal(proj_loaded_pdata, subset(cars, speed > 20))
  # wrong hash
  expect_error(
    suppressMessages({
      visc_load_pdata(Visc777_cars,
                                           'proj',
                                           'fffb5b0aaa74fe7cfc0d3ca6ab0bffff'
      )
    }),
    "pdata_digest.*not equal to.*criteria.*expected"
  )
  # test with installed data package
  withr::with_temp_libpaths({
    # friendly error message when data package not yet installed
    expect_error(visc_load_pdata(Visc777_cars,
                    'datapackage',
                    '3ccb5b0aaa74fe7cfc0d3ca6ab0b5cf3'),
                 'Data package.*not installed'
    )
    # install
    suppressMessages({
      pb_res <- DataPackageR::package_build(file.path(td, "Visc777"),
                                            install = TRUE, quiet = TRUE)
    })
    # test RDA style package data installation
    expect_equal(
        'Visc777_cars.rda',
        list.files(file.path(.libPaths()[1], 'Visc777', 'data'))
    )
    # right hash
    expect_no_error(
      suppressMessages({
        pkg_loaded_pdata <- visc_load_pdata(Visc777_cars,
                                            'datapackage',
                                            '3ccb5b0aaa74fe7cfc0d3ca6ab0b5cf3'
        )
      })
    )
    # wrong hash
    expect_error(
      suppressMessages({
        visc_load_pdata(Visc777_cars,
                        'datapackage',
                        'fffb5b0aaa74fe7cfc0d3ca6ab0bffff'
        )
      }),
      "pdata_digest.*not equal to.*criteria.*expected"
    )
    # right hash but errors out when can't find the data/object.rda file
    file.remove(
      system.file(file.path('data', "Visc777_cars.rda"), package = 'Visc777')
    )
    expect_error(
      suppressMessages({
        visc_load_pdata(Visc777_cars,
                        'datapackage',
                        '3ccb5b0aaa74fe7cfc0d3ca6ab0b5cf3'
        )
      }),
      "Unable to find data object.*"
    )
    # Reinstall package with LazyData: true in DESCRIPTION field
    desc_path <- file.path(td, "Visc777", "DESCRIPTION")
    new_desc <- c(readLines(desc_path), 'LazyData: true')
    writeLines(new_desc, desc_path)
    # do install
    suppressMessages({
      pb_res <- DataPackageR::package_build(file.path(td, "Visc777"),
                                            install = TRUE, quiet = TRUE)
    })
    # test LazyData style package data installation
    expect_true(
      setequal(
        c('Rdata.rdb', 'Rdata.rds', 'Rdata.rdx'),
        list.files(file.path(.libPaths()[1], 'Visc777', 'data'))
      )
    )
    # right hash
    expect_no_error(
      suppressMessages({
        pkg_loaded_pdata <- visc_load_pdata(Visc777_cars,
                                            'datapackage',
                                            '3ccb5b0aaa74fe7cfc0d3ca6ab0b5cf3'
        )
      })
    )
    # wrong hash
    expect_error(
      suppressMessages({
        visc_load_pdata(Visc777_cars,
                        'datapackage',
                        'fffb5b0aaa74fe7cfc0d3ca6ab0bffff'
        )
      }),
      "pdata_digest.*not equal to.*criteria.*expected"
    )
  })
})

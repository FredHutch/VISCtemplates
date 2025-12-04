test_that("visc_load_pdata works", {
  old_usethis_quiet <- getOption('usethis.quiet')
  on.exit(options(usethis.quiet = old_usethis_quiet), add = TRUE)
  options(usethis.quiet = TRUE)
  # make and build test datapackage
  td <- withr::local_tempdir()
  usethis::create_package(
    path = file.path(td, "Visc777"),
    rstudio = FALSE,
    open = FALSE
  )
  dir.create(file.path(td, 'Visc777', 'data'), recursive = TRUE)
  Visc777_cars <- subset(cars, speed > 20)
  save(
    Visc777_cars,
    file = file.path(td, 'Visc777', 'data', 'Visc777_cars.rda')
  )

  # test using project repo
  withr::local_dir(file.path(td, "Visc777"))
  # warn when criteria = NULL
  expect_warning(
    suppressMessages({
      visc_load_pdata(Visc777_cars, 'proj')
    }),
    'No criteria provided'
  )
  # warn when criteria given as dataVersion (defunct, now ignores check)
  expect_warning(
    suppressMessages({
      visc_load_pdata(Visc777_cars, 'proj', '0.1.3')
    }),
    'Ignoring criteria check'
  )
  # warn when criteria is unexpected
  expect_warning(
    suppressMessages({
      visc_load_pdata(Visc777_cars, 'proj', 'yo')
    }),
    'Incorrect criteria syntax provided'
  )
  # test with local source "project" datapackage
  # wrong `.data` class
  expect_error(
    suppressMessages({
      proj_loaded_pdata <- visc_load_pdata(2L, 'proj')
    }),
    'must be an unquoted name or a character string'
  )
  # right hash, character string pdata argument
  expect_no_error(
    suppressMessages({
      proj_loaded_pdata <- visc_load_pdata('Visc777_cars',
                                           'proj',
                                           '3ccb5b0aaa74fe7cfc0d3ca6ab0b5cf3'
      )
    })
  )
  # right hash, character string pdata argument, used in other code
  expect_no_error(
    suppressMessages({
      res <- lapply(
        rep('Visc777_cars', 2),
        visc_load_pdata,
        proj_or_datapackage = 'proj',
        criteria = '3ccb5b0aaa74fe7cfc0d3ca6ab0b5cf3'
      )
    })
  )
  expect_length(res, 2)
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
    })
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
    utils::install.packages(
      file.path(td, "Visc777"), repo = NULL, quiet = TRUE
    )
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
    # right hash, dataVersion given (defunct, now ignores check)
    expect_warning(
      suppressMessages({
        pkg_loaded_pdata <- visc_load_pdata(Visc777_cars,
                                            'datapackage',
                                            '0.1.0'
        )
      }),
      "Ignoring criteria check"
    )
    # wrong hash
    expect_error(
      suppressMessages({
        visc_load_pdata(Visc777_cars,
                        'datapackage',
                        'fffb5b0aaa74fe7cfc0d3ca6ab0bffff'
        )
      })
    )
    # errors out when can't find the data/object.rda file
    expect_error(
      suppressMessages({
          visc_load_pdata(Visc777_cars_BAD, 'datapackage')
      }),
      "data set .* not found"
    )
    # errors out when data file exists but doesn't contain namesake R object
    my_pi <- pi
    save(my_pi, file = system.file(file.path('data', "Visc777_cars.rda"), package = 'Visc777'))
    expect_error(
      suppressMessages({
        visc_load_pdata(Visc777_cars, 'datapackage')
      }),
      "exists but does not contain an R object named"
    )
    # Reinstall package with LazyData: true in DESCRIPTION field
    desc_path <- file.path(td, "Visc777", "DESCRIPTION")
    new_desc <- c(readLines(desc_path), 'LazyData: true')
    writeLines(new_desc, desc_path)
    # do install
    utils::install.packages(
      file.path(td, "Visc777"), repo = NULL, quiet = TRUE
    )
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
      })
    )
  })
})

test_that('visc_load_pdata works with non-standard pdata name', {
  old_usethis_quiet <- getOption('usethis.quiet')
  on.exit(options(usethis.quiet = old_usethis_quiet), add = TRUE)
  options(usethis.quiet = TRUE)

  # setup test pkg with standard and non-standard data objects
  td <- withr::local_tempdir()
  usethis::create_package(
    path = file.path(td, "Visc777"),
    rstudio = FALSE,
    open = FALSE
  )
  dir.create(file.path(td, 'Visc777', 'data'), recursive = TRUE)
  Visc777_cars <- subset(cars, speed > 20)
  save(
    Visc777_cars,
    file = file.path(td, 'Visc777', 'data', 'Visc777_cars.rda')
  )
  rogue_object <- Visc777_cars
  save(
    rogue_object,
    file = file.path(td, 'Visc777', 'data', 'rogue_object.rda')
  )
  # test using project repo
  withr::local_dir(file.path(td, 'Visc777'))
  # Even for rogue object with non-standard naming, don't need to provide
  # package override in proj/repo mode
  expect_no_error(
    suppressMessages(
      rogue_object <- visc_load_pdata(
        'rogue_object',
        'proj',
        '3ccb5b0aaa74fe7cfc0d3ca6ab0b5cf3'
      )
    )
  )
  # test using pdata from installed datapackage
  withr::with_temp_libpaths({
    utils::install.packages(
      file.path(td, "Visc777"), repo = NULL, quiet = TRUE
    )
    # right hash, rogue object handled
    expect_no_error(
      suppressMessages(
        rogue_object <- visc_load_pdata(
          'rogue_object',
          'datapackage',
          '3ccb5b0aaa74fe7cfc0d3ca6ab0b5cf3',
          'Visc777'
        )
      )
    )
    # should be identical to rogue_object, based on test Rmd file
    suppressMessages(
      Visc777_cars <- visc_load_pdata(
        'Visc777_cars',
        'datapackage',
        '3ccb5b0aaa74fe7cfc0d3ca6ab0b5cf3'
      )
    )
    expect_identical(rogue_object, Visc777_cars)
  })
})

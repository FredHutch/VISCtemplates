
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->

[![R-CMD-check](https://github.com/FredHutch/VISCtemplates/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/FredHutch/VISCtemplates/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/FredHutch/VISCtemplates/graph/badge.svg)](https://app.codecov.io/gh/FredHutch/VISCtemplates)
<!-- badges: end -->

# VISCtemplates

The goal of the VISCtemplates package is to:

- automate VISC project setup
- provide a common, easy-to-understand directory structure across VISC analyses
- provide consistency across VISC reports

Most of the actual template files (including rmarkdown, latex, and docx files) are located in the `inst/templates/` folder, while convenience functions in R (building on the style and functionality of the [usethis](https://github.com/r-lib/usethis) package) for setting up VISC projects and reports can be found in the `R` folder.

## Installation

The package is available on the Fred Hutch organization GitHub page.

``` r
remotes::install_github("FredHutch/VISCtemplates")

# install the package with vignettes:
remotes::install_github("FredHutch/VISCtemplates", build_vignettes = TRUE)
```

## Requirements

- R (version \>= 3.0)
- RStudio (version \>= 1.2)
  - Includes Pandoc (version \>= 2.0), which is needed for Word reports.
- TinyTeX (or MiKTeX), which is needed for PDF reports.
  - `install.packages(“tinytex”)`
  - `tinytex::install_tinytex()`

## Vignettes

The package vignettes will guide you through setting up an analysis
project with VISCtemplates and
[usethis](https://github.com/r-lib/usethis) and using a VISC report
template.

``` r
vignette("using_pdf_and_word_template")
vignette("create_a_visc_analysis_project")
```

## Usage

Many of the functions in this package build on functions from
[usethis](https://github.com/r-lib/usethis) and
[rmarkdown](https://github.com/rstudio/rmarkdown). Like usethis, most
`use_*()` functions operate on the active project. VISCtemplates is
designed to be used interactively.

The main functions in VISCtemplates are `create_visc_project()`, for
setting up analysis projects, and `use_visc_report()`, for using VISC
report templates. Take a look at the package vignettes for more details.

Create an analysis project:

``` r
path <- "~/mydir/VDCnnnAnalysis"

create_visc_project(path)
```

Use a VISC Report:

``` r
use_visc_report(
  report_name = "VDCnnn_BAMA_PTreport_interim_blinded", # the name of the report file
  path = "BAMA", # the path within the active directory, usually the name of the assay
  report_type = "bama" # "empty", "generic", "bama", or "nab"
)
```

## Why use an R package structure?

The R package structure is used for analysis projects because it
provides an easily recognizable format for file organization and allows
for the use of packages like devtools and roxygen2. For more
information, see:

1.  Ben Marwick, Carl Boettiger, and Lincoln Mullen. Paper: [Packaging
    data analytical work reproducibily using R (and
    friends)](https://peerj.com/preprints/3192/)
2.  Karthik Ram. Rstudio::conf 2019 talk: [How To Make Your Data
    Analysis Notebooks More
    Reproducible](https://github.com/karthik/rstudio2019)
3.  rOpenSci Community Call: [Reproducible Research with
    R](https://ropensci.org/commcalls/2019-07-30/)

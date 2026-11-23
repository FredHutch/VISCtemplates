<!-- badges: start -->
[![R-CMD-check](https://github.com/FredHutch/VISCtemplates/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/FredHutch/VISCtemplates/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/FredHutch/VISCtemplates/branch/main/graph/badge.svg)](https://app.codecov.io/gh/FredHutch/VISCtemplates/tree/main)
<!-- badges: end -->

# VISCtemplates

The goal of VISCtemplates is to:

- automate project setup
- provide a common, easy-to-understand directory structure across
  analyses
- provide consistency across VISC reports

## Installation

The package is available on the Fred Hutch organization GitHub page.

``` r
remotes::install_github("FredHutch/VISCtemplates")

# install the package with vignettes:
remotes::install_github("FredHutch/VISCtemplates", build_vignettes = TRUE)
```

## Requirements

- R (version \>= 4.1.0)
- RStudio is recommended for interactive project setup and knitting reports.
  - RStudio includes Pandoc, which is needed for rendering R Markdown reports.
    Outside RStudio, install Pandoc separately.
- TinyTeX (or MiKTeX), which is additionally needed for PDF reports.
  - `install.packages("tinytex")`
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
library(VISCtemplates)
path <- "~/mydir/VDCnnnAnalysis"

create_visc_project(path)
```

Project creation normally opens a new RStudio session. In the new project,
load VISCtemplates again and create a report:

``` r
library(VISCtemplates)
use_visc_report(
  report_name = "VDCnnn_BAMA_PTreport_interim_blinded", # the name of the report file
  path = "BAMA", # the path within the active directory, usually the name of the assay
  report_type = "bama" # "empty", "generic", "bama", "nab", or "adcc"
)
```

## Why use an R package structure?

By default, `create_visc_project()` creates an analysis project, not an R
package. Set `package = TRUE` to include package-specific files such as
`DESCRIPTION` and `NAMESPACE`. The R package structure provides an easily
recognizable format for file organization and allows for the use of
packages like devtools and roxygen2. For more information, see:

1.  Ben Marwick, Carl Boettiger, and Lincoln Mullen. Paper: [Packaging
    data analytical work reproducibly using R (and
    friends)](https://peerj.com/preprints/3192/)
2.  Karthik Ram. Rstudio::conf 2019 talk: [How To Make Your Data
    Analysis Notebooks More
    Reproducible](https://github.com/karthik/rstudio2019)
3.  rOpenSci Community Call: [Reproducible Research with
    R](https://ropensci.org/commcalls/2019-07-30/)

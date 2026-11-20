<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- badges: start -->
[![R-CMD-check](https://github.com/FredHutch/VISCtemplates/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/FredHutch/VISCtemplates/actions/workflows/R-CMD-check.yaml)
[![Codecov test coverage](https://codecov.io/gh/FredHutch/VISCtemplates/branch/main/graph/badge.svg)](https://app.codecov.io/gh/FredHutch/VISCtemplates/tree/main)
<!-- badges: end -->

# VISCtemplates

VISCtemplates automates project setup, provides a common directory structure
across analyses, and promotes consistency across VISC reports.

## Requirements

* R version >= 4.1.0, as specified in `DESCRIPTION`.
* RStudio is recommended for the interactive project-creation and Knit workflows.
* Pandoc is needed to render R Markdown documents, including PDF, Word, and
  PowerPoint outputs. RStudio includes Pandoc; outside RStudio, install it
  separately. Use `rmarkdown::pandoc_available()` and
  `rmarkdown::pandoc_version()` to inspect your setup. The package's
  `check_pandoc_version()` helper checks for version >= 2.0.
* A LaTeX distribution such as TinyTeX or MiKTeX is additionally needed for PDF
  reports, but not for Word or PowerPoint output.

To install TinyTeX, if you do not already have a LaTeX distribution:

```r
install.packages("tinytex")
tinytex::install_tinytex()
```

## Installation

Install the package from the Fred Hutch GitHub organization:

```r
install.packages("remotes") # once, if not already installed
remotes::install_github("FredHutch/VISCtemplates")
```

To install with the package vignettes, or explicitly select the development branch:

```r
remotes::install_github("FredHutch/VISCtemplates", build_vignettes = TRUE)
remotes::install_github("FredHutch/VISCtemplates", ref = "develop")
```

`VISCfunctions` is a GitHub dependency declared in `DESCRIPTION` and is installed
by `remotes`. Rendering the bundled report skeleton also requires packages used
by the report itself; these are not all mandatory package dependencies:

```r
install.packages(c(
  "conflicted", "ggplot2", "dplyr", "knitr", "kableExtra", "flextable"
))
```

Installing R packages does not install Pandoc or a LaTeX distribution.

## Usage

Many functions build on [usethis](https://github.com/r-lib/usethis) and
[rmarkdown](https://github.com/rstudio/rmarkdown). Like usethis, most `use_*()`
functions operate on the active project. VISCtemplates is designed for
interactive use.

Create an analysis project:

```r
library(VISCtemplates)
create_visc_project("~/VDCnnnAnalysis")
```

Project creation normally opens a new RStudio session. In that session, load the
package and create a report:

```r
library(VISCtemplates)
use_visc_report(
  report_name = "VDCnnn_BAMA_PTreport_interim_blinded",
  path = "BAMA",
  report_type = "bama"
)
```

Choose the report type explicitly:

| `report_type` | Starting point |
|---------------|----------------|
| `"empty"` | A minimal report skeleton without assay-specific methods files. |
| `"generic"` | A PT report skeleton with general-purpose methods text. |
| `"bama"` | A PT report skeleton with BAMA methods text. |
| `"nab"` | A PT report skeleton with NAb methods text. |
| `"adcc"` | A PT report skeleton with ADCC methods text. |

Non-empty reports receive three methods documents in `child-docs/`. Each report
folder receives a `README.md`; an assay-folder `README.md` is also created when
`use_visc_report()` creates a new assay directory. Adapt all template text to the
specific study and analysis before distributing a report.

## Vignettes

The vignettes cover project setup and report templates:

```r
vignette("create_a_visc_analysis_project", package = "VISCtemplates")
vignette("using_pdf_and_word_template", package = "VISCtemplates")
```

If a vignette is unavailable, reinstall with `build_vignettes = TRUE` as above.

## Project structure and optional package mode

By default, `create_visc_project()` creates an RStudio analysis project, not an R
package. It includes `R/`, shared documents in `docs/`, and a `README.md` that you
edit directly. The temporary project `README.Rmd` is removed after rendering.

Use `create_visc_project(path, package = TRUE)` if you specifically want an R
package project, including package metadata such as `DESCRIPTION` and `NAMESPACE`.
This optional structure supports package-development tools such as devtools and
roxygen2. For background on reproducible project organization, see:

1. Ben Marwick, Carl Boettiger, and Lincoln Mullen: [Packaging data analytical work reproducibly using R (and friends)](https://peerj.com/preprints/3192/).
2. Karthik Ram: [How To Make Your Data Analysis Notebooks More Reproducible](https://github.com/karthik/rstudio2019).
3. rOpenSci Community Call: [Reproducible Research with R](https://ropensci.org/commcalls/2019-07-30/).

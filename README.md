
<!-- README.md is generated from README.Rmd. Please edit that file -->

# VISCtemplates

The goal of VISCtemplates is to:

-   automate project setup
-   provide a common, easy-to-understand directory structure across
    analyses
-   provide consistency across VISC reports

## Installation

The package is available on the Fred Hutch organization GitHub page.

``` r
remotes::install_github("FredHutch/VISCtemplates")

# Use the build_vignettes parameter to access the vignette:
remotes::install_github("FredHutch/VISCtemplates", build_vignettes = TRUE)
vignette("using_pdf_and_word_template")
```

## Requirements

-   R (version &gt;= 3.0)
-   RStudio (version &gt;= 1.2)
    -   Includes Pandoc (version &gt;= 2.0), which is needed for Word
        reports.
-   TinyTeX (or MiKTeX), which is needed for PDF reports.
    -   `install.packages(“tinytex”)`
    -   `tinytex::install_tinytex()`

## Usage

Many of the functions in this package build on functions from
[usethis](https://github.com/r-lib/usethis) and
[rmarkdown](https://github.com/rstudio/rmarkdown). Like usethis, most
`use_*()` functions operate on the active project.

Below is a quick look at how to VISCtemplates can help you set you your
analysis repo and VISC reports. Take a look at the package vignettes for
more details.

    > create_visc_project(path)
    Creating a new VISC project called VDCAnalysis456.
    At VISC, we use a naming convention for analysis projects, VDCnnnAnalysis,
    where 'VDC' is the CAVD PI name, and 'nnn' is the CAVD project number.
    Would you like to continue?

    1: Negative
    2: I agree
    3: No

    Selection: 2
    √ Creating '/Temp/Rtmp0mOknO/VDCAnalysis456/'
    √ Setting active project to '/Temp/Rtmp0mOknO/VDCAnalysis456'
    √ Creating 'R/'
    √ Writing 'DESCRIPTION'
    Package: VDCAnalysis456
    Title: What the Package Does (One Line, Title Case)
    Version: 0.0.0.9000
    Authors@R (parsed):
        * First Last <first.last@example.com> [aut, cre] (YOUR-ORCID-ID)
    Description: What the package does (one paragraph).
    License: `use_mit_license()`, `use_gpl3_license()` or friends to
        pick a license
    Encoding: UTF-8
    Roxygen: list(markdown = TRUE)
    RoxygenNote: 7.1.1
    √ Writing 'NAMESPACE'
    √ Writing 'VDCAnalysis456.Rproj'
    √ Adding '^VDCAnalysis456\\.Rproj$' to '.Rbuildignore'
    √ Adding '.Rproj.user' to '.gitignore'
    √ Adding '^\\.Rproj\\.user$' to '.Rbuildignore'
    √ Opening 'C:/Users/mgerber/AppData/Local/Temp/Rtmp0mOknO/VDCAnalysis456/' in new RStudio session
    √ Setting active project to '<no active project>'
    √ Setting active project to 'C:/Users/mgerber/AppData/Local/Temp/Rtmp0mOknO/VDCAnalysis456'
    √ Adding '.Rhistory', '.RData', '.Ruserdata', 'README.html', '~$*.doc*', '~$*.xls*', '~$*.ppt*', '*.xlk', '.DS_Store', '.DS_Store?', '._*', '.Spotlight-V100', '.Trashes', 'ehthumbs.db', 'Thumbs.db', '*.log', '**/figure-latex/*.pdf', '**/figure-docx/*.pdf', '*.zip' to '.gitignore'
    √ Writing 'README.Rmd'
    √ Creating 'docs/'
    √ Creating 'docs/presentations/'
    √ Writing 'docs/background.Rmd'
    √ Writing 'docs/objectives.Rmd'
    √ Writing 'R/group_colors.R'
    √ Writing 'R/study_schema.R'

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

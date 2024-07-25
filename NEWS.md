# VISCtemplates (development version)

* Reconcile differences between empty report template and other report templates (#204)

# VISCtemplates 1.3.1

Bug Fix
* Re-flip Fred Hutch and SCHARP header logos to fix regression from #196, restoring intended logo positions in #195 (#205)

# VISCtemplates 1.3.0

Bug Fixes
* Fix major bug that broke PDF knitting on pandoc >= 3.1.7 (#159)
* Fix bug with latex packages (specifically etex's \reserveinserts command) that broke PDF knitting (#160)
* Fix bug that occurred when a report subdirectory did not already exist, and add unit test (#173)
* Fix `insert_break()` to actually create a page break (#188)
  + Update documentation to instruct users to use `\newpage` instead in new code

Improvements to Report Templates
* Update header logo for SCHARP/Fred Hutch branding compliance (#195)
* Update templates and documentation for using correct syntax for multiple citations (#191)
* Add section number to References section in PDF output (#176)
* Clarify expectations for Background section of report (#143)
* Fix BAMA positivity call definition (#144)
* Add Acknowledgments section to report templates (#153)

Testing and Continuous Integration
* Create unit tests to test knit all report templates to PDF and Word (#168, #182, #186, #187, #192)
  + Test locally via `devtools::test()`; files written to `testthat/_snaps`
  + On pull requests, test reports are written to file snapshots on GitHub Actions
* Add GitHub Actions runner to test statsrv compatibility by matching its R and pandoc versions (#172)
* Add `interactive = FALSE` option to interactive functions to facilitate automated unit testing (#168)
* Speed up GitHub Action that renders skeleton.Rmd (#166)
  + But then remove it entirely once superseded by more thorough test knitting (#178)

Documentation and UI Improvements
* Fix bad URL in GitHub setup instructions (#185)
* Add guidance for where to install data packages (#154)
* Add friendly error message to visc_load_pdata() when data package is not installed (#152)
* Specify existence of NAb template in README and vignettes (#189)

Package Maintenance
* Adjust filenames in R/ and tests/ to follow best practices (#175, #179)
* Respect existing getOption('repos') instead of forcing CRAN installations (#163)
* Adjust dependencies in DESCRIPTION (#164)
* Update package authors and maintainer (#190)
* Clean up latex template code, removing commented-out code and reorganizing for better readability (#196)

# VISCtemplates 1.2.0

* Update Fred Hutch logo in Word and PDF templates
* Fix continuous integration issues (GitHub actions)
* New GitHub action to auto-generate empty report template in Word and PDF (for verifying format with PRs) and associated template fixes
* Fix double section numbering issue in Word doc template
* Add visc_load_pdata and DataPackageR to Rmd template code

# VISCtemplates 1.1.0

* Improvements to `use_visc_report()`:
    + A new NAb assay template. 
    + This function reminds the user to use VISC's report naming convention.

# VISCtemplates 1.0.0

The new release number is bumped to 1.0.0 because this version implements the structure needed for assay-specific templates.

* New feature: `use_visc_report()` creates a VISC report template with assay-specific R Markdown files.
* New vignette: a new vignette outlines how to set up a VISC analysis project (`vignette("create_a_visc_analysis_project")`).
* Changes to the PT report README to make it easier to use.
* Minor changes:
    + "*.zip" added to the .gitignore template
    + *.R template files created with `create_visc_project()` are saved to R/ in the analysis project template. 
    + The study schema template is an R function.
    + New prompt with `create_visc_project()` asks about the project name.
    + Added \sloppy to .tex template to help with antigen name formatting.
* Minor edits to template language and documentation throughout. 

# VISCtemplates 0.3.4

* Bug fix: updated `bibliography.bib` file to fix citation format for R Core Team citation.

# VISCtemplates 0.3.3

* Bug fix: updated `bibliography.bib` file to fix issue with Mac using bib files.
* Updated `visc_report/skeleton.Rmd` file in preparation of bug fix being addressed in VISCfunctions

# VISCtemplates 0.3.2

* Bug fix: fixed pandoc error that complains about cslreferences.

# VISCtemplates 0.3.1

* Bug fix:
    + Fixed biber/bibtex issue with pdf output.

# VISCtemplates 0.3.0

* New "empty" report template without the boilerplate PT report text.
    + Go to `File > New File > Rmarkdown... > From Template` and select the "Empty Report" template.
    + Or use `template = "visc_empty"` argument in `rmarkdown::draft()`.
    + See the updated vignette for more info.
* Changes to `bibliography.bib` file.
    + Shortened file contains only citations used in VISC reports.
    + A project-level `bibliography.bib` file is written to the `docs/` directory. Previously there was one file generated for each report.
* New Github PR text links to the documentation for writing and code review.
* Bug fixes:
    + Footnote hyperlinks fixed: `Footnote text (^[MY_FOOTNOTE])`.

# VISCtemplates 0.2.0

* Changes to VISC Report (PDF & Word Output) template.
    + Example text updated.
    + Functions defined in report are now exported functions from {VISCtemplates}. Use `insert_ref()` to insert a reference to a table or figure.
    + Vignette updated to reflect these changes. 


# VISCtemplates 0.1.2

* Minor fix to the VISC report template for compatibility with pandoc upgrade.


# VISCtemplates 0.1.1

* Added a `NEWS.md` file to track changes to the package.
* Added `CONDUCT.md` and `CONTRIBUTING.md` to the package.
* Improved `README.Rmd`.
* You can now drop the VISC logo from the PT report template with `dropVISClogo: true`.

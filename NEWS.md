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
    + Functions defined in report are now exported functions from {VISCtemplates}. Use `insert_break()` to create a page break and `insert_ref()` to insert a reference to a table or figure.
    + Vignette updated to reflect these changes. 


# VISCtemplates 0.1.2

* Minor fix to the VISC report template for compatibility with pandoc upgrade.


# VISCtemplates 0.1.1

* Added a `NEWS.md` file to track changes to the package.
* Added `CONDUCT.md` and `CONTRIBUTING.md` to the package.
* Improved `README.Rmd`.
* You can now drop the VISC logo from the PT report template with `dropVISClogo: true`.

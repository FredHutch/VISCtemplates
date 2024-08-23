## Description

Make sure to provide a brief summary of your changes in the pull request title above.

Here, describe your changes in detail. 
Give a short background on the report, outline important questions or details for the reviewer, and add links to any supporting documents (e.g., protocol presentation). 
It's helpful to add links to the key files with the unique ID for the commit (a.k.a. the "SHA" or "hash").

Make sure to include any known outstanding issues as well (and if they will be addressed in future PRs).

## Reflection

Describe any key challenges you faced in working on these changes. Were these challenges unique to this project, or do you think they apply to other VISC projects as well? If not unique, have any relevant GitHub issues in the [VISCtemplates](https://github.com/FredHutch/VISCtemplates) or [VISCfunctions](https://github.com/FredHutch/VISCfunctions) repos been created that would help for future projects?

## Checklist(s)

Use one (or multiple) of the following checklists, depending on which type of PR you are doing.

Note: checklists should be completed before a pull request is submitted for review. You can create a draft pull request before completing the checklist, then complete the checklist, and then mark the PR as ready for review.

### Documentation and completeness (use for all PRs)

- [ ] Necessary context for the project/analysis has been documented
- [ ] Appropriate README.md files have been updated to reflect the latest changes
- [ ] The latest versions of all necessary source files have been pushed to the repo
    - [ ] Unrelated or unnescessary files aren't included (e.g., LaTeX .toc files)

### Code review (use for PRs that include analysis or source code, including any R code)

See also [code review guidelines](https://github.com/FredHutch/VISC-Documentation/blob/main/Programming/code-review-guideline.md)

- [ ]  I have compiled the R Markdown file(s) (or run the relevant R code) with no errors
    - [ ]  Running time has been recorded or estimated: ___________
- [ ]  Code is logically correct
    - [ ]  Joins are correct
    - [ ]  Any filtering is correct and in a logical order
    - [ ]  For PT reports: the analysis code follows the statistical methods section
- [ ]  Appropriate R packages are used
    - [ ]  VISCtemplates and VISCfunctions are used whenever possible
    - [ ]  No local package installations or unnescessary packages
    - [ ]  If renv is used, I have run `renv::status()` and resolved any issues
- [ ]  Code is readable and easy to understand, and follows the [VISC Coding Principles](https://github.com/FredHutch/VISC-Documentation/blob/main/Programming/Coding-Principles.md) document
    - [ ] Lines are at most 100 characters long
    - [ ] Consistent use of `<-` not `=` for assignment
    - [ ] Object names include only alphanumeric characters and underscores (no dots)
    - [ ] Object names are meaningful, descriptive, and unique (avoid overwriting previous variable)
    - [ ] Rmd code chunk names are descriptive and use dashes (not underscores or spaces)
    - [ ] File paths are relative (except for trials and network drive paths) and portable across operating systems (use `file.path()`)
    - [ ] Functions are organized and well-documented, with explanations of purpose, inputs, and ouput
    - [ ] Hard coding and magic numbers are avoided
    - [ ] Comments are helpful and do not include debt (e.g. `# TODO:`) or commented-out backup code

### Peer writing review (use for PRs with PDF and/or Word drafts of PT reports)

See also [writing review guidelines](https://github.com/FredHutch/VISC-Documentation/tree/main/Writing_Reviewing/writing_reviewing_guidelines.md)

- [ ] The latest version of the report has been compiled to both PDF and Word without errors
    - [ ] I've opened and reviewed the compiled PDF document
    - [ ] I've opened and reviewed the compiled Word document
- [ ] There are no obvious Markdown/pandoc/Latex errors 
    - [ ] No broken references (?? or ???) in the text (Use find: “??”)
    - [ ] No blank pages 
    - [ ] Page x out of y is correct (sometimes y is wrong)  
- [ ] The reproducibility tables look correct
    - [ ] The reproducibility tables do not include `NA`, local installations, or unnescessary packages
    - [ ] The most recent versions (note: not the development versions) of VISCtemplates and VISCfunctions are used
- [ ] The report text, including figure and table captions, follows VISC conventions (refer to the [writing guidelines](https://github.com/FredHutch/VISC-Documentation/tree/main/Writing_Reviewing) as needed)
    - [ ] The sample type is accurate (e.g., serum, plasma, PBMC)
    - [ ] Objectives follow the SAP and study protocol
    - [ ] Results and summary sections map to the objectives
    - [ ] Text is spell-checked (including captions and footnotes)
    - [ ] The correct tense is used throughout the report
    - [ ] Capitalization is correct and consistent
    - [ ] Acronyms are introduced the first time they're used within a major section
- [ ] I have reviewed the Results section
    - [ ] Figures and tables are sorted in parallel with results, and figure and table references are correct
    - [ ] Results listed in the text are correct and support my statements
        - [ ] Variables are used in referring to numeric values in the results section (to minimize human error)
- [ ] Figures look right (refer to the [figure guidelines](https://github.com/FredHutch/VISC-Documentation/blob/main/Programming/figure-guidelines.md) as needed)
    - [ ] The appropriate number of axis tick marks is present (at least 3) for each figure
    - [ ] Text is not cut off (facet labels, legends, titles)
- [ ] Tables look right
    - [ ] Text is not running off the page
    - [ ] Significance highlighting is as expected

## Notes

Add any additional notes here.

If necessary, provide explanations here for why any boxes from the checklist(s) above are not checked.

- Reason 1
- Reason 2

## Description

Note: make sure to provide a brief and descriptive pull request (PR) title above.

Here, describe the purpose and content of the PR in more detail.
- Provide context and necessary background information, including links to any supporting documents (e.g., protocol presentation).
- State the overall purpose of this PR.
- Summarize the changes/additions in this PR, focusing on any important details that reviewers should know about.
- Outline important questions for the reviewer (see "Checklist for PR Reviewer" below).
- Mention any known outstanding issues, and if they will be addressed in future PRs.

If you have time, reflect on any key challenges you faced in working on these changes. Were these challenges unique to this project, or do you think they apply to other VISC projects as well? Have any associated issues in the [VISCtemplates](https://github.com/FredHutch/VISCtemplates) or [VISCfunctions](https://github.com/FredHutch/VISCfunctions) repos been created to make things easier next time?

## Checklist for PR Creator

The following checklist should be reviewed and completed before the pull request is marked as ready for review.
(Note: you can create a draft pull request first, then complete the checklist, and then mark the PR as ready for review.)

Any items that are not checked off the list should be noted as outstanding issues in the description above.

### Documentation and completeness

- [ ] I have created and updated appropriate README.md files to reflect the latest changes
- [ ] The latest versions of all relevant files have been pushed to the repo
    - [ ] Unrelated or unnecessary files aren't included (e.g., LaTeX .toc files)

### Code review

See also [code review guidelines](https://github.com/FredHutch/VISC-Documentation/blob/main/Programming/code-review-guideline.md)

- [ ] Commented-out backup code and unused chunks have been removed
- [ ] Comments do not include unaddressed debt (e.g. `# TODO:` or `# FIXME`)
- [ ] Warnings are not suppressed. If a warning must be suppressed there is a clear explanation (i.e., comment).
- [ ] Functions have been organized and documented, with explanations of purpose, inputs, and ouput
- [ ] Hard coding and magic numbers are avoided
- [ ] I have used appropriate R packages where possible
    - [ ] VISCtemplates and VISCfunctions are used as much as possible
    - [ ] I have verified that there are no local package installations
    - [ ] I have reviewed the set of loaded packages (Use find: "library") and removed any that are unnecessary
- [ ] File paths are relative (except for trials and network drive paths) and portable across operating systems (use `file.path()`)  
- [ ] I have reviewed the data processing and statistical analysis code for logical correctness
    - [ ]  I have double-checked any joins
    - [ ]  I have double-checked any filtering and it is in a logical order
    - [ ]  For PT reports: the analysis code follows and agrees with the statistical methods section
- [ ]  I have compiled the R Markdown file(s) (or run the relevant code) after and recent changes, with no errors
    - [ ]  Running time has been recorded or estimated: ___________
- [ ] I have reviewed the code for readability and style with the [VISC Coding Principles](https://github.com/FredHutch/VISC-Documentation/blob/main/Programming/Coding-Principles.md) in mind, including focusing on:
    - [ ] Line lengths (not too long!)
    - [ ] Object names (meaningful, descriptive, unique, alphanumeric characters and underscores only)
    - [ ] Rmd code chunk names (descriptive and use dashes, not underscores or spaces

### Writing/report review (use for PRs with PDF and/or Word drafts of PT reports)

See also [writing review guidelines](https://github.com/FredHutch/VISC-Documentation/tree/main/Writing_Reviewing/writing_reviewing_guidelines.md)

- [ ] The latest version of the report has been compiled to both PDF and Word without errors
    - [ ] I've opened and reviewed the compiled PDF document
    - [ ] I've opened and reviewed the compiled Word document
- [ ] There are no obvious Markdown/pandoc/Latex errors 
    - [ ] No broken references (?? or ???) in the text (Use find: “??”)
    - [ ] No stray warnings or R output in the text (Use find: “#”)
    - [ ] No blank pages 
    - [ ] Page x out of y is correct (sometimes y is wrong)  
- [ ] The reproducibility tables look correct
    - [ ] The reproducibility tables do not include `NA`, local installations, or unnescessary packages
    - [ ] The most recent versions (note: not the development versions) of VISCtemplates and VISCfunctions are used
    - [ ] The data package git hash refers to the correct branch/version (i.e., is up-to-date)
- [ ] The sample type is accurate (e.g., serum, plasma, PBMC)
- [ ] Text has been spell-checked (including captions and footnotes)
- [ ] The report text, including figure and table captions, follows VISC conventions (refer to the [writing guidelines](https://github.com/FredHutch/VISC-Documentation/tree/main/Writing_Reviewing) as needed)
    - [ ] Objectives follow the SAP and study protocol
    - [ ] Results and summary of main results sections map to the objectives
    - [ ] Everything mentioned in the Summary of Main Results is also in the Results section
    - [ ] The correct tense (generally past tense) is used throughout the report
    - [ ] Capitalization is correct and consistent
    - [ ] Acronyms and abbreviations are introduced the first time they are used
- [ ] I have reviewed the results sections carefully and confirmed that the statements in Results section are correct (including p-values) and supported by the correct figure and table references
    - [ ] Code-based methods (i.e., in-line referencing) are used in inserting numeric values in the Results section (to minimize human error)
- [ ] I have reviewed the figures and tables carefully
    - [ ] Figures and tables are sorted in parallel with mentions in Results section
    - [ ] Figures look right (refer to the [figure guidelines](https://github.com/FredHutch/VISC-Documentation/blob/main/Programming/figure-guidelines.md) as needed)
        - [ ] The appropriate number of axis tick marks is present (at least 3) for each figure
        - [ ] Text is not cut off (facet labels, legends, titles)
    - [ ] Tables look right
        - [ ] Text is not running off the page
        - [ ] Significance highlighting is as expected

## Checklist(s) for PR reviewer(s)

Use one (or multiple) of the following checklists, depending on which type of PR this is.
Specific reviewers may be tagged for specific checklist items, if appropriate.

### Documentation and completeness

- [ ] Necessary context for the project/analysis has been documented, and appropriate README.md files appear to be up-to-date
- [ ] The latest versions of all relevant files appear to be pushed to the repo, and no unrelated or unnecessary files are included
- [ ] Git history has clear commit messages
- [ ] No Github PAT or credentials committed

### Code review

- [ ] Order and structure of code is acceptable
    - [ ] Data loading/exclusions/derivations appear early in script
    - [ ] Reusable code is sourced at the top
    - [ ] Derived variables created once, clearly commented, unused ones removed
    - [ ] Hardcoded variables centralized and documented
- [ ] Basic reproducibility 
    - [ ] Random seeds are set using set.seed() (e.g. bootstrap, jitter)
    - [ ] Session info tables or `sessionInfo()` are included
    - [ ] File paths are relative (except for trials and network drive paths) and portable across operating systems
    - [ ] Appropriate R packages are used (VISCtemplates and VISCfunctions are used where possible; no local package installations or apparently unused packages)
    - [ ] `pdata` is loaded from the appropriate data package and matches the expected data hash
    - [ ] Code runs/compiles fully without errors
- [ ] Documentation
    - [ ] Header comment block (name, date, purpose, inputs/outputs, dependencies) exists
    - [ ] Warnings are not suppressed (Use find: “warning=F” or "warning = F"). If a warning must be suppressed there is a clear explanation (i.e., comment).
    - [ ] There are no unused Rmd chunks or commented-out backup code
- [ ] Code appears logically correct
    - [ ]  Sample-level and assay-specific exclusions follow data specs
    - [ ]  I have reviewed any joins and they appear correct (e.g., test for nrow, NAs, duplicates, subsets)
    - [ ]  I have reviewed any filtering and it appears correct (e.g., test for nrow, NAs, duplicates, subsets)
    - [ ]  For PT reports: the analysis code follows the statistical methods section
- [ ]  Code is readable and generally follows the [VISC Coding Principles](https://github.com/FredHutch/VISC-Documentation/blob/main/Programming/Coding-Principles.md)
    - [ ] Lines are not excessively long
    - [ ] Assignment operator `<-` is used consistently (rather than `=`)
    - [ ] Object names are meaningful and descriptive
    - [ ] Object names are consistently formatted and use only alphanumeric characters and underscores (no dots)
    - [ ] Object names are unique (no overwriting of previous variables)
    - [ ] Hard coding and magic numbers are avoided
    - [ ] Rmd code chunk names are descriptive and use dashes (not underscores or spaces)
    - [ ] Functions are used rather than repetitive code
    - [ ] Functions are well-documented (with explanations of purpose, inputs, ouput, examples, etc.)
    - [ ] Sufficient comments are provided to make the code (relatively) easy to understand
    - [ ] Comments are helpful and do not include unaddressed debt (e.g. `# TODO:` or `# FIXME`)


### Report PDF review

- [ ] Report PDF is included and appears to have been rendered after any recent code changes
- [ ] I do not see any obvious Markdown/pandoc/Latex errors
    - [ ] No broken references (?? or ???) in the text (Use find: “??”)
    - [ ] No stray warnings or R output in the text (Use find: “#”)
    - [ ] No blank pages 
    - [ ] Page x out of y is correct (sometimes y is wrong)  
- [ ] Standard reproducibility tables are included and look acceptable
    - [ ] The reproducibility tables do not include `NA`s
    - [ ] No local installations
    - [ ] No seemingly unnescessary packages
    - [ ] The most recent versions (note: not the development versions) of VISCtemplates and VISCfunctions are used
- [ ] I have reviewed the text of the report
    - [ ] The assay name and sample type (e.g., serum, plasma, PBMC) appears to be accurate
    - [ ] There are no obvious spelling errors (including captions and footnotes)
    - [ ] The correct tense (generally past tense) is used throughout the report
    - [ ] Capitalization appears to be correct and consistent
    - [ ] I do not see any acronyms/abbreviations that aren't defined the first time they are used
    - [ ] Objectives agree with the SAP and study protocol
    - [ ] Results and Summary sections are aligned with the objectives
    - [ ] Statements in Results and Summary section appear correct (including p-values) and are supported by the correct figure and table references
    - [ ] Figures and tables are sorted in parallel with mentions in Results section
- [ ] I have reviewed the figures and tables
    - [ ] Figures generally look acceptable (refer to the [figure guidelines](https://github.com/FredHutch/VISC-Documentation/blob/main/Programming/figure-guidelines.md) as needed). For example:
        - [ ] The appropriate number of axis tick marks is present (at least 3) for each figure
        - [ ] Text is not cut off (facet labels, legends, titles)
    - [ ] Tables generally look acceptable. For example:
        - [ ] Text is not running off the page
        - [ ] Significance highlighting is as expected


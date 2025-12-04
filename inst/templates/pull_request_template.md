## Description

Note: make sure to provide a brief and descriptive pull request (PR) title above.

Here, describe the purpose and content of the PR in more detail.
- Provide context and necessary background information, including links to any supporting documents (e.g., protocol presentation).
- State the overall purpose of this PR.
- Summarize the changes/additions in this PR, focusing on any important details that reviewers should know about.
- Outline important questions for the reviewer to address.
- Mention any known outstanding issues, and if they will be addressed in future PRs.

If you have time, reflect on any key challenges you faced in working on these changes. Were these challenges unique to this project, or do you think they apply to other VISC projects as well? Have any associated issues in the [VISCtemplates](https://github.com/FredHutch/VISCtemplates) or [VISCfunctions](https://github.com/FredHutch/VISCfunctions) repos been created to make things easier next time?

## Checklist for PR Creator

- [ ] Project-level README is up-to-date
- [ ] Assay-level README is up-to-date
- [ ] Report-level README is up-to-date (if exists)
- [ ] All relevant files are included and up-to-date (e.g., underlying Rmd files, report pdf/docx files, figure files)
- [ ] Unrelated or unnecessary files are NOT included (e.g., LaTeX files such as .toc and .aux)
- [ ] To the best of my ability, I have followed the [VISC Coding Principles](https://github.com/FredHutch/VISC-Documentation/blob/main/Programming/Coding-Principles.md), including:
    - [ ] Functions are accompanied by comments indicating, at a minimum, what the function is supposed to do, what its inputs are, and what it will return.
    - [ ] Hard coding and magic numbers (if any) have accompanying documentation
    - [ ] No unnecessary R packages are loaded (search code for `library()` calls to review)
    - [ ] The most recent releases of VISCfunctions and VISCtemplates are used (and not the development versions!)
    
- [ ] I have reviewed any report outputs (pdf, docx) for overall formatting and accuracy, including:
    - [ ] Verifying that the report text (summary, results, methods, etc.) is accurate, including updating as needed based on any recent code changes
    - [ ] Text has been spell-checked, including captions and footnotes
    - [ ] Figures and tables look good (including font sizes, colors, readability, captions)
    - [ ] No broken references in the text (Use find: “??”)
    - [ ] No stray warnings or R output in the text (Use find: “#”)
    - [ ] No blank pages 
    - [ ] Page x out of y is correct (sometimes y is wrong)  
    - [ ] Reproducibility tables look correct, including the data package git hash

    
    
- [ ] To the best of my ability, I have followed the [VISC Figure Guidelines](https://github.com/FredHutch/VISC-Documentation/blob/main/Programming/figure-guidelines.md)
- [ ] To the best of my ability, I have followed the [VISC Writing Guidelines](https://github.com/FredHutch/VISC-Documentation/tree/main/Writing_Reviewing), including:
    
    
    
    

### Code review

- [ ] I have Commented-out backup code and unused chunks have been removed
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


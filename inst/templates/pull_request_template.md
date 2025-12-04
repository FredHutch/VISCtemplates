## Description

Note: make sure to provide a brief and descriptive pull request (PR) title above.

Here, describe the overall purpose and content of this PR, including:

-   Providing context and necessary background information, including links to any supporting documents (e.g., protocol presentation).
-   Summarizing additions and changes to the repo, focusing on key details that reviewers should know about.
-   Mentioning any outstanding issues, and if they will be addressed in future PRs.

If you have time, reflect on any key challenges you faced in working on these changes. Were these challenges unique to this project, or do you think they apply to other VISC projects as well? Have any associated issues in the [VISCtemplates](https://github.com/FredHutch/VISCtemplates) or [VISCfunctions](https://github.com/FredHutch/VISCfunctions) repos been created to make things easier next time?

## Checklist for PR Creator

-   [ ] All README files are up-to-date (project-level, assay-level, report-level, etc.)

-   [ ] All appropriate files have been added to the repo and are up-to-date (e.g., underlying Rmd files, report pdf/docx files, figure files) and unrelated or unnecessary files (e.g., LaTeX files such as .toc and .aux) are NOT included.

-   [ ] To the best of my ability, I have followed the [VISC Coding Principles](https://github.com/FredHutch/VISC-Documentation/blob/main/Programming/Coding-Principles.md), including:

    -   [ ] Functions are accompanied by comments indicating, at a minimum, what the function is supposed to do, what its inputs are, and what it will return.
    -   [ ] No unnecessary R packages are loaded (search code for `library()` calls to review)
    -   [ ] The most recent releases of VISCfunctions and VISCtemplates have been installed and used (note: not the development versions!)
    -   [ ] There is no stale code or unaddressed code debt (e.g. `# TODO:` or `# FIXME`, commented-out backup code, unused code chunks)
    -   [ ] Warnings are generally not suppressed, and if a warning must be suppressed there is a clear explanation (i.e., comment)
    -   [ ] Hard coding and magic numbers are generally not used, and if necessary to include, are accompanied by a clear explanation (i.e., comment)

-   [ ] I have reviewed any report outputs (pdf, docx) for overall formatting and accuracy, including:

    -   [ ] Text has been spell-checked, including captions and footnotes
    -   [ ] Figures and tables look good (including font sizes, colors, readability, captions)
    -   [ ] No broken references in the text (Use find: "??")
    -   [ ] No stray warnings or R output in the text (Use find: "\#")
    -   [ ] No blank pages
    -   [ ] Page x out of y is correct (sometimes y is wrong)
    -   [ ] Reproducibility tables look correct, including the data package git hash

Refer to the [VISC figure guidelines](https://github.com/FredHutch/VISC-Documentation/blob/main/Programming/figure-guidelines.md) and [VISC writing guidelines](https://github.com/FredHutch/VISC-Documentation/tree/main/Writing_Reviewing) for additional details on expectations for figures and text in reports.

## Guidance for PR reviewer(s)

Outline important tasks and questions for the reviewer(s) here. The following checklists may be helpful, depending on which type of PR this is. Specific reviewers may be tagged for specific checklist items, if appropriate.

Basics:

-   [ ] Necessary context for the project/analysis has been documented, and appropriate README.md files appear to be up-to-date
-   [ ] The latest versions of all relevant files appear to be pushed to the repo, and no unrelated or unnecessary files are included

Code review: I have reviewed the code and communicated any concerns, including those related to:

-   [ ] Overall organization of code (e.g., purpose of each file, relationship between files, ordering of code within files)
-   [ ] Underlying data sources (e.g., is the latest version of the relevant dataset used?)
-   [ ] Basic reproducibility (e.g., use of random seeds where appropriate, portable and relative file paths)
-   [ ] "Don't repeat yourself" coding principle (e.g., functions are used rather than repetitive code)
-   [ ] Code logic (i.e., overall the code appears to do what is intended without adverse side effects), including:
    -   [ ] Joins and filtering appear to be correct
    -   [ ] Statistical analysis code matches what is described and intended
-   [ ] Code formatting (e.g., line lengths, object names, ...) and documentation (i.e., clarity and inclusion of appropriate level of detail)

Report output document review:

-   [ ] I do not see any obvious markdown/pandoc/latex errors
-   [ ] Standard reproducibility tables are included and look acceptable
    -   [ ] The reproducibility tables do not include `NA`s
    -   [ ] No local installations
    -   [ ] No seemingly unnecessary packages
    -   [ ] The most recent versions (note: not the development versions) of VISCtemplates and VISCfunctions are used
-   [ ] I have reviewed the text of the report and communicated any concerns, including those related to:
    -   [ ] Report header (title, to/from, etc.)
    -   [ ] Spelling and grammar (including acronyms and abbreviations)
    -   [ ] Report outline (i.e., order and structure of sections)
    -   [ ] Agreement between the report and the corresponding SAP and study protocol
    -   [ ] Formatting of figures and tables (including captions)
    -   [ ] Clarity and accuracy of text sections (results, summary, methods, etc.)

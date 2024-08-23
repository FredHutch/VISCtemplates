## Description

Make sure to provide a general summary of your changes in the pull request title.

Here, describe your changes in detail. 

Give a short background on the report, outline important questions or details for the reviewer, and add links to any supporting documents (e.g., protocol presentation). 

It's helpful to add links to the key files with the unique ID for the commit (a.k.a. the "SHA" or "hash").

## Reflection

Describe any key challenges you faced in working on these changes. Were these challenges unique to this project, or do you think they apply to other VISC projects as well? If not unique, have any GitHub issues in the VISCtemplates or VISCfunctions repos been created that would help for future projects?

## Checklist

Use one (or multiple) of the following checklists depending on which type of PR you are doing.

### Code review

See https://github.com/FredHutch/VISC-Documentation/blob/main/Programming/code-review-guideline.md

- [ ]  Necessary context for the analysis is given
- [ ]  R Markdown file compiles (or the R code runs) correctly with no errors
- [ ]  Code is readable and easy to understand
    - [ ]  Code follows the [Coding Principles](https://github.com/FredHutch/VISC-Documentation/blob/main/Programming/Coding-Principles.md) document
        - [ ] Lines are at most 100 characters long
        - [ ] Consistent use of `<-` not `=` for assignment
        - [ ] Object names include only alphanumeric characters and underscores (no dots)
        - [ ] Object names are meaningful, descriptive, and unique (avoid overwriting previous variable)
        - [ ] Rmd code chunk names are descriptive and use dashes (not underscores or spaces)
        - [ ] File paths are relative (except for trials and network drive paths) and portable across operating systems (use `file.path()`)
        - [ ] Functions are organized and well-documented, with explanations of purpose, inputs, and ouput
        - [ ] Hard coding and magic numbers are avoided
    - [ ]  Joins are correct
    - [ ]  Any filtering is correct and in a logical order
    - [ ]  Supporting commentary is helpful and does not include debt or backup comments
- [ ]  Functions are properly documented
- [ ]  The analysis code follows the statistical methods section
- [ ]  VISCtemplates and VISCfunctions are used whenever possible
- [ ]  VISCtemplates and VISCfunctions are installed from GitHub (not local)
- Time estimate: ___________

### PT report / peer writing review

See https://github.com/FredHutch/VISC-Documentation/tree/main/Writing_Reviewing/writing_reviewing_guidelines.md

- [ ] All necessary source files are pushed to the repo and the report has been compiled without errors
    - [ ] Unrelated or unnescessary files aren't included (e.g. Latex .toc files)
    - [ ] I've opened and checked compiled documents (.pdf, .docx)

- [ ] There are no Markdown/pandoc/Latex errors 
    - [ ] No broken references (?? or ???) in the text (Use find: “??”)
    - [ ] There are no blank pages 
    - [ ] Page x out of y is correct (sometimes y is wrong)
     
- [ ] Appropriate versions of R packages are used
    - [ ] The reproducibility tables do not include `NA`, local installations, or unnescessary packages
    - [ ] The most recent versions (note: not the development versions) of VISCtemplates and VISCfunctions are used
    - [ ] If renv is used, I have run `renv::status()` and resolved any issues
     
- [ ] The report text, including figure and table captions, follows the VISC writing guidelines (see https://github.com/FredHutch/VISC-Documentation/tree/main/Writing_Reviewing)
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
         
- [ ] Figures look right and follow the figure guidelines (see https://github.com/FredHutch/VISC-Documentation/blob/main/Programming/figure-guidelines.md)
    - [ ] The appropriate number of axis tick marks is present (at least 3) for each figure
    - [ ] Text is not cut off (facet labels, legends, titles)

- [ ] Tables look right
    - [ ] Text is not running off the page
    - [ ] Significance highlighting is as expected

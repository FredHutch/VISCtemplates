## Description

Make sure to provide a general summary of your changes in the pull request title.

Here, describe your changes in detail. 

Give a short background on the report, outline important questions or details for the reviewer, and add links to any supporting documents (e.g., protocol presentation). 

It's helpful to add links to the key files with the unique ID for the commit (a.k.a. the "SHA" or "hash").

## Checklist

Use one of the following checklists depending on which type of PR you are
doing.

### Peer writing review: see https://github.com/FredHutch/VISC-Documentation/tree/main/Writing_Reviewing/writing_reviewing_guidelines.md

- [ ] There are no Markdown/pandoc/Latex errors 
    - [ ] No broken references (?? or ???) in the text (Use find: “??”)
    - [ ] There are no blank pages 
    - [ ] Page x out of y is correct (sometimes y is wrong)

- [ ] The report adheres to the writing style guide (see https://github.com/FredHutch/VISC-Documentation/tree/main/Writing_Reviewing)
    - [ ] Text is spell-checked (including captions and footnotes)
    - [ ] The correct tense is used throughout the report
    - [ ] Capitalization is correct and consistent
    - [ ] Acronyms are introduced the first time they're used within a major section 
    - [ ] The sample type is accurate (e.g., serum, plasma, PBMC)

- [ ] The writing, including figure and table captions, follow the VISC writing guidelines
    - [ ] Objectives follow the SAP and study protocol
    - [ ] Results and summary sections map to the objectives
    - [ ] Figure and tables are sorted in parallel with results 
    - [ ] Figure and table references, significance highlighting, and results listed in the text are correct and support my statements

- [ ] Figures follow the figure guidelines (see see https://github.com/FredHutch/VISC-Documentation/blob/main/Programming/figure-guidelines.md)
    - [ ] The appropriate number of axis tick marks is present (at least 3) for each figure
    - [ ] Text is not cut off (facet labels, legends, titles)

- [ ] All source files are pushed to the repo and the report compiles without errors
    - [ ] Unrealated or unnescessary files aren't included (e.g. Latex .toc files)
    - [ ] I've opened and checked compiled documents (.pdf, .docx)

- [ ] The reproducibility tables do not include `NA`, local installations, or unnescessary packages

### Code review: see https://github.com/FredHutch/VISC-Documentation/blob/main/Programming/code-review-guideline.md

- [ ]  Necessary context for the analysis is given
- [ ]  R Markdown file compiles (or the R code runs) correctly with no errors
- [ ]  Code is readable and easy to understand
    - [ ]  Code follows the [Coding Principles](https://github.com/FredHutch/VISC-Documentation/blob/main/Programming/Coding-Principles.md) document
    - [ ]  Joins are correct
    - [ ]  Any filtering is correct and in a logical order
    - [ ]  Supporting commentary is helpful and does not include debt or backup comments
- [ ]  Functions are properly documented
- [ ]  The analysis code follows the statistical methods section
- [ ]  VISCtemplates and VISCfunctions are used whenever possible
- [ ]  VISCtemplates and VISCfunctions are installed from GitHub (not local)
- Time estimate: ___________

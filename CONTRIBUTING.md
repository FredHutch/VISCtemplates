
# Contributing to VISCtemplates

Thank you for your interest in contributing to VISCtemplates! 
This package is a common resource for everyone at VISC, and we rely on all of you to keep it running smoothly.
There are several ways you can contribute to making this package the best it can be:

1. **REPORT A BUG** you encounter while using the package as an issue on GitHub so that someone (maybe even you!) can fix it. See below for guidelines on how to file a helpful issue.

2. **PROPOSE AND/OR DISCUSS AN IMPROVEMENT.** Do you have an idea for a new VISCtemplates feature? Take a look at the [GitHub issue list](https://github.com/FredHutch/VISCtemplates/issues) first to see if someone else has proposed something similar. If yes, comment on the issue with your thoughts! If no, create a new issue describing the improvement you would like to see.

3. **UPDATE AND IMPROVE DOCUMENTATION.** Did you notice a typo somewhere in the package? Or think a function could use a better example? Improvements to the documentation are always very welcome! See the development guidelines below for how to create a branch and then a pull request (PR) with your proposed changes.

4. **CONTRIBUTE CODE** to fix a bug or implement a new feature. Before you start, have a look at the issue list and leave a comment on the issue you want to work on - or create a new issue if one doesn't exist yet (for example, if you have a new feature idea). Make sure someone from our team (currently: Bryan, Alicia, Kellie, Dave, Gabby) is happy with your basic proposal for tackling the issue before you start coding. Then get to work! See the development guidelines below for how to create a branch and then a pull request (PR) with your proposed changes.


## Guidelines for filing GitHub issues

When filing an issue, the most important thing is to include a minimal reproducible example (MRE) so whoever is working on the issue can quickly verify the problem, make a plan for how to fix it, and verify that it is fixed once the code has been adapted. There are three things you need to include to make your example reproducible:

1. **Required packages** should loaded at the top of the script.

2. **Example data:** The smaller and simpler, the better! A `data.frame()` with just a handful of rows and columns is ideal. Do NOT share private or confidential data (for example, from a clinical trial you are working on) as part of your example. To help make this step easier, AI tools like GitHub Copilot and ChatGPT are pretty good at generating R code that creates example data - you can prompt them, for example, with the column names you need a dataframe to have and any other critical features.

3. **Code** that illustrates the bug, based on the example data. Spend a little bit of time ensuring that your code is easy for others to read: (1) Make sure you've used spaces and your variable names are concise, but informative. (2) Use comments to indicate where your problem lies. (3) Do your best to remove everything that isn't related to the problem. The shorter your code is, the easier it is to understand.


## Development guidelines for updating code and/or documentation

We follow the [Gitflow](https://nvie.com/posts/a-successful-git-branching-model/) development model and the guidelines from [R packages](https://r-pkgs.org/) by Hadley Wickham and Jenny Bryan. Below are the set of steps to take when updating code and/or documentation. This might feel overwhelming the first time you get set up, but it gets easier and easier with practice!

1. Make sure you have a local copy of the VISCtemplates repo that is fully up-to-date.

     * Run `git clone` and `git pull` as needed.

2. Create a new git branch to make your changes in. The starting point should be the `develop` branch.

     * From the command line, this looks like running: `git checkout develop` then `git pull` (to make sure the development branch is up-to-date) then `git checkout -b my-new-branch-name`

4. Open your local copy of `VISCtemplates.Rproj` and make your changes to code and/or documentation.

6. Check that the package still works. (Ideally, you do this before every commit.)

    * Restart R Session (Cmd+Shift+F10, or Ctrl+Shift+F10 for Windows)
    * Build and Reload (Cmd+Shift+B, or Ctrl+Shift+B for Windows)
    * Test Package with `devtools::test()` (Cmd+Shift+T, or Ctrl+Shift+T for Windows)
    * Document Package with `devtools::document()` (Cmd+Shift+D, or Ctrl+Shift+D for Windows)
    * Check Package with `devtools::check()` (Cmd+Shift+E, or Ctrl+Shift+E for Windows)
<br><br>

7. Push branch to GitHub (`git push`)

   * The first time you do this, you will need to run `git push --set-upstream origin my-new-branch-name` (substituting your actual branch name for `my-new-branch-name`)

9. Create a pull request (PR).

    * In your PR, make sure to clearly state the rationale behind the changes.
    * Request PR reviews from people who are already familar with the issue (if any).
    * Note that you can create a "draft PR" if you want to start the process but you know that the PR is not quite ready for review.

10. Discuss the pull request with package maintainers, iterating until a package maintainer either accepts the PR or decides it's not a good fit for VISCtemplates. The maintainers will use the PR guidelines below to determine if your PR is ready to be accepted.


## Guidelines for pull requests (PRs)

Your pull request should follow these guidelines in order to be accepted:

1. **Has motivation for changes:** Your pull request should clearly and concisely motivate the need for any changes to code or documentation. Link any relevant GitHub issues.

2. **Includes only related changes:** Before you submit your pull request, check to make sure that you haven't accidentally included any unrelated changes. These make it harder to see exactly what's changed, and to evaluate any unexpected side effects. (Note that each PR corresponds to a git branch, so you should create a new, separate branch each time you start working on an unrelated task.)

3. **Follows good coding style:** Please follow the official [tidyverse style guide](https://style.tidyverse.org/) for coding style (note: this does not mean using tidyverse packages - we actually want VISCtemplates to have minimal dependencies on other packages). Maintaining a consistent style across the whole code base makes it much easier to maintain and use. If you're modifying existing VISCtemplates code that doesn't follow the style guide, a separate pull request to fix the style would be greatly appreciated.

4. **Includes documentation:** If you're adding new parameters or a new function, you'll also need to document them with roxygen. Make sure to re-run `devtools::document()` on the code before submitting.

5. **Includes unit tests:** If fixing a bug or adding a new feature, please add a `testthat` unit test to cover the relevant use cases.

6. **Passes continuous integration tests:** We have several continuous integration (CI) tests set up on GitHub. These run automatically on each PR to reduce the risk of introducing breaking changes in the code base. You will see these at the bottom of your PR after it is created - once all checks have passed, it will look like this:
<img width="866" alt="Screenshot 2025-03-24 at 11 30 01 AM" src="https://github.com/user-attachments/assets/014f03d2-ecef-4b02-9374-a71bcf32c05f" />

Basically, the CIs are running tests on varying combinations of operating systems (OS) and versions of R. For example, R-Cmd-check/ubuntu-latest (4.0.4) runs the current code on a linux operating system with R-version 4.0.4, mimicking what is currently on statsrv.
If you are seeing red X's instead of green check marks for any of the CI tests, those will need to be addressed before your PR is accepted. Please reach out to a maintainer if you are unsure about how to approach this.

7. **Updates NEWS.md file:** we track the changes to the package using the NEWS.md file. Please update this with a brief description of your changes and a link to the relevant PR.


## Code of conduct

Please note that VISCtemplates is released with a [Contributor Code of Conduct](CONDUCT.md). By contributing to this project,
you agree to abide by its terms.


## Learn more about package development

Before contributing, you may want to read a bit more about package development in general.

* [Package development workflow with the usethis package by Emil Hvitfeldt](https://www.hvitfeldt.me/blog/usethis-workflow-for-package-development/). (blog post)

* [Writing an R package from scratch by Hilary Parker](https://hilaryparker.com/2014/04/29/writing-an-r-package-from-scratch/) or its [updated version by Tomas Westlake](https://r-mageddon.netlify.com/post/writing-an-r-package-from-scratch/) that shows how to do the same more efficiently using the usethis package. (blog post)

* [You can create an R package in 20 minutes by Jim Hester](https://resources.rstudio.com/rstudio-conf-2018/you-can-make-a-package-in-20-minutes-jim-hester). (conference talk)

* [R packages by Hadley Wickham and Jenny Bryan](https://r-pkgs.org/). (book)

* [Building Tidy Tools](https://blog.rstudio.com/2019/02/06/rstudio-conf-2019-workshops/). (rstudio::conf workshop)

This contributing guide was inspired by and modified from the [ggplot2 contributing.md](ahttps://github.com/tidyverse/ggplot2/blob/master/CONTRIBUTING.md), [rOpenSci's contributing guide](https://devguide.ropensci.org/contributingguide.html), and [this template](https://gist.github.com/peterdesmet/e90a1b0dc17af6c12daf6e8b2f044e7c). 

#' Check for package, install if needed, and load
#'
#' @param packages character vector of package names
#'
#' @return packages will be loaded into environment
#' @export
#'
#' @examples
#' \dontrun{load_install_cran_packages(c("tidyr", "dplyr"))}
install_load_cran_packages <- function(packages) {
  installed_packages <- rownames(utils::installed.packages())
  lapply(packages, FUN = function(package) {
    if (! package %in% installed_packages) {
      if (package %in% c("VISCfunctions", "VISCtemplates")) {
        stop(paste0("The package ", package, " must be installed through GitHub:
                  https://github.com/FredHutch/", package, ".git"))
      } else {
        # provide a default CRAN mirror if missing (e.g. in knitr R session)
        repos <- getOption("repos")
        if ("@CRAN@" %in% repos) repos <- "https://cloud.r-project.org/"
        utils::install.packages(package, repos = repos)
        # install.packages() installs packages from the repository identified in
        # options('repos'), which is CRAN by default. To change this
        # setting, edit your .Rprofile. To view a list of available CRAN
        # mirrors, use command getCRANmirrors(). As of 2024, the most common
        # settings are to use https://cloud.r-project.org which auto-redirects
        # to CRAN mirrors worldwide, or to set up the Posit Public Package
        # Manager <https://packagemanager.posit.co/client/#/repos/cran/setup>,
        # especially for fast install of binary CRAN packages on Linux.
        # See also: <https://github.com/FredHutch/VISCtemplates/pull/163>
      }
    }
    library(package, character.only = TRUE)
  })
  invisible(NULL)
}

#' Check pandoc version
#'
#' @return stops R Markdown report from running if <2.0
#' @export
#'
#' @examples
#' \dontrun{check_pandoc_version()}
#'
check_pandoc_version <- function() {
  if (numeric_version(rmarkdown::pandoc_version()) < numeric_version('2.0'))
    stop('pandoc must be at least version "2.0')
}

#' Cross-reference a figure, table, or section
#'
#' @param ref character string with the reference type and chunk label
#' @param section_name character string with the section name to
#' display for Word output (default is NA)
#'
#' @return inserts a link to a table, figure, or section in a PDF or Word report
#'
#' @details \code{section_name} only used for Word output (pandoc).
#' For Word output, if \code{section_name} is not NA a section reference
#' is created, otherwise a figure or table reference is created.
#'
#' @export
#'
#' @examples
#'
#' \dontrun{insert_ref("tab:my-results")}
#' \dontrun{insert_ref("fig:box-plots")}
#' \dontrun{insert_ref("stats-methods")}
#' \dontrun{insert_ref("stats-methods", "Stats Methods")}
insert_ref <- function(ref, section_name = NA) {
  output_type <- knitr::opts_knit$get('rmarkdown.pandoc.to')
  if (is.null(output_type))
    return(NULL)

  if (output_type == 'latex') {
    paste0('\\ref{', ref, '}')
  } else {
    if (is.na(section_name))
      paste0('\\@ref(', ref, ')')
    else
      paste0('[', section_name, '](#', ref, ')')
  }
}


#' Insert a page break
#'
#' Use this function in your Rmd document to create a page break across PDF or
#' Word output types
#'
#' @return Inserts a page break
#' @export
insert_break <- function() {
  ifelse(knitr::opts_knit$get('rmarkdown.pandoc.to') == 'latex',
         '\\clearpage',
         '\\newpage')
}

#' Insert references section header
#'
#' Conditionally generate a References section header for PDF or DOCX. This
#' ensures that References gets a section number as desired, in PDF by
#' overriding default un-numbering behavior, and in Word by inheriting the
#' section number from the docx template.
#'
#' @return inserts the References section header
#' @export
insert_references_section_header <- function(){
  ifelse(knitr::opts_knit$get('rmarkdown.pandoc.to') == 'latex',
         '\\section{References}',
         '# References')
}

#' Get output type for warnings and markup
#'
#' Use this to set options for warnings or markup when knitting both
#' PDF (Latex) and Word document reports.
#'
#' @return either 'latex' or 'pandoc'
#' @export
#'
#' @examples
#' \dontrun{get_output_type()}
#'
get_output_type <- function() {

  current_output_type <- knitr::opts_knit$get('rmarkdown.pandoc.to')

  # if interactive, set to pandoc for easier visualization
  ifelse(!is.null(current_output_type) && current_output_type == 'latex',
         'latex', 'pandoc')

}

#' Set kable warnings based on output type
#'
#' This can be used to set the `warning` option in R Markdown code chunks to
#' remove warnings created by knitr::kable() when knitting to a Word document.
#'
#' @param output_type character string of document output type
#'
#' @return logical
#' @export
#'
#' @examples
#' \dontrun{
#'
#' kable_warnings <- set_kable_warnings(output_type = get_output_type())
#'
#' ```{r chunk-label, warning=kable_warnings}
#'
#' ```
#'
#' }
set_kable_warnings <- function(output_type) {
  ifelse(output_type == 'latex', TRUE, FALSE)
}

#' Set pandoc markup
#'
#' Use this for conditionally formatting output when knitting both
#' PDF (Latex) and Word document reports.
#'
#' @param output_type character string of document output type
#'
#' @return logical
#' @export
#'
#' @examples
#' \dontrun{
#'
#' pandoc_markup <- set_markup_warnings(output_type = get_output_type())
#'
#' my_results %>%
#'   kable() %>%
#'   cell_spec(pvalue, bold = ifelse(pandoc_markup, TRUE, FALSE))
#'
#' }
set_pandoc_markup <- function(output_type) {
  ifelse(output_type == 'pandoc', TRUE, FALSE)
}

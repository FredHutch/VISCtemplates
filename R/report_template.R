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
  lapply(packages, FUN = function(package) {
    if (!require(package, character.only = TRUE)) {
      if (package %in% c("VISCfunctions", "VISCtemplates")) {
        stop(paste0("The package ", package, " must be installed through GitHub:
                  https://github.com/FredHutch/", package, ".git"))
      } else {
        utils::install.packages(package, repos = "http://cran.us.r-project.org")
      }
    }
    library(package, character.only = TRUE)
  })
}

#' Check pandoc version
#'
#' @return stops R Markdown report from running if <2.0
#' @export
#'
#' @examples
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
#' Use this function in an R Markdown document to insert a page break when you
#' are knitting both PDF (Latex) and Word document reports.
#'
#' @return inserts a page break
#' @export
#'
#' @examples
#' \dontrun{visc_break()}
insert_break <- function() {
  ifelse(knitr::opts_knit$get('rmarkdown.pandoc.to') == 'latex',
         '\\clearpage',
         '#####')
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

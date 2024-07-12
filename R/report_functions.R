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
        utils::install.packages(package)
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

#' Print a pretty table for both PDF and Word
#'
#' Prints a pretty and consistently formatted table for both PDF and Word
#' outputs using the same function. Uses kable for PDF outputs, and flextable
#' for Word and pandoc.
#'
#' @param df
#' @param caption
#' @param caption_short optional short caption for table of conetents. if NULL (default), caption argument is used.
#' @param label label to use for table (alternative to setting label in chunk options)
#' @param fontsize default is 8
#' @param digits default is 3
#' @param longtable TRUE or FALSE
#' @param longtable_clean_cut Used by kableExtra::collapse_rows, default is TRUE
#' @param col_widths_inches Numeric list of column widths in inches.
#' Specify columns in order starting with the first and continuing up to the last column that requires a specified width.
#' An NA at position i in the list means that the width of column i will not be changed from the default.
#' @param collapse_rows list of column numbers to collapse across rows
#' @param bold_rows list of row numbers to make bold
#' @param header Use kableExtra::add_header_above style
#' @param vlines_after list of column numbers to after which to insert vertical lines
#' @param hlines_after list of row numbers to after which to insert horizontal lines
#'
#' @return
#' @export
#'
#' @examples
print_visc_table <- function(df,
                             caption,
                             caption_short = NULL,
                             label = NULL,
                             fontsize = 8,
                             digits = 3,
                             longtable = FALSE,
                             longtable_clean_cut = TRUE,
                             col_widths_inches = NULL,
                             collapse_rows = NULL,
                             bold_rows = NULL,
                             header = NULL,
                             footnote_list = NULL,
                             vlines_after = NULL,
                             hlines_after = NULL) {

  output_type <- get_output_type()

  if (output_type == "latex") {

    tab <- df %>%
      kable(format = output_type,
            longtable = longtable,
            booktabs = TRUE,
            linesep = "",
            escape = FALSE,
            caption = caption,
            caption_short = ifelse(is.null(caption_short), caption, caption_short),
            label = label,
            digits = digits) %>%
      kable_styling(latex_options = c("HOLD_position", "repeat_header"),
                    font_size = fontsize) %>%
      row_spec(0, bold = TRUE) # header is bold

    if (!is.null(bold_rows)) {
      tab <- tab %>% row_spec(bold_rows, bold = TRUE)
    }
    if (!is.null(vlines_after)) {
      tab <- tab %>% column_spec(vlines_after, border_right = TRUE)
    }
    if (!is.null(hlines_after)) {
      tab <- tab %>% row_spec(hlines_after, hline_after = TRUE)
    }
    if (!is.null(col_widths_inches)) {
      for (i in 1:length(col_widths_inches)) {
        if (!is.na(col_widths_inches[i])) {
          tab <- tab %>% column_spec(i, width = paste0(col_widths_inches[i], "in"))
        }
      }
    }
    if (!is.null(collapse_rows)) {

      tab <- tab %>% collapse_rows(collapse_rows,
                                   latex_hline = "full",
                                   row_group_label_position = "identity",
                                   longtable_clean_cut = longtable_clean_cut)
    }
    if (!is.null(header)) {
      tab <- tab %>% add_header_above(header = header)
    }
    if (!is.null(footnote_list)) {
      tab <- tab %>% add_footnote(footnote_list, notation = "number")
    }

  } else {

    tab <- df %>%
      mutate(across(where(is.character),
                    # drop latex-specific slashes
                    function(s) str_replace_all(s, "\\\\", ""))) %>%
      flextable() %>%
      set_caption(caption = caption,
                  autonum = officer::run_autonum(seq_id = "tab", bkm = label))
    if (!is.null(bold_rows)) {
      tab <- tab %>% bold(i = bold_rows)
    }
    if (!is.null(collapse_rows)) {
      tab <- tab %>% merge_v(collapse_rows)
    }
    if (!is.null(vlines_after)) {
      tab <- tab %>% vline(j = vlines_after)
    }
    if (!is.null(hlines_after)) {
      tab <- tab %>% hline(i = hlines_after)
    }
    if (!is.null(col_widths_inches)) {
      for (i in 1:length(col_widths_inches)) {
        if (!is.na(col_widths_inches[i])) {
          tab <- tab %>% flextable::width(i, col_widths_inches[i])
        }
      }
    }
    if (!is.null(header)) {
      tab <- tab %>%
        add_header_row(values = names(header),
                       colwidths = as.numeric(header)) %>%
        align(i = 1, j = NULL, align = "center", part = "header")
    }
    if (!is.null(footnote_list)) {
      tab <- tab %>% footnote(ref_symbols = 1:length(footnote_list),
                              value = as_paragraph(footnote_list))
    }

  }

  tab

}

% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/report_functions.R
\name{insert_references_section_header}
\alias{insert_references_section_header}
\title{Insert references section header}
\usage{
insert_references_section_header()
}
\value{
inserts the References section header
}
\description{
Conditionally generate a References section header for PDF or DOCX. This
ensures that References gets a section number as desired, in PDF by
overriding default un-numbering behavior, and in Word by inheriting the
section number from the docx template.
}

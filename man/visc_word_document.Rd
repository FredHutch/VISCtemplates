% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/visc_output_document.R
\name{visc_word_document}
\alias{visc_word_document}
\title{Convert to a VISC Report Word document}
\usage{
visc_word_document(toc = TRUE, fig_caption = TRUE, keep_md = TRUE, ...)
}
\arguments{
\item{toc}{include table of contents}

\item{fig_caption}{all figure captions}

\item{keep_md}{keep the .md file}

\item{...}{other options to pass to \code{bookdown::word_document2()}}
}
\description{
Runs the VISC Report for Word output based on the word-styles-reference.docx file.
}
\details{
Normally used through \code{output:VISCtemplates::visc_word_document} in the .rmd YAML
}

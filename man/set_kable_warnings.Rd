% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/report_functions.R
\name{set_kable_warnings}
\alias{set_kable_warnings}
\title{Set kable warnings based on output type}
\usage{
set_kable_warnings(output_type)
}
\arguments{
\item{output_type}{character string of document output type}
}
\value{
logical
}
\description{
This can be used to set the \code{warning} option in R Markdown code chunks to
remove warnings created by knitr::kable() when knitting to a Word document.
}
\examples{
\dontrun{

kable_warnings <- set_kable_warnings(output_type = get_output_type())

```{r chunk-label, warning=kable_warnings}

```

}
}

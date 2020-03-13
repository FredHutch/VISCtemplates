find_resource <- function(template, file = 'template.tex', package = "VISCtemplates") {
  res <- system.file(
    "rmarkdown", "templates", template, "resources", file, package = package
  )
  if (res == "") stop(
    "Couldn't find template file ", template, "/resources/", file, call. = FALSE
  )
  res
}

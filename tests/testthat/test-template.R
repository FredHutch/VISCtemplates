local({
  for (report_type in c('generic', 'empty', 'bama', 'nab')){
    for (output_ext in c('pdf', 'docx')){
      test_knit_report(report_type, output_ext)
    }
  }
})

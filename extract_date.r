extract_date = function(text) {
  pattern = "For the.*calendar year, or tax year beginning"

  match = text[str_detect(text, pattern = pattern)]
  
  date = str_replace(match, pattern = ".*ending\\s*", replacement = "") %>%
    str_replace_all("\\s+", " ")
  
  if(length(date) == 0) {
    date = NA
  }
  if(length(date) > 1) {
    date = paste(date, collapse = ";")
  }
  return(date)
}

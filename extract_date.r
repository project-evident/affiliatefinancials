extract_date = function(text) {
  pattern = "For the.*calendar year, or tax year beginning"

  match = text[str_detect(text, pattern = pattern)]
  if(length(match) == 0) match = NA_character_
  
  return(match)
}

extract_date_from_line = function(match) {
  date = match %>%
    str_squish() %>%
    # remove everything from the beginning through "ending "
    str_replace(pattern = ".*ending\\s*", replacement = "") %>%
    # remove everything after the last number
    str_replace(pattern = "[^0-9]+$", replacement = "")
    

  if(length(date) == 0) {
    date = NA_character_
  }
  if(length(date) > 1) {
    date = paste(date, collapse = ";")
  }
  
  date = date %>% 
    str_replace(pattern = "20\\s+19", "2019") %>%
    str_replace(pattern = "20\\s+18", "2018")
  return(date)
}

extract_line5 = function(text) {
  pattern = "Total number of individuals employed in calendar year"

  match = text[str_detect(text, pattern = pattern)] %>% unique
  if(length(match) == 0) match = NA_character_
  return(match)
}


extract_emp_from_line = function(match) {
  emp = 
    match %>% 
    str_replace("line 2a", "") %>%  # prevent some false matches
    str_replace("year 2018", "") %>%
    stringi::stri_extract_last_regex("[0-9]+") %>%
    as.numeric
  if(length(emp) == 0) {
    emp = NA_real_
  }
  return(emp)
}

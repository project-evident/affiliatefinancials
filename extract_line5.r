extract_line5 = function(text) {
  pattern = "Total number of individuals employed in calendar year"

  match = text[str_detect(text, pattern = pattern)] %>% unique
  
  line5 = as.integer(str_extract(match, "[0-9]+$"))
  if(length(line5) == 0) {
    line5 = NA
  }
  # if(length(line5 > 1)) {
  #   return(NA)
  # }
  return(line5)
}

extract_line5_multicol 
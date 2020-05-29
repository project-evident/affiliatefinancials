extract_line5 = function(text) {
  pattern = "Total number of individuals employed in calendar year"

  match = text[str_detect(text, pattern = pattern)]
  
  line5 = as.integer(str_extract(line5_match, "[0-9]+$"))
  if(length(line5) == 0) {
    line5 = NA
  }

  return(line5)
}
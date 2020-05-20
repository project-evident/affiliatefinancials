read_990_pdf = function(pdf) {
  raw_text = pdf_text(pdf = pdf)
  
  if(raw_text == "") {
    ## TODO attempt OCR
  }
  
  text =
    raw_text %>% 
    read_lines() %>%
    str_trim()
  
  return(text)
}


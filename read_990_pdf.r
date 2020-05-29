read_990_pdf = function(pdf) {
  raw_text = pdf_text(pdf = pdf)
  
  if(raw_text == "") {
    ## TODO attempt OCR
    
    ## For now - 
    return("")
  }
  
  text =
    raw_text %>% 
    read_lines() %>%
    str_trim()
  
  return(text)
}


read_990_ocr = function(pdf, pages_tried) {
  if(missing(pages_tried)) {
    ## TODO get doc info
  }
  raw_text = pdf_ocr_text()
}
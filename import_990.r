source("check_hits.r")
source("extract_line5.r")
source("extract_date.r")

library(pdftools)
library(tidyverse)

#' This funciton should takes as input the filepath of a PDF, and returns a list
#' including items 
#'   * text - a list with one item per page, each page item a
#'       character vector with one element per line 
#'   * hits - a data frame with columns page_number (numeric), date_hit (char), date
#'     (char), emp_hit (char), emp (numeric), ocr (boolean) whether OCR was used for the page 
#'   * filepath - the path to the pdf
#'   * status - exit diagnostic
#'   * start_time
#'   * end_time
import_990 = function(filepath, max_ocr_pages = 10){
  start_time = Sys.time()
  
  ## import text
  raw_text = pdf_text(pdf = filepath)
  text = list()
  for(i in seq_along(raw_text)) {
    if(str_detect(raw_text[i], "\\n")) {
      text[[i]] = read_lines(raw_text[i])
    } else {
      text[[i]] = raw_text[i]
    }
  }
  
  text = map(text, str_squish)

  ## set up data frame
  hits = data.frame(
    page = seq_along(text),
    ocr = FALSE
  )
  
  ## check for matches
  hits$emp_hit = map(text, extract_line5)
  hits$date_hit = map(text, extract_date)
  
  hits$emp = map_chr(hits$emp_hit, extract_emp_from_line)
  hits$date = map_chr(hits$date_hit, extract_date_from_line)
  
  ## if matches for both
  ##   return early
  if(check_hits(hits)) {
    return(
      list(text = text, hits = hits, filepath = filepath,
           status = "text match", start_time = start_time, end_time = Sys.time())
    )
  }
  
  ## prioritize pages for OCR
  ### if there is a partial match, only do those page(s)
  ### useful if multiline table structures, unfilled date, or something
  high_likely = which((!is.na(hits$emp) | !is.na(hits$date)) & !hits$ocr)
  
  ### if hit but not match, try those
  ### maybe helps if both not filled in?
  emp_hit_no_match = !is.na(hits$emp_hit) & is.na(hits$emp) & !hits$ocr
  emp_date_no_match = !is.na(hits$date_hit) & is.na(hits$date) & !hits$ocr
  mid_likely = which(emp_hit_no_match | emp_date_no_match)
  mid_likely = setdiff(mid_likely, high_likely)
  
  try_pages = c(high_likely, mid_likely)
  
  ### if no matches, try pages that have no text or short text (likely watermarks)
  if(!length(try_pages)) {
    try_pages = which(lengths(text) < 8 & !hits$ocr)
  }
  
  
  if(!length(try_pages)) {
    return(
        list(text = text, hits = hits, filepath = filepath, 
             status = "not sure what pages to try", start_time = start_time, end_time = Sys.time())
      )
  }
  
  ## don't try OCR on more than max_pages
  try_pages = try_pages[1:max(length(try_pages), max_ocr_pages)]
  
  for(page in try_pages) {
    text[[page]] = pdf_ocr_text(filepath, pages = page) %>%
      read_lines %>%
      str_squish
    hits[page, "ocr"] = TRUE
    
    hits[page, "emp_hit"] = extract_line5(text[[page]])
    hits[page, "date_hit"] = extract_date(text[[page]])
    hits$emp = map_chr(hits$emp_hit, extract_emp_from_line)
    hits$date = map_chr(hits$date_hit, extract_date_from_line)
    
    # lower threshold here - if we are on the right page stop trying more
    if(!is.na(hits[page, "emp_hit"][[1]]) | !is.na(hits[page, "date_hit"][[1]])) {
      return(list(
        text = text,
        hits = hits,
        filepath = filepath,
        status = "ocr match", start_time = start_time, end_time = Sys.time()
      ))
    }
  }

  return(list(
    text = text,
    hits = hits,
    filepath = filepath,
    status = "no match", start_time = start_time, end_time = Sys.time()
  ))
}

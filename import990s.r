# Script to import affiliat 990s
# Collaboration with HFHI
# Simone Boyce and Gregor Thomas
# started 2020-05-014

library(tidyverse)
library(pdftools)


pdf = 'data/Lenawee MI_IRS 990_2019.pdf'

raw_text = pdf_text(pdf = pdf)
# Goal: 
#  Date from Line A
#  Line 5 - number of individuals employed

text =
  raw_text %>% 
  read_lines() %>%
  str_trim()

pattern_line5 = "Total number of individuals employed in calendar year"

line5_match = text[str_detect(text, pattern = pattern_line5)]
line5 = as.integer(str_extract(line5_match, "[0-9]+$"))


pattern_date = "For the.*calendar year, or tax year beginning"

date_match = text[str_detect(text, pattern = pattern_date)]
date = str_replace(date_match, pattern = ".*ending\\s*", replacement = "")
# looking good!

# Now to generalize:

scrape_990 = function(pdf) {
  raw_text = pdf_text(pdf = pdf)
  
  if(raw_text == "") {
    return(data.frame(n_employees = integer(0), date = character(0)))
  }

  text =
  raw_text %>% 
  read_lines() %>%
  str_trim()

  
  # Goal: 
  #  Date from Line A
  #  Line 5 - number of individuals employed


  pattern_line5 = "Total number of individuals employed in calendar year"

  line5_match = text[str_detect(text, pattern = pattern_line5)]
  line5 = as.integer(str_extract(line5_match, "[0-9]+$"))

  pattern_date = "For the.*calendar year, or tax year beginning"

  date_match = text[str_detect(text, pattern = pattern_date)]
  date = str_replace(date_match, pattern = ".*ending\\s*", replacement = "")
  
  return(data.frame(n_employees = line5, date = date))
}

all_990s = list.files(path = "data/")

results = list()
for (i in 1:length(all_990s)) {
  results[[i]] = scrape_990(paste0("data/", all_990s[i]))
}

results = bind_rows(results)

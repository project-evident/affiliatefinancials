# Script to import affiliat 990s
# Collaboration with HFHI
# Simone Boyce and Gregor Thomas
# started 2020-05-014

library(tidyverse)
library(pdftools)


## Try it out on one file #####
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

# Now to generalize:  ####

scrape_990 = function(pdf, debug = FALSE) {
  raw_text = pdf_text(pdf = pdf)
  
  if(debug) {
    browser()
  }
  
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
  if(length(line5) == 0) {
    line5 = NA
  }

  pattern_date = "For the.*calendar year, or tax year beginning"

  date_match = text[str_detect(text, pattern = pattern_date)]
  date = str_replace(date_match, pattern = ".*ending\\s*", replacement = "") %>%
    str_replace_all("\\s+", " ")
  
  if(length(date) == 0) {
    date = NA
  }
  
  return(data.frame(n_employees = line5, date = date))
}

data_dir = "data/"
all_990s = list.files(path = data_dir)
# Alternately, we could put the path to the data files in a variable and use that
# If it starts with "C:/..." or somethign like that, R will be smart
# wd = "C:/Users/..."
# all_990s = list.files(path = wd)

affiliate_name = str_replace(all_990s, pattern = "_.*", "")

results = list()
for (i in 1:length(all_990s)) {
  results[[i]] = scrape_990(paste0(data_dir, all_990s[i]))
}
names(results) = affiliate_name[1:length(results)]

combined_results = bind_rows(results, .id = "affiliate")
combined_results


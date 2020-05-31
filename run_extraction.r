library(tidyverse)
library(pdftools)

# import functions
source("read_990_pdf.r")
source("extract_line5.r")
source("extract_date.r")

# set up data
data_dir = "data/"
all_990s = list.files(path = data_dir)

### let's build a data frame (tibble variant) for results and PDF info:
results = tibble(
  file_name = all_990s,
  file_path = paste0(data_dir, all_990s)
)

# create new column named 'affiliate', and put the affiliate names in it
results$affiliate = str_replace(all_990s, pattern = "_.*", "")

# ## ways to refer to columns
# results[["affiliate"]] # good
# results$affiliate # good
# column = "affiliate" ## column names as variables only works with brackets
# results$column # BAD
# results[[column]] # good for single column 

### get page length
results$pdf_length = map_int(results$file_path, pdf_length)

# # I like using map_* functions for brevity. The above command
# # is equivalent to this:
# results$pdf_length = NA # initialize column
# for(i in 1:nrow(results)) { # fill it in a loop
#   results$pdf_length[i] = pdf_length(results$file_path[i])
# }

### make a list of the imported text
text = map(results$file_path, read_990_pdf)
names(text) = results$file_name # name the list according to the affiliate

# tracking columns
results$no_ocr_needed = map_lgl(text, ~ !identical(., ""))

# run OCR
for(i in 1:length(text)) {
  if(results$no_ocr_needed[i]) {
    next # skip to next iteration if the results are not blank
  }
  text[[i]] = read_990_ocr(results$file_path[i], pages = 1:min(5, results$pdf_length[i]))
}

# Save the imported 990s!
saveRDS(text, "imported_990s.rds")

# check if any blanks remain
any(map_lgl(text, ~ identical(., "")))
# FALSE - good, no blanks

# try to pull numbers
results[!results$text_blank, "date"] = map_chr(text[results$file_name[!results$text_blank]], extract_date)
results[!results$text_blank, "n_emp"] = map_chr(text[results$file_name[!results$text_blank]], extract_line5)

results$date_blank = is.na(results$date) | results$date == ""
results$n_emp_blank = is.na(results$n_emp)


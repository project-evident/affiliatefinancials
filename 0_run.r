library(tidyverse)
library(pdftools)

# import functions
source("import_990.r")

# set up data
data_dir = "data/"
all_990s = list.files(path = data_dir)
paths = list.files(path = "C:/workspace/affiliatefinancials/data/", full.names = TRUE)

affiliate = str_replace(all_990s, pattern = "_.*", "")
state = substr(affiliate, start = nchar(affiliate) - 1, stop = nchar(affiliate))

imports = list()

for (i in 184:length(all_990s)) {
  message("Starting ", all_990s[i])
  try({imports[[i]] = import_990(paths[i])})
  message("  ...", imports[[i]]$status)
}
## issues with 124, 129, 145, 183
# Error in poppler_convert(loadfile(pdf), format, pages, filenames, dpi,  : 
#   Invalid page.
# Error in imports[[i]] : subscript out of bounds
## unfortunately, this doesn't cause an error in R, so `try` doesn't work
## seems to be a nested PDF or something??

names(imports) = all_990s
# some affililates have 2 years, so using file name as identifier

# Save the imported 990s!
saveRDS(imports, "imports.rds")





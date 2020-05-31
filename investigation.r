# Let's check out Bucks

scrape_990(paste0(data_dir, "Bucks County PA_IRS 990_2019.PDF"), debug = TRUE)
# R read it in in columns, with the text on left on three lines, then the text 
# on the right on three more lines


scrape_990(paste0(data_dir, "Choptank MD_IRS 990_2018.pdf"), debug = TRUE)
# similar to Bucks, but a little different, maybe a little nicer'


## Checking out different commands
info_test = pdf_info("data/Peninsula Greater Williamsburg VA_IRS 990_2019.pdf")
str(info_test) 
info_test %>% 
  pluck("metadata") %>%
  str_squish
# Nothing useful here

toc_test = pdf_toc("data/Peninsula Greater Williamsburg VA_IRS 990_2019.pdf")
# more promising!

pdf_length("data/Peninsula Greater Williamsburg VA_IRS 990_2019.pdf")


# Looking more at individuals 

# Albuquerque - seems to be a mix of scanned and electronic pages. OCR was skipped, but 
# need to go back and do it
# ditto Autauga
# ditto Central South Carolina

# Anchorage is a 990-T only. Several affiliates include both 990 and 990-T. Need to find the
# 990-T only ones.
text %>% map_lgl(~!any(str_detect(., "Form 990[^\\-T]"))) %>% which 
# this should match 990 only if not followed by -T
# returns 4 matches, 3 of which are false positives - seems like this is just an Anchorage problem
# won't worry about it more.

# Austin missing date - didn't fill it out on form

# Camden - need to get to page 6




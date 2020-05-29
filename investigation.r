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

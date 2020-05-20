# Let's check out Bucks

scrape_990(paste0(data_dir, "Bucks County PA_IRS 990_2019.PDF"), debug = TRUE)
# R read it in in columns, with the text on left on three lines, then the text 
# on the right on three more lines


scrape_990(paste0(data_dir, "Choptank MD_IRS 990_2018.pdf"), debug = TRUE)
# similar to Bucks, but a little different, maybe a little nicer
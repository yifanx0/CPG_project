# Goal: merge movement (kilts) data with planogram data for each category in POG/kilts folder
# Owen Eagen, Yifan Xu
# 2/14/2018

library(data.table)
setwd("~/Dropbox/RA2/externals/POG/kilts/")

# choose a category (loop)
prod_cat = "cer"
target_dir = paste0(prod_cat, "/")
zip_name = paste0(target_dir, "w", prod_cat, ".zip")
temp_dir = tempdir()   # temporary directory to store wxxx.csv

# unzip move and read in data
unzip(zipfile = zip_name, exdir = temp_dir)
move_file = paste0(temp_dir, "/w", cat, ".csv")
plano_file = paste0(target_dir, "w", cat, "sh.csv")
move = fread(move_file)
plano = fread(plano_file, drop = c(1))

# merge (/clean) dataset and write
dt = merge(move, plano, by = c("UPC", "STORE", "WEEK"), suffixes = c("_m", "_p"))
# columns with suffix "_m" come from wxxx (move), "_p" come from wxxxsh (plano)
merge_file = paste0(target_dir, "/", prod_cat, "_merge.csv")
write.csv(dt, file = merge_file, row.names = FALSE)

#c lose zip folder
unlink(temp_dir, recursive = TRUE)

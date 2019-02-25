# Goal: merge movement (kilts) data with planogram data for each category in POG/kilts folder
# Owen Eagen, Yifan Xu
# 2/14/2018

library(data.table)
setwd("~/Dropbox/RA2/externals/POG/kilts/")

# choose a category (loop)
prod_cats = c("cso", "cer", "ptw", "did", "tpa", "rfj", 
              "bjc", "tna", "tti", "tbr")

# for these categories, R threw an error when trying to read in the move dataset
PROBLEM_CATS = c("ana", "ora")

# create merge file for each category and also move upc in
for (prod_cat in prod_cats) {
  ## MERGE
  target_dir = paste0(prod_cat, "/")
  zip_name = paste0(target_dir, "w", prod_cat, ".zip")
  temp_dir = tempdir()   # temporary directory to store wxxx.csv
  # unzip move and read in data
  unzip(zipfile = zip_name, exdir = temp_dir)
  move_file = paste0(temp_dir, "/w", prod_cat, ".csv")
  plano_file = paste0(target_dir, "w", prod_cat, "sh.csv")
  move = fread(move_file)
  plano = fread(plano_file, drop = c(1))
  
  # inner merge dataset and write
  dt = merge(move, plano, by = c("UPC", "STORE", "WEEK"), 
             suffixes = c("_m", "_p"))
  # NOTE: columns with suffix "_m" come from wxxx (move), "_p" come from wxxxsh (plano)
  
  # rhe following two lines are wrong; need to figure out how to write files to zip
  target_file = paste0(target_dir, prod_cat, "_merge.csv")
  write.csv(dt, file = target_file, row.names = FALSE)
  
  ## MOVE UPC IN
  zip_file_dir = "~/Dropbox/RA2/externals/POG/data_csv/dff_csv.zip"
  upc_filename = paste0("upc", prod_cat, ".csv")
  unzip(zip_file_dir, files = c(upc_filename), exdir = target_dir)
}

# close temp folder
unlink(temp_dir, recursive = TRUE)
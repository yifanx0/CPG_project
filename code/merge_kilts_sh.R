# Goal: merge movement (kilts) data with planogram data for each category in POG/kilts folder
# Owen Eagen, Yifan Xu

library(data.table)
setwd("~/Dropbox/RA2/externals/POG/kilts/")

# choose a category (loop)
cat = "ana"
move_file = paste0("/", cat, "/w", cat, ".csv")
plano_file = paste0(cat, "/w", cat, "sh.csv")

# unzip move and read in data
unzip(zipfile = paste0("/", cat, "/w", cat, ".zip"), 
      exdir = paste0("~/Dropbox/RA2/externals/POG/kilts/", cat))
move = fread(move_file)
plano = fread(plano_file)

# merge (/clean) dataset and write

#c lose zip folder
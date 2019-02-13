# date: 2019/02/13
# goal: to download raw movement csv data (zipped) from kilts to dropbox

library(data.table)

## experimenting
##setwd("~/Desktop/Econ_Research/2018_fall_CPG/CPG_data")
# wdid_url = paste0("https://www.chicagobooth.edu", 
# "/-/media/enterprise/centers/kilts/datasets/dominicks-dataset/movement_csv-files/wdid.zip")
# download.file(wdid_url, "wdid.zip")
# unzip("wdid.zip")

setwd("~/Dropbox/RA2/externals/POG/kilts")
prod_cats = c("cso", "cer", "ptw", "did", "tpa", "rfj", 
              "bjc", "tna", "ana", "tti", "ora", "tbr")

for (prod_cat in prod_cats) {
  prod_url = paste0("https://www.chicagobooth.edu", 
                    "/-/media/enterprise/centers/kilts/datasets/dominicks-dataset/movement_csv-files/w",
                    prod_cat,
                    ".zip")
  zip_name = paste0("w", prod_cat, ".zip")
  download.file(prod_url, zip_name)
}

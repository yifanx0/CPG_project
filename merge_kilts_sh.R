setwd("~/Dropbox/RA2/externals/POG/kilts/")

prod_cat = "cer"
target_dir = paste0(prod_cat, "/")
zip_name = paste0(target_dir, "w", prod_cat, ".zip")
unzip(zip_name, exdir = target_dir)
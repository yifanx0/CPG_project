# date: 2019/02/13
# goal: to put wxxxsh.csv files into target directory

prod_cats = c("cso", "cer", "ptw", "did", "tpa", "rfj", 
              "bjc", "tna", "ana", "tti", "ora", "tbr")
zip_file_dir = "~/Dropbox/RA2/externals/POG/data_csv/dff_csv.zip"
target_dir = "~/Dropbox/RA2/externals/POG/kilts"
file_names = c()
for (prod_cat in prod_cats) {
  file_name = paste0("w", prod_cat, "sh.csv")
  dir.create(paste0(target_dir, "/", prod_cat))
  prod_target_dir = paste0(target_dir, "/", prod_cat)
  unzip(zip_file_dir, file_name, exdir = prod_target_dir)
}

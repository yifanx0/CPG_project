# date: 11/29/2018
# author: Yifan Xu
# goal: to extract upc description data for some specified product from 
  # externals/POG/data_csv/OMNI_csv.zip
##==============================================================================

extract_upc_descr = function(prod_name, prod_abbr) {
  # to apply this function, simply put the product name and product abbreviation
  # as the inputs
  # e.g. extract_upc_descr("detergent", "did")
  # the "oupcxxx.csv" will be saved to the target directory
  # Note: to successfully run this function, the target directory (i.e. the raw 
  # folder) does not need to exist beforehand
  zip_file_dir = "~/Dropbox/RA2/externals/POG/data_csv/OMNI_csv.zip"
  target_dir = paste0("~/Dropbox/RA2/externals/POG_cleaning/OMNI_cleaning/OMNI_", 
                      prod_name, "/OMNI_", prod_name, "_raw")
  dir.create(target_dir, showWarnings = FALSE)
  file_name = paste0("oupc", prod_abbr, ".csv")
  unzip(zip_file_dir, files = file_name, exdir = target_dir)
  old_file_path = paste0(target_dir, "/", file_name)
  new_file_path = paste0(target_dir, "/upc_descr_", prod_name, ".csv")
  file.rename(old_file_path, new_file_path)  
  # this will return TRUE in the console if successful
}

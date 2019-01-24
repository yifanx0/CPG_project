# goal: to extract data for some specified product from 
# externals/POG/data_csv/dff_csv.zip
##==============================================================================

extract_upc_descr = function(prod_name, prod_abbr) {
  # to apply this function, simply put the product name and product abbreviation
  # as the inputs
  # e.g. extract_upc_descr("detergent", "did")
  # the "upcxxx.csv" will be saved to the target directory
  # Note: to successfully run this function, the target directory (i.e. the raw 
  # folder) does not need to exist beforehand
  zip_file_dir = "~/Dropbox/RA2/externals/POG/data_csv/dff_csv.zip"
  target_dir = paste0("~/Dropbox/RA2/externals/POG_cleaning/dff_cleaning/dff_", 
                      prod_name, "/dff_", prod_name, "_raw")
  dir.create(target_dir, showWarnings = FALSE)
  file_name = paste0("upc", prod_abbr, ".csv")
  unzip(zip_file_dir, files = file_name, exdir = target_dir)
  old_file_path = paste0(target_dir, "/", file_name)
  new_file_path = paste0(target_dir, "/upc_descr_", prod_name, ".csv")
  file.rename(old_file_path, new_file_path)  
  # this will return TRUE in the console if successful
}

extract_movement = function(prod_name, prod_abbr) {
  # to apply this function, simply put the product name and product abbreviation
  # as the inputs
  # e.g. ("detergent", "did")
  # the "wxxx.csv" will be saved to the target directory
  # Note: to successfully run this function, the target directory (i.e. the raw 
  # folder) does not need to exist beforehand
  zip_file_dir = "~/Dropbox/RA2/externals/POG/data_csv/dff_csv.zip"
  target_dir = paste0("~/Dropbox/RA2/externals/POG_cleaning/dff_cleaning/dff_", 
                      prod_name, "/dff_", prod_name, "_raw")
  dir.create(target_dir, showWarnings = FALSE)
  file_name = paste0("w", prod_abbr, ".csv")
  unzip(zip_file_dir, files = file_name, exdir = target_dir)
  old_file_path = paste0(target_dir, "/", file_name)
  new_file_path = paste0(target_dir, "/movement_", prod_name, ".csv")
  file.rename(old_file_path, new_file_path)  
  # this will return TRUE in the console if successful
}

extract_planogram = function(prod_name, prod_abbr) {
  # to apply this function, simply put the product name and product abbreviation
  # as the inputs
  # e.g. ("detergent", "did")
  # the "wxxx.csv" will be saved to the target directory
  # Note: to successfully run this function, the target directory (i.e. the raw 
  # folder) does not need to exist beforehand
  zip_file_dir = "~/Dropbox/RA2/externals/POG/data_csv/dff_csv.zip"
  target_dir = paste0("~/Dropbox/RA2/externals/POG_cleaning/dff_cleaning/dff_", 
                      prod_name, "/dff_", prod_name, "_raw")
  dir.create(target_dir, showWarnings = FALSE)
  file_name = paste0('w', prod_abbr, 'sh.csv')
  unzip(zip_file_dir, files = file_name, exdir = target_dir)
  old_file_path = paste0(target_dir, "/", file_name)
  new_file_path = paste0(target_dir, "/plano_", prod_name, ".csv")
  file.rename(old_file_path, new_file_path)  
  # this will return TRUE in the console if successful
}

# Goal: Extract the above three files for each of the 12 product categories which have planogram information.

prods_with_plano = c()

# for loop over vector with prod abbr and prod name, running each of the three functions
  

prods_with_plano = c()

# date: 11/20/2018
# author: Yifan Xu
# goal: to extract sas data from RA2/externals/POG directory and save as a .zip 
  # file containing data in .csv
##==============================================================================

# the function to do the work
extract_save = function(zip_file_dir, target_dir) {
  # input: 
    # zip_file_dir: full directory of the .zip file
      # e.g. "~/Dropbox/RA2/externals/POG/IRI.zip"
    # target_dir: directory of the target folder to put the .csv files in
      # e.g. "~/Dropbox/RA2/externals/POG/data_csv"
      # note: target_dir must already exist for this function to run properly
  
  temp_dir = tempdir()
  unzip(zip_file_dir, exdir = temp_dir)
  # to get the part of the folder name before ".zip"
  folder_name = gsub(".zip", "", basename(zip_file_dir))
  folder_dir = paste0(temp_dir, "/", folder_name)
  file_names = list.files(path = folder_dir, pattern = ".sas7bdat")
  temp_csv_folder = paste0(temp_dir, "/", folder_name, "_csv")
  dir.create(temp_csv_folder)
  for (file_name in file_names) {
    df = haven::read_sas(paste0(folder_dir, "/", file_name))
    # to get the part of the file name before the extention
    file_name_short = gsub(".sas7bdat.*", "", file_name)
    write.csv(df, file = paste0(temp_csv_folder, "/", file_name_short, ".csv"))
  }
  
  zip_csv_folder = paste0(target_dir, "/", folder_name, "_csv.zip")
  zip(zip_csv_folder, temp_csv_folder, extras = "-j")
  
  unlink(temp_dir, recursive = TRUE)
  message("The zip file ", zip_csv_folder, " is created.")
}

# call the function on the .zip files in directory except for src.zip
  # which contains subdirectory
target_dir = "~/Dropbox/RA2/externals/POG/data_csv"
list_zip = c("PID", "IRI", "OMNI", "OMNIIRI", "dff")
for (zip_file in list_zip) {
  zip_file_dir = paste0("~/Dropbox/RA2/externals/POG/", zip_file, ".zip")
  extract_save(zip_file_dir, target_dir)
}

# now deal w/ src.zip separately
list_src_sub = c("AGG", "aggregate", "DICT")

## src.zip first layer of subdirectory
for (src_sub in list_src_sub) {
  temp_dir = tempdir()
  zip_file_dir = paste0("~/Dropbox/RA2/externals/POG/src.zip")
  unzip(zip_file_dir, exdir = temp_dir)
  # to get the part of the folder name before ".zip"
  folder_name = src_sub
  folder_dir = paste0(temp_dir, "/src/", folder_name)
  file_names = list.files(path = folder_dir, pattern = ".sas7bdat")
  temp_csv_folder = paste0(temp_dir, "/src_", folder_name, "_csv")
  dir.create(temp_csv_folder)
  for (file_name in file_names) {
    df = haven::read_sas(paste0(folder_dir, "/", file_name))
    # to get the part of the file name before the extention
    file_name_short = gsub(".sas7bdat.*", "", file_name)
    write.csv(df, file = paste0(temp_csv_folder, "/", file_name_short, ".csv"))
  }
  
  target_dir = "~/Dropbox/RA2/externals/POG/data_csv/src_csv"
  zip_csv_folder = paste0(target_dir, "/src_", folder_name, "_csv.zip")
  zip(zip_csv_folder, temp_csv_folder, extras = "-j")
  
  unlink(temp_dir, recursive = TRUE)
  message("The zip file ", zip_csv_folder, " is created.")
}


## src.zip second layer of subdirectory

### "src/AGG"'s subdirectory
list_src_AGG_sub = c("old", "PID")
for (AGG_sub in list_src_AGG_sub) {
  temp_dir = tempdir()
  zip_file_dir = paste0("~/Dropbox/RA2/externals/POG/src.zip")
  unzip(zip_file_dir, exdir = temp_dir)
  # to get the part of the folder name before ".zip"
  folder_name = AGG_sub
  folder_dir = paste0(temp_dir, "/src/AGG/", folder_name)
  file_names = list.files(path = folder_dir, pattern = ".sas7bdat")
  temp_csv_folder = paste0(temp_dir, "/src_AGG_", folder_name, "_csv")
  dir.create(temp_csv_folder)
  for (file_name in file_names) {
    df = haven::read_sas(paste0(folder_dir, "/", file_name))
    # to get the part of the file name before the extention
    file_name_short = gsub(".sas7bdat.*", "", file_name)
    write.csv(df, file = paste0(temp_csv_folder, "/", file_name_short, ".csv"))
  }
  
  target_dir = "~/Dropbox/RA2/externals/POG/data_csv/src_csv"
  zip_csv_folder = paste0(target_dir, "/src_AGG_", folder_name, "_csv.zip")
  zip(zip_csv_folder, temp_csv_folder, extras = "-j")
  
  unlink(temp_dir, recursive = TRUE)
  message("The zip file ", zip_csv_folder, " is created.")
}

### "src/aggregate"'s subdirectory: "old"
temp_dir = tempdir()
zip_file_dir = paste0("~/Dropbox/RA2/externals/POG/src.zip")
unzip(zip_file_dir, exdir = temp_dir)
# to get the part of the folder name before ".zip"
folder_name = "old"
folder_dir = paste0(temp_dir, "/src/aggregate/", folder_name)
file_names = list.files(path = folder_dir, pattern = ".sas7bdat")
temp_csv_folder = paste0(temp_dir, "/src_aggregate_", folder_name, "_csv")
dir.create(temp_csv_folder)
for (file_name in file_names) {
  df = haven::read_sas(paste0(folder_dir, "/", file_name))
  # to get the part of the file name before the extention
  file_name_short = gsub(".sas7bdat.*", "", file_name)
  write.csv(df, file = paste0(temp_csv_folder, "/", file_name_short, ".csv"))
}

target_dir = "~/Dropbox/RA2/externals/POG/data_csv/src_csv"
zip_csv_folder = paste0(target_dir, "/src_aggregate_", folder_name, "_csv.zip")
zip(zip_csv_folder, temp_csv_folder, extras = "-j")

unlink(temp_dir, recursive = TRUE)
message("The zip file ", zip_csv_folder, " is created.")

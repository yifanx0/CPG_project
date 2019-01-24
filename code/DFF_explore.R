# exploring code for DFF
library('data.table')

zip_file_dir = "~/Dropbox/RA2/externals/POG/data_csv/DFF_csv.zip"
file_list = unzip(zip_file_dir, list = TRUE)
file_list
csv_files = file_list[1:2, 1]
temp_dir = tempdir()
unzip(zip_file_dir, files = csv_files, exdir = temp_dir)
dt_1 = fread(paste0(temp_dir, "/", csv_files[1]))
dt_2 = fread(paste0(temp_dir, "/", csv_files[2]))
unlink(tempdir(), recursive = TRUE)
head(dt_1)
head(dt_2)
nrow(dt_1[!is.na(DACVFD)])
dt_1_complete = dt_1[complete.cases(dt_1)]
head(dt_1_complete)
View(dt_1_complete)
for (i in 4:ncol(dt_1)) {
  message("the unique values in column ", colnames(dt_1)[i], " are:")
  print(unique(dt_1[, i:i]))
}
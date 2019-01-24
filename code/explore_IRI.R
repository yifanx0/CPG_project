# date: 11/27/2018
# author: Yifan Xu
# goal: to explore data from RA2/externals/POG/data_csv/IRI_csv.zip
##==============================================================================

# this code deals with IRI_csv.zip but is extendable to other folders
library(data.table)

zip_file_dir = "~/Dropbox/RA2/externals/POG/data_csv/IRI_csv.zip"
# take a look at the files contained in zip
file_list = unzip(zip_file_dir, list = TRUE)
file_list
# choose two csv files to explore
csv_files = file_list[1:2, 1]
# csv_files = c("oupcdid.csv", "owdid.csv")
temp_dir = tempdir()
unzip(zip_file_dir, files = csv_files, exdir = temp_dir)
dt_1 = fread(paste0(temp_dir, "/", csv_files[1]))
dt_2 = fread(paste0(temp_dir, "/", csv_files[2]))
unlink(tempdir(), recursive = TRUE)
head(dt_1)
head(dt_2)
colnames(dt_1)
colnames(dt_2)
## notice that there are a lot of NA's in the dt
nrow(dt_1[!is.na(DACVFD)])
dt_1_complete = dt_1[complete.cases(dt_1)]
head(dt_1_complete)
## look at unique values for each col
for (i in 4:ncol(dt_1)) {
  message("the unique values in column ", colnames(dt_1)[i], " are:")
  print(unique(dt_1[, i:i]))
}


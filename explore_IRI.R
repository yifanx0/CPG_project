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
temp_dir = tempdir()
unzip(zip_file_dir, files = csv_files, exdir = temp_dir)
dt_1 = fread(paste0(temp_dir, "/", csv_files[1]))
dt_2 = fread(paste0(temp_dir, "/", csv_files[2]))
unlink(tempdir(), recursive = TRUE)

head(dt_1)
head(dt_2)
## notice that there are a lot of NA's in the dt
nrow(dt_1[!is.na(DACVFD)])
dt_1_complete = dt_1[complete.cases(dt_1)]
head(dt_1_complete)
View(dt_1_complete)
## look at unique values for each col
for (i in 4:ncol(dt_1)) {
  message("the unique values in column ", colnames(dt_1)[i], " are:")
  print(unique(dt_1[, i:i]))
}

## trying to figure out meaning of variable names by looking at relationship b/w
## variables
var_1 = "DINCREM"
var_2 = "MINCREM"
var_3 = "DCINCREM"
var_4 = "MCINCREM"
dt_1_partial_complete = dt_1[complete.cases(dt_1[, .(var_1, var_2, var_3, var_4)])]
nrow(dt_1_partial_complete)
nrow(dt_1_partial_complete[DINCREM <= MINCREM])
nrow(dt_1_partial_complete[DCINCREM >= DINCREM])

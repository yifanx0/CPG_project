# date: 1/21/2019
# author: Yifan Xu
# goal: to replicate the results in Dreze et al. paper using dff datasets
# taking dish detergents as an example
##==============================================================================

library(data.table)

# space-to-movement results (table 1 in paper)

## first unzip the relevant datasets to a local directory for future reference
zip_file_dir = "~/Dropbox/RA2/externals/POG/data_csv/dff_csv.zip"
target_dir = "~/Desktop/Econ_Research/2018_fall_CPG/CPG_data"
files_to_unzip = c("wdidsh.csv", "wdid.csv") # b/c I think these two are relevant
unzip(zip_file_dir, files = files_to_unzip, exdir = target_dir)

## now load the datasets
setwd(target_dir)
wdidsh = fread("wdidsh.csv")
wdid = fread("wdid.csv")

## get the column names for each dataset
colnames_wdidsh = colnames(wdidsh)
colnames_wdid = colnames(wdid)

## get the weeks covered in each dataset
weeks_wdidsh = unique(wdidsh$WEEK)
weeks_wdid = unique(wdid$WEEK)
vector_inclusion(weeks_wdidsh, weeks_wdid) # uses the helper function at the bottom

## get the stores covered in each dataset
stores_wdidsh = unique(wdidsh$STORE)
stores_wdid = unique(wdid$STORE)
vector_inclusion(stores_wdidsh, stores_wdid)

## get the weeks covered in each dataset for each store in stores_wdidsh
### wdidsh
store_week_wdidsh = data.table(STORE = integer(),
                               WEEK = integer(),
                               NUM_WEEKS = integer())
for (store in stores_wdidsh) {
  weeks = unique(wdidsh[STORE == store & EXPER == 1]$WEEK)
  for (week in weeks) {
    store_week_wdidsh = rbind(store_week_wdidsh, list(store, week, length(weeks)))
  }
}
store_week_wdidsh = store_week_wdidsh[order(STORE, WEEK)]
### wdid
store_week_wdid = data.table(STORE = integer(),
                               WEEK = integer(),
                               NUM_WEEKS = integer())
for (store in stores_wdidsh) {
  weeks = unique(wdid[STORE == store & OK == 1]$WEEK)
  for (week in weeks) {
    store_week_wdid = rbind(store_week_wdid, list(store, week, length(weeks)))
  }
}
store_week_wdid = store_week_wdid[order(STORE, WEEK)]

## saving the summary tables to working directory
write.csv(store_week_wdidsh, file = "store_week_wdidsh.csv")
write.csv(store_week_wdid, file = "store_week_wdid.csv")

##------------------------------------------------------------------------------
# helper functions

## vector_inclusion(short_vector, long_vector)
## to check whether every entry in a vector is included in another; if not, 
## print out a message
## note that the order of the vectors are important for this function
## note that if nothing is returned w/ this function, it means every element in 
## the vector checked is in the other
vector_inclusion = function(short_vector, long_vector) {
  if (length(short_vector) > length(long_vector)) {
    warning("the length of `short_vector` is larger than that of `long_vector`, ",
            "the function checks whether every element in `short_vector` is ",
            "covered in `long_vector`.",
            call. = FALSE, immediate. = TRUE)
  }
  for (element in short_vector) {
    if (!(element %in% long_vector)) {
      message(element, " is not in the other vector!")
    }
  }
}

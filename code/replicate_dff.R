# date: 1/21/2019
# author: Yifan Xu, Owen Eagen
# goal: to replicate the results in Dreze et al. paper using dff datasets
# taking dish detergents as an example
##==============================================================================

library(data.table)

# space-to-movement results (table 1 in paper)

# set a category to look at
cat = "cer"     # category code, cer = cereal
plano_file = paste0("w", cat, "sh.csv")
move_file = paste0("w", cat, ".csv")

## first unzip the relevant datasets to a local directory for future reference
zip_file_dir = "~/Dropbox/RA2/externals/POG/data_csv/dff_csv.zip"
target_dir = "~/Desktop/Research/CPG"
files_to_unzip = c(move_file, plano_file) 
unzip(zip_file_dir, files = files_to_unzip, exdir = target_dir)

## now load the datasets
setwd(target_dir)
plano = fread(plano_file)
move = fread(move_file)

## get the column names for each dataset
colnames_plano = colnames(plano)
colnames_move = colnames(move)

## get the weeks covered in each dataset
weeks_plano = unique(plano$WEEK)
weeks_move = unique(move$WEEK)
vector_inclusion(weeks_plano, weeks_move) # uses the helper function at the bottom

## get the stores covered in each dataset
stores_plano = unique(plano$STORE)
stores_move = unique(move$STORE)
vector_inclusion(stores_plano, stores_move)

## get the weeks covered in each dataset for each store in stores_wdidsh
### planogram dataset
store_week_plano = data.table(STORE = integer(),
                               WEEK = integer(),
                               NUM_WEEKS = integer())
for (store in stores_plano) {
  weeks = unique(plano[STORE == store & EXPER == 1]$WEEK)
  for (week in weeks) {
    store_week_plano = rbind(store_week_plano, list(store, week, length(weeks)))
  }
}
store_week_plano = store_week_plano[order(STORE, WEEK)]
### movement dataset
store_week_move = data.table(STORE = integer(),
                               WEEK = integer(),
                               NUM_WEEKS = integer())
for (store in stores_plano) {
  weeks = unique(move[STORE == store & OK == 1]$WEEK)
  for (week in weeks) {
    store_week_move = rbind(store_week_move, list(store, week, length(weeks)))
  }
}
store_week_move = store_week_move[order(STORE, WEEK)]

## saving the summary tables to working directory
write.csv(store_week_plano, file = paste0("store_week_w", cat, "sh.csv"))
write.csv(store_week_move, file = paste0("store_week_w", cat, ".csv"))

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

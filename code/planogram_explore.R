# explore the planogram files, want to determine:
# 1) is this a subset of the store, week, upc that are in movement? (file is smaller)
# 2) is this a merged file which already contains the movement data?

library('data.table')
#Pick a product category
category = 'detergent'

# set appropriate directory and read in the planogram and movement files
setwd(paste0("~/Dropbox/RA2/externals/POG_cleaning/dff_cleaning/dff_", category, "/dff_", category, "_raw"))

dt = read.csv(paste0('plano_', category, '.csv'), stringsAsFactors = FALSE, row.names = NULL)
dt = as.data.table(dt)

movements = fread(paste0('movement_', category, '.csv'), sep="auto", sep2=NULL,
                  nrows=-1L, header=TRUE, na.strings=c("", "."), 
                  stringsAsFactors=FALSE, verbose=TRUE, autostart=30L,
                  drop=NULL,
                  showProgress=TRUE, data.table = TRUE)

# count total unique stores in each dataset
m = length(unique(dt$STORE))
n = length(unique(movements$STORE))
print(paste("In total, there are", n, "unique store IDs in the movement dataset, but only", m,
              "unique store IDs in the planogram dataset."))

# count the total unique UPCs in each dataset
m = length(unique(dt$UPC))
n = length(unique(movements$UPC))
print(paste("In total, there are", n, "unique UPCs in the movement dataset, but only", m,
            "unique UPCs in the planogram dataset."))

# count the total unique wweks in each dataset
m = length(unique(dt$WEEK))
n = length(unique(movements$WEEK))
print(paste("In total, there are", n, "unique weeks in the movement dataset, but only", m,
            "unique weeks in the planogram dataset."))

print(sort(unique(dt$WEEK)))

# count the number of unique stores IDs for which we have planogram info, for each product UPC
count_num_stores = dt[, .(distinct_stores = length(unique(STORE))), by = UPC]
count_num_stores_mv = movements[, .(distinct_stores = length(unique(STORE))), by = UPC]
count_stores = merge(count_num_stores, count_num_stores_mv, by = 'UPC', all = FALSE, 
                     suffixes = c('_plano', '_mv'))

hist(count_stores$distinct_stores_plano)
### Observation: This histogram shows that for almost every UPC, there are over 50 unique stores in which
# planogram information was observed.

# for each upc/store, count number of unique weeks in which planogram info was observed
count_weeks = dt[, .(distinct_weeks = length(unique(WEEK))), by = .(UPC, STORE)]
hist(count_weeks$distinct_weeks)

### Observation: This histogram is noticeably left skewed, however not as severely as above. There is a large 
# portion of UPC/weeks where planogram information was observed for only some (less than 33) weeks. 


# The goal of the following section is to determine a) the meaning of all of the columns in the movement and
# planogram files, and b) the source of the inconsistency in sales data between the two files.



# pick a single UPC to subset
# upc_ex = 1111143009
# subset = dt[dt$UPC == upc_ex]
# 
# n = length(unique(subset$STORE))
# print(paste0('There are ', n, ' unique store IDs for which we have planogram info for upc ', upc_ex))
# 
# 
# for (store_id in unique(subset$STORE)){
#   store_subset = subset[STORE == store_id]
#   n = length(unique(store_subset$WEEK))
#   print(paste0('There are ', n, ' unique weeks for which we have planogram info for store ', store_id))
#   print(unique(store_subset$WEEK))
# }
# 
# 
# 
# #select UPC subset
# mv_subset = movements[UPC == upc_ex]
# 
# n = length(unique(mv_subset$STORE))
# print(paste0('There are ', n, ' unique store IDs for which we have movement info for upc ', upc_ex))
# 
# for (store_id in unique(mv_subset$STORE)){
#   store_subset = mv_subset[STORE == store_id]
#   n = length(unique(store_subset$WEEK))
#   print(paste0('There are ', n, ' unique weeks for which we have movement info for store ', store_id))
# }

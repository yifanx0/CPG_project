# date: 11/29/2018
# author: Yifan Xu
# goal: to clean laundry detergent data from externals/POG/data_csv/OMNI_csv.zip
  # in a way that is applicable for other products in the folder
# source: this cleaning code is based on what was written by Prof. Joo
##==============================================================================

rm(list = ls())
library(data.table)
library(bit64)
library(plyr)

# prod_name & prod_abbr can be specified for different products
prod_name = "detergent"
prod_abbr = "did"

work_dir = paste0("~/Dropbox/RA2/externals/POG_cleaning/OMNI_cleaning/OMNI_", 
                  prod_name)
setwd(work_dir)
zip_file_dir = "~/Dropbox/RA2/externals/POG/data_csv/OMNI_csv.zip"


### Read the master product description data
#products_colclass = c("integer64", "integer64", "character", "character", "integer", 
#                      "integer","integer","integer","integer","integer","integer","double","integer","integer")
products_colclass = c("numeric", "numeric", "character", "character", "numeric", "numeric",
                      "numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric")

products = fread("raw/product_char_laundrydetergent.csv", sep="auto", sep2=NULL,
                 nrows=-1L, header=TRUE, na.strings=c(""), 
                 stringsAsFactors=FALSE, verbose=TRUE, autostart=30L,
                 select=NULL, drop=NULL, colClasses=products_colclass,
                 showProgress=TRUE, data.table = TRUE)



### Read the movements data
#movements_colclass = c("integer64", "integer64", "integer64", "integer64","double",
#                       "double", "character", "double", "integer")
movements_colclass = c("numeric", "numeric", "numeric", "numeric","numeric",
                       "numeric", "character", "numeric", "numeric")
movements = fread("raw/laundrydetergent_movement.csv", sep="auto", sep2=NULL,
                  nrows=-1L, header=TRUE, na.strings=c("", "."), 
                  stringsAsFactors=FALSE, verbose=TRUE, autostart=30L,
                  select=NULL, drop=NULL, colClasses=movements_colclass,
                  showProgress=TRUE, data.table = TRUE)

colnames(movements) = c("store", "upc", "week", "move", "perbundle_cases", "bundle_price", "sale", "profit", "verifier")
movements$sale_coupon = c(0)
movements$sale_bonusbuy = c(0)
movements$sale_pricereduction = c(0)
movements[sale == "B", sale_bonusbuy := 1]
movements[sale == "C", sale_coupon := 1]
movements[sale == "S", sale_pricereduction := 1]


### merge into one dataframe
data = movements[movements$upc %in% products$upc,]
data$sale = NULL
rm(movements)
gc()

data = merge(data, products, by = "upc", all.x = TRUE)



### We compute the per-load prices
data$perload_price = data$bundle_price / (data$perbundle_cases * data$loads_per_case)
### We compute the per-load profits
data$profit = data$profit / 100 # In 1 unit
setnames(data, "profit", "profitability")
data$perload_cost = data$perload_price * (1-data$profitability)

setnames(data, "move", "q_bundle")
data$q_load = data$perbundle_cases * data$loads_per_case * data$q_bundle


select_col = c("upc", "description", "store", "week", # product/market identifier
               "bundle_price", "perload_price", # prices
               "q_bundle", "q_load", # quantities
               "oz_converted_size", "powder", "heavyduty_concentrated_double", "bleach", "unscented", # product characterstics
               "tide", "purex", "ajax", "armhammer", "surf", "wisk", # brands
               "sale_coupon", "sale_bonusbuy", "sale_pricereduction", # Promo status
               "profitability", "perload_cost")  # instruments



data[verifier == 0, verifier := NA]
data = na.omit(data)

data_cleaned = subset(data, select = select_col)




##### Load and clean the customer count data
ccount = fread("raw/customer_count_corrupt_row_deleted.csv", sep="auto", sep2=NULL,
               nrows=-1L, header=TRUE, na.strings=c(".", ""), 
               stringsAsFactors=FALSE, verbose=TRUE, autostart=30L,
               select=NULL, drop=NULL, colClasses="auto",
               showProgress=TRUE, data.table = TRUE)
ccount$STORE = as.numeric(ccount$STORE)
ccount$DATE = as.numeric(ccount$DATE)


##### Compute the outside shares
#data_temp = fread("data.csv", sep="auto", sep2=NULL,
#                     nrows=-1L, header=TRUE, na.strings=c(".", ""), 
#                     stringsAsFactors=FALSE, verbose=TRUE, autostart=30L,
#                     select=NULL, drop=NULL, colClasses="auto",
#                     showProgress=TRUE, data.table = TRUE)


ccount = subset(ccount, select = c("STORE", "WEEK", "CUSTCOUN"))

ccount = na.omit(ccount)

ccount$STORE = as.numeric(ccount$STORE)
ccount$WEEK = as.numeric(ccount$WEEK)
ccount$CUSTCOUN = as.numeric(ccount$CUSTCOUN)

colnames(ccount) = c("store", "week", "ccount")

ccount = ccount[, lapply(.SD, sum, na.rm = TRUE), by = c("store", "week")]


##### The market size is computed by assuming each consumer visiting the store consumes 6 loads of laundry detergent a week.
temp = subset(data_cleaned, select = c("store", "week", "q_load"))
temp = temp[, lapply(.SD, sum, na.rm = TRUE), by = c("store", "week")]


temp = merge(temp, ccount, by = c("store", "week"))
temp$market_size = temp$ccount * 6

temp$share = temp$q_load / temp$market_size
#temp = temp[order(-ratio),]
temp[share>1, omit_indicator := 1]
temp[share<1, omit_indicator := 0]

temp = subset(temp, select = c("store", "week", "market_size", "omit_indicator"))

data_cleaned = merge(data_cleaned, temp, by = c("store", "week"), all.x = TRUE)
data_cleaned$share = data_cleaned$q_load / data_cleaned$market_size

### Computing s0
temp = subset(data_cleaned, select = c("store", "week", "share"))
temp = temp[, lapply(.SD, sum, na.rm = TRUE), by = c("store", "week")]
temp$s0 = 1-temp$share
temp$share = NULL

data_cleaned = merge(data_cleaned, temp, by = c("store", "week"), all.x = TRUE)

data_cleaned$promo = data_cleaned$sale_bonusbuy + data_cleaned$sale_coupon + data_cleaned$sale_pricereduction

data_cleaned$ajax_armhammer_surf_purex = data_cleaned$ajax + data_cleaned$armhammer + data_cleaned$surf + data_cleaned$purex
data_cleaned$liquid = 1-data_cleaned$powder


select_col = c("upc", "description", "store", "week", # product/market identifier
               "bundle_price", "perload_price", # prices
               "share", "s0", # shares
               "oz_converted_size", "liquid", "heavyduty_concentrated_double", "bleach", # product characterstics
               "tide", "wisk", "ajax_armhammer_surf_purex", # brands
               "promo", "sale_bonusbuy", "sale_pricereduction", "sale_coupon", # Promo status
               "profitability", "perload_cost", # instruments
               "omit_indicator")  


data_cleaned = subset(data_cleaned, select = select_col)







##### Load and clean the demographics data
demo = fread("raw/demographics.csv", sep="auto", sep2=NULL,
             nrows=-1L, header=TRUE, na.strings=c(".", ""), 
             stringsAsFactors=FALSE, verbose=TRUE, autostart=30L,
             select=NULL, drop=NULL, colClasses="auto",
             showProgress=TRUE, data.table = TRUE)


demo = subset(demo, select = c("STORE", "ETHNIC", "EDUC", "INCOME", "POVERTY"))

demo = na.omit(demo)
colnames(demo) = c("store", "ethnic", "educ", "income", "poverty")

demo = as.data.table(sapply(demo, as.numeric))

data_cleaned = merge(data_cleaned, demo, by = "store", all.x = TRUE)

data_cleaned[s0<0, s0:=NA]
data_cleaned = na.omit(data_cleaned)



write.csv(data_cleaned, "data.csv", row.names = FALSE)



wk = 275
sample_data = data_cleaned[week == wk,]
sample_data = na.omit(sample_data)

write.csv(sample_data, paste(c("detergent_data_week",wk,".csv"), collapse = ""), row.names = FALSE)
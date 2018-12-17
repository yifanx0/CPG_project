##### Data Extract code

rm(list=ls(all = TRUE))

##### Load the required library
library('data.table')
library('bit64')
library('plyr')

##### Set the working directory
#setwd("~/Dropbox/RA2/data_cleaning/dominick_data_beer")
setwd("~/Dropbox/RA2/externals/POG/data_csv")

##### specficy a product category, extract the corresponding csv's
category = 'beer'
cat_abbr = ''
setwd("~/Dropbox/RA2/externals/POG_cleaning/dff_cleaning")

prod_file = paste0('dff_', category, '/dff_', 
                   category, '_raw/upc_descr_', category)

products = fread(prod_file, sep="auto", sep2=NULL,
                 nrows=-1L, header=TRUE, na.strings=c(""), 
                 stringsAsFactors=FALSE, verbose=TRUE, autostart=30L,
                 drop=NULL, showProgress=TRUE, data.table = TRUE)

### Read the master product description data
#products_colclass = c("integer64", "integer64", "character", "character", "integer", 
#                      "integer","integer","integer","integer","integer","integer","double","integer","integer")
products_colclass = c("numeric", "numeric", "character", "character", "numeric", "numeric",
                      "numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric")

# products = fread("product_char_beer.csv", sep="auto", sep2=NULL,
#                  nrows=-1L, header=TRUE, na.strings=c(""), 
#                  stringsAsFactors=FALSE, verbose=TRUE, autostart=30L,
#                  drop=NULL, showProgress=TRUE, data.table = TRUE)


### Read the movements data
#movements_colclass = c("integer64", "integer64", "integer64", "integer64","double",
#                       "double", "character", "double", "integer")
movements_colclass = c("numeric", "numeric", "numeric", "numeric","numeric",
                       "numeric", "character", "numeric", "numeric")

move_file = paste0('dff_', category, '/dff_', 
            category, '_raw/movement_', category)

movements = fread(move_file, sep="auto", sep2=NULL,
                  nrows=-1L, header=TRUE, na.strings=c("", "."), 
                  stringsAsFactors=FALSE, verbose=TRUE, autostart=30L,
                   drop=NULL, colClasses=movements_colclass,
                  showProgress=TRUE, data.table = TRUE)

colnames(movements) = c("store", "upc", "week", "move", "perbundle_cases", "bundle_price", "sale", "profit", "verifier")
movements$sale_coupon = c(0)
movements$sale_bonusbuy = c(0)
movements$sale_pricereduction = c(0)
movements[sale == "B", sale_bonusbuy := 1]
movements[sale == "C", sale_coupon := 1]
movements[sale == "S", sale_pricereduction := 1]


### Select product category data
data = movements[movements$upc %in% products$upc,]
data$sale = NULL
rm(movements)
gc()

data = merge(data, products, by = "upc", all.x = TRUE)



### We compute the per-ounce prices
data$peroz_price = data$bundle_price / (data$perbundle_cases * data$bottles_per_case * data$bottle_size)
### We compute the per-ounce profits
data$profit = data$profit / 100 # In 1 unit
setnames(data, "profit", "profitability")
data$peroz_cost = data$peroz_price * (1-data$profitability)

setnames(data, "bottles_per_case", "percase_bottles")
setnames(data, "move", "q_bundle")
data$q_ounce = data$perbundle_cases * data$percase_bottles * data$bottle_size * data$q_bundle


select_col = c("upc", "description", "store", "week", # product/market identifier
               "bundle_price", "peroz_price", # prices
               "q_bundle", "q_ounce", # quantities
               "ale", "imported", "light", "dark", "nonalchol", "craftbrewary", "seasonal", "beeradvocate_score", "abv", "sale_coupon", "sale_bonusbuy", "sale_pricereduction", # product characterstics
               "profitability", "peroz_cost",  # instruments
               "bottle_size", "percase_bottles", "perbundle_cases") # product unit 


data[verifier == 0, verifier := NA]
data = na.omit(data)

data_cleaned = subset(data, select = select_col)


##### Load and clean the customer count data
ccount = fread("raw/customer_count.csv", sep="auto", sep2=NULL,
               nrows=-1L, header=TRUE, na.strings=c(".", ""), 
               stringsAsFactors=FALSE, verbose=TRUE, autostart=30L,
               skip=-1L, select=NULL, drop=NULL, colClasses="auto",
               showProgress=TRUE, data.table = TRUE)
ccount$STORE = as.numeric(ccount$STORE)
ccount$DATE = as.numeric(ccount$DATE)


##### Compute the outside shares
#data_temp = fread("data.csv", sep="auto", sep2=NULL,
#                     nrows=-1L, header=TRUE, na.strings=c(".", ""), 
#                     stringsAsFactors=FALSE, verbose=TRUE, autostart=30L,
#                     skip=-1L, select=NULL, drop=NULL, colClasses="auto",
#                     showProgress=TRUE, data.table = TRUE)


ccount = subset(ccount, select = c("STORE", "WEEK", "CUSTCOUN"))

ccount = na.omit(ccount)

ccount$STORE = as.numeric(ccount$STORE)
ccount$WEEK = as.numeric(ccount$WEEK)
ccount$CUSTCOUN = as.numeric(ccount$CUSTCOUN)

colnames(ccount) = c("store", "week", "ccount")

ccount = ccount[, lapply(.SD, sum, na.rm = TRUE), by = c("store", "week")]


##### One customer consumes about 50 ounces of beer a week
temp = subset(data_cleaned, select = c("store", "week", "q_ounce"))
temp = temp[, lapply(.SD, sum, na.rm = TRUE), by = c("store", "week")]

temp = merge(temp, ccount, by = c("store", "week"))
temp$ratio = temp$q_ounce / temp$ccount
temp = temp[order(-ratio),]
temp[ratio>50, omit_indicator := 1]
temp[ratio<50, omit_indicator := 0]
temp$market_size = temp$ccount * 50
temp = subset(temp, select = c("store", "week", "market_size", "omit_indicator"))

data_cleaned = merge(data_cleaned, temp, by = c("store", "week"), all.x = TRUE)
data_cleaned$share = data_cleaned$q_ounce / data_cleaned$market_size

### Computing s0
temp = subset(data_cleaned, select = c("store", "week", "share"))
temp = temp[, lapply(.SD, sum, na.rm = TRUE), by = c("store", "week")]
temp$s0 = 1-temp$share
temp$share = NULL

data_cleaned = merge(data_cleaned, temp, by = c("store", "week"), all.x = TRUE)


select_col = c("upc", "description", "store", "week", # product/market identifier
               "bundle_price", "peroz_price", # prices
               "share", "s0", # share
               "ale", "imported", "light", "dark", "nonalchol", "craftbrewary", "seasonal", "beeradvocate_score", "abv", "sale_coupon", "sale_bonusbuy", "sale_pricereduction", # product characterstics
               "profitability", "peroz_cost",  # instruments
               "bottle_size", "percase_bottles", "perbundle_cases", # product unit 
               "omit_indicator")


data_cleaned = subset(data_cleaned, select = select_col)




##### Load and clean the demographics data
demo = fread("raw/demographics.csv", sep="auto", sep2=NULL,
               nrows=-1L, header=TRUE, na.strings=c(".", ""), 
               stringsAsFactors=FALSE, verbose=TRUE, autostart=30L,
               skip=-1L, select=NULL, drop=NULL, colClasses="auto",
               showProgress=TRUE, data.table = TRUE)


demo = subset(demo, select = c("STORE", "ETHNIC", "EDUC", "INCOME", "POVERTY", "SINGLE", "RETIRED", "UNEMP"))

demo = na.omit(demo)
colnames(demo) = c("store", "ethnic", "educ", "income", "poverty", "single", "retired", "unemp")

demo = as.data.table(sapply(demo, as.numeric))

data_cleaned = merge(data_cleaned, demo, by = "store", all.x = TRUE)
data_cleaned = na.omit(data_cleaned)

data_cleaned$promo = data_cleaned$sale_bonusbuy + data_cleaned$sale_pricereduction + data_cleaned$sale_coupon
data_cleaned[promo > 1, promo := 1]
#data_cleaned$sale_bonusbuy = NULL
#data_cleaned$sale_pricereduction = NULL
#data_cleaned$sale_coupon = NULL
data_cleaned$omit_indicator = NULL

#write.csv(data_cleaned, "data.csv", row.names = FALSE)




wk = 370
sample_data = data_cleaned[week == wk,]
sample_data = na.omit(sample_data)

write.csv(sample_data, paste(c("sample_data_week",wk,".csv"), collapse = ""), row.names = FALSE)



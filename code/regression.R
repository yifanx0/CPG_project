# date: 2/25/2019
# author: Owen Eagen
# goal: verify consistencies in sales data by regressing shelf characteristics

# sales = a + b1 * price + b2 * up-above-dummy + b3 * bottom-level-dummy + 
# b4 * disp + b5 * feat + e

setwd("~/Dropbox/RA2/externals/POG/kilts")
library(data.table)
cso = fread("cso/cso_merge.csv")
tti = fread("tti/tti_merge.csv")
tpa = fread("tpa/tpa_merge.csv")
tbr = fread("tbr/tbr_merge.csv")
#cso = cso[order(SHELF)]
#cso[, alt_min := min(ALT), by = SHELF]
#cso[, alt_max := max(ALT), by = SHELF]

summary_shelf_cso = cso[, .(alt_min = min(ALT), alt_max = max(ALT)), by = SHELF]
summary_shelf_tti = tti[, .(alt_min = min(ALT), alt_max = max(ALT)), by = SHELF]
summary_shelf_tpa = tpa[, .(alt_min = min(ALT), alt_max = max(ALT)), by = SHELF]
summary_shelf_tbr = tbr[, .(alt_min = min(ALT), alt_max = max(ALT)), by = SHELF]
summary_shelf_cso = summary_shelf_cso[order(SHELF)]
summary_shelf_tti = summary_shelf_tti[order(SHELF)]
summary_shelf_tpa = summary_shelf_tpa[order(SHELF)]
summary_shelf_tbr = summary_shelf_tbr[order(SHELF)]

prod_cats = c("cso", "cer", "ptw", "did", "tpa", "rfj", 
              "bjc", "tna", "tti", "tbr")
max_alt = 0
min_alt = 1000
for (prod_cat in prod_cats) {
  path = paste0(prod_cat, "/", prod_cat, "_merge.csv")
  dt = fread(path)
  if (max(dt$ALT) > max_alt) {
    max_alt = max(dt$ALT)
  } 
  if (min(dt$ALT) < min_alt) {
    min_alt = min(dt$ALT)
  } 
}

cso[, SALES_m := MOVE_m * PRICE_m / QTY]
cso[, diff_sales := abs(SALES_m - SALES)]
cso[, perc_diff_sales := diff_sales / SALES_m]

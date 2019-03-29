# date: Mar 2019
# author: Yifan Xu
# goal: to construct product characteristics for rfj, tbr, tpa
# refrigerated juice, toothbrush, toothpaste
#==============================================================================
library(data.table)

#==============================================================================
# helper
## product: the product abbreviation
## product_descr = product description for the abbreviation
## char_list: list of characters
## pattern_list: list of patterns, in the same order as char_list
## detail_list: description of char_list, in the same order
write_product_char = 
  function(product, product_descr, char_list, pattern_list, detail_list) {
    if ((length(char_list) != length(detail_list)) | 
        (length(char_list) != length(pattern_list))) {
      stop("char_list, detail_list, pattern_list need to have the same length!")
    }
    kilts_dir = "~/Dropbox/RA2/externals/POG/kilts/"
    setwd(paste0(kilts_dir, product))
    print(paste0("working directory: ", kilts_dir, product))
    dataset = fread(paste0("upc", product, ".csv"))
    
    for (char_i in 1:length(char_list)) {
      dataset[, char_list[char_i] := 0]
      patterns = pattern_list[[char_i]]
      for (pattern_i in 1:length(patterns)) {
        dataset[grepl(patterns[pattern_i], DESCRIP), 
                char_list[char_i] := 1]
      }
    }
    
    write.csv(dataset, file = paste0(product, "_product_char.csv"))
    
    doc_dir = "~/Dropbox/RA2/externals/POG/doc"
    setwd(doc_dir)
    print(paste0("working directory: ", doc_dir))
    char_index_filename = "product_char_index.csv"
    char_index = as.data.table(read.csv(char_index_filename, row.names = 1))
    
    for (i in 1:length(char_list)) {
      new_line = list(product_descr, product, detail_list[i], char_list[i])
      char_index = rbind(char_index, new_line)
    }
    
    write.csv(char_index, file = char_index_filename)
  }

#==============================================================================
# rfj
product = "rfj"
kilts_dir = "~/Dropbox/RA2/externals/POG/kilts/"
setwd(paste0(kilts_dir, product))
dataset = fread(paste0("upc", product, ".csv"))
descr_list = unique(dataset$DESCRIP)
char_list = c("brand_minute_maid", 
              "brand_dole",
              "brand_sunny_d",
              "brand_citrus_hill",
              "calcium",
              "orange",
              "yogurt",
              "tea")
pattern_list = list(c("MM", "MAID"),
                    c("DOLE"),
                    c("SUNNY DELIGHT"),
                    c("CITRUS HILL"),
                    c("CALCIUM"),
                    c("O J", "OJ", "ORG", "ORAN"),
                    c("YOGURT"),
                    c("TEA"))
detail_list = c("Minute Maid (brand)", 
                "Dole (brand)",
                "Sunny Delight (brand)",
                "Citrus Hill (brand)",
                "calcium fortified",
                "orange juice",
                "yogurt",
                "iced tea")
product_descr = "refrigerated juice"
write_product_char(product, product_descr, char_list, pattern_list, detail_list)

#==============================================================================
# tbr
product = "tbr"
kilts_dir = "~/Dropbox/RA2/externals/POG/kilts/"
setwd(paste0(kilts_dir, product))
dataset = fread(paste0("upc", product, ".csv"))
descr_list = unique(dataset$DESCRIP)
char_list = c("brand_colgate", 
              "brand_crest",
              "brand_blistex",
              "brand_aquafresh",
              "brand_gum",
              "brand_butler",
              "brand_ranir",
              "brand_oralb")
pattern_list = list(c("COLG", "CLG"),
                    c("CREST"),
                    c("BLISTEX"),
                    c("AQUA"),
                    c("GUM"),
                    c("BUTLER", "BTLR"),
                    c("RANIR"),
                    c("ORAL"))
detail_list = c("Colgate (brand)", 
                "Crest (brand)",
                "Blistex (lip balm brand)",
                "Aquafresh (brand)",
                "GUM (brand under SUNSTAR)",
                "Butler (brand under SUNSTAR)",
                "Ranir (brand)",
                "Oral B (brand)")
product_descr = "toothbrush"
write_product_char(product, product_descr, char_list, pattern_list, detail_list)

#==============================================================================
# tpa
product = "tpa"
kilts_dir = "~/Dropbox/RA2/externals/POG/kilts/"
setwd(paste0(kilts_dir, product))
dataset = fread(paste0("upc", product, ".csv"))
descr_list = unique(dataset$DESCRIP)
char_list = c("brand_mntdnt", 
              "brand_ppsdnt",
              "brand_aim",
              "brand_clsup",
              "brand_pluswht",
              "brand_arm",
              "brand_colgate",
              "brand_crest",
              "brand_aquafresh",
              "brand_oralb",
              "brand_toms",
              "brand_ssdn")
pattern_list = list(c("MENTADENT", "MNTDNT"),
                    c("PEPSODENT"),
                    c("AIM"),
                    c("CLOSE", "CLS"),
                    c("PLUS"),
                    c("ARM", "A&H", "A & H"),
                    c("COLG", "CLG", "ULTRA"),
                    c("CREST", "CRST"),
                    c("AQ", "AQUA", "AF"),
                    c("ORAL"),
                    c("TOM"),
                    c("SENSODYNE"))
detail_list = c("Mentadent (brand)", 
                "Pepsodent (brand)",
                "Aim (brand)",
                "Close-up (brand)",
                "Plus White (brand)",
                "Arm & Hammer (brand)",
                "Colgate (brand, w/ Ultrabrite as a second line)",
                "Crest (brand)",
                "Aquafresh (brand)",
                "Oral B (brand)",
                "Tom's of Maine (brand)",
                "Sensodyne (brand)")
product_descr = "toothpaste"
write_product_char(product, product_descr, char_list, pattern_list, detail_list)

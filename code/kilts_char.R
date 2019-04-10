# date: Mar-Apr 2019
# author: Yifan Xu
# goal: to construct product characteristics (dummies) for 
#       rfj, tbr, tpa, 
#       ptw, cer, tna
# i.e., refrigerated juice, toothbrush, toothpaste, 
#       paper towels, RTE cereals, canned tuna
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
    char_index = as.data.table(read.csv(char_index_filename))
    
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

#==============================================================================
# ptw
product = "ptw"
kilts_dir = "~/Dropbox/RA2/externals/POG/kilts/"
setwd(paste0(kilts_dir, product))
dataset = fread(paste0("upc", product, ".csv"))
descr_list = unique(dataset$DESCRIP)
char_list = c("recycled",
              "brand_kleenex", 
              "brand_bounty",
              "brand_dom",
              "brand_brawny",
              "brand_scott",
              "brand_hidri")
pattern_list = list(c("RECYCLED"),
                    c("KLEENEX", "KLNX", "VIVA"),
                    c("BOUNTY", "BNTY"),
                    c("DOM"),
                    c("BRAWNY"),
                    c("SCOTT"),
                    c("HI DRI", "HI-DRI"))
detail_list = c("recycled paper", 
                "Kleenex (brand, with Viva as a second line)", 
                "Bounty (brand)",
                "Dominick's (brand)",
                "Brawny (brand)",
                "Scott (brand)",
                "Hi-Dri (brand)")
product_descr = "paper towel"
write_product_char(product, product_descr, char_list, pattern_list, detail_list)

#==============================================================================
# cer
product = "cer"
kilts_dir = "~/Dropbox/RA2/externals/POG/kilts/"
setwd(paste0(kilts_dir, product))
dataset = fread(paste0("upc", product, ".csv"))
descr_list = unique(dataset$DESCRIP)
char_list = c("bran",
              "oatmeal",
              "raisin",
              "nut",
              "low_fat",
              "fruit",
              "honey",
              "brand_dom",
              "brand_quaker",
              "brand_kel",
              "brand_genmil",
              "brand_nab",
              "brand_post",
              "brand_ralston")
pattern_list = list(c("BRAN"),
                    c("OAT"),
                    c("RAI", "RSN"),
                    c("NUT"),
                    c("LOW", "L/F"),
                    c("FRT", "FRUIT"),
                    c("HON", "HNY"),
                    c("DOM"),
                    c("QUAKER", "QKR"),
                    c("KEL", "KLG"),
                    c("GM", "GEN"),
                    c("NAB"),
                    c("POST"),
                    c("RALSTON"))
detail_list = c("contains bran",
                "oatmeal/oat",
                "contains raisin",
                "contains nuts",
                "low fat",
                "contains fruit",
                "contains honey",
                "dominick's (brand)",
                "Quaker (brand)",
                "Kellogg's (brand)",
                "General Mill's (brand)",
                "Nabisco (brand)",
                "Post (brand)",
                "Ralston (brand)")
product_descr = "RTE cereal"
write_product_char(product, product_descr, char_list, pattern_list, detail_list)

#==============================================================================
# tna
product = "tna"
kilts_dir = "~/Dropbox/RA2/externals/POG/kilts/"
setwd(paste0(kilts_dir, product))
dataset = fread(paste0("upc", product, ".csv"))
descr_list = unique(dataset$DESCRIP)
char_list = c("sardine",
              "oyster", 
              "tuna",
              "salmon",
              "crab",
              "shrimp",
              "brand_cos",
              "brand_dom",
              "brand_kingos",
              "brand_royal",
              "brand_polar",
              "brand_sk")
pattern_list = list(c("SARD"),
                    c("OYSTE"),
                    c("TUN"),
                    c("SALMON", "SOCKEY", "PINK"),
                    c("CRAB", "CRB"),
                    c("SHRIMP"),
                    c("C O S", "COS", "C.O.S."),
                    c("DOM"),
                    c("OSCAR", "OSCR", "oscar"),
                    c("ROYAL"),
                    c("POLAR"),
                    c("STAR", "SK ", "STRKST"))
detail_list = c("sardine product", 
                "oyster product", 
                "tuna product",
                "salmon product",
                "crab product",
                "shrimp product",
                "Chicken of the Sea (brand)",
                "Dominick's (brand)",
                "King Oscar (brand)",
                "Royal (brand)",
                "Polar (brand)",
                "StarKist (brand)")
product_descr = "canned tuna"
write_product_char(product, product_descr, char_list, pattern_list, detail_list)
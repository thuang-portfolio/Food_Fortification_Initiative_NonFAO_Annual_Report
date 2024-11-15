# load packages
pacman::p_load(tidyverse, here)

# specify file location relative to project folder
here::i_am("Code/wheat_cropslivestock.R")

# get year parameter
config_list <- config::get()

# read in FAO crops and livestocks data and country names
file_name_1 <- paste0("Cleaned_Data/nonfao_production_data_", config_list$year, ".rds")
nonfao_production_data <- readRDS(here::here(file_name_1))

file_name_2 <- paste0("Cleaned_Data/nonfao_trade_data_", config_list$year, ".rds")
nonfao_trade_data <- readRDS(here::here(file_name_2))

names <- read.csv(here::here("Raw_Data/nonfao_country_names.csv"), header = TRUE)

# compile wheat data

# Wheat (Grain) Production
wheat_prod_data <- nonfao_production_data %>% filter(Item == "Wheat") %>%
  dplyr::select(Area, Value) %>%
  rename(country_name = Area, wheat_prod = Value) %>%
  mutate(source_wheat_prod = paste0("FAO. Crops and livestock Products. Italy. ", config_list$source_year, 
                                          ". [https://www.fao.org/faostat/en/#data/TCL]."))

# Wheat (Grain) Imports
wheat_grain_imports_data <- nonfao_trade_data %>% filter(Item == "Wheat", Element == "Import Quantity") %>%
  dplyr::select(Area, Value) %>%
  rename(country_name = Area, wheat_grain_imports = Value)  %>%
  mutate(source_wheat_grain_imports = paste0("FAO. Crops and livestock Products. Italy. ", config_list$source_year, 
                                       ". [https://www.fao.org/faostat/en/#data/TCL]."))

# Wheat (Grain) Exports
wheat_grain_exports_data <- nonfao_trade_data %>% filter(Item == "Wheat", Element == "Export Quantity") %>%
  dplyr::select(Area, Value) %>%
  rename(country_name = Area, wheat_grain_exports = Value)  %>%
  mutate(source_wheat_grain_exports = paste0("FAO. Crops and livestock Products. Italy. ", config_list$source_year, 
                                       ". [https://www.fao.org/faostat/en/#data/TCL]."))

# Wheat Flour Imports
wheat_flour_imports_data <- nonfao_trade_data %>% filter(Item == "Wheat and meslin flour", Element == "Import Quantity") %>%
  dplyr::select(Area, Value) %>%
  rename(country_name = Area, wheat_flour_imports = Value)  %>%
  mutate(source_wheat_flour_imports = paste0("FAO. Crops and livestock Products. Italy. ", config_list$source_year, 
                                            ". [https://www.fao.org/faostat/en/#data/TCL]."))

# Wheat Flour Exports
wheat_flour_exports_data <- nonfao_trade_data %>% filter(Item == "Wheat and meslin flour", Element == "Export Quantity") %>%
  dplyr::select(Area, Value) %>%
  rename(country_name = Area, wheat_flour_exports = Value)  %>%
  mutate(source_wheat_flour_exports = paste0("FAO. Crops and livestock Products. Italy. ", config_list$source_year, 
                                            ". [https://www.fao.org/faostat/en/#data/TCL]."))

# Wheat Flour Products Imports
wheat_flour_products_imports_data <- nonfao_trade_data %>% filter(Item %in% c("Bran of wheat", 
                                                                        "Germ of wheat", 
                                                                        "Bread", "Bulgur", 
                                                                        "Pastry", 
                                                                        "Breakfast cereals", 
                                                                        "Mixes and doughs for the preparation of bakers' wares", 
                                                                        "Food preparations of flour, meal or malt extract",
                                                                        "Communion wafers, empty cachets of a kind suitable for pharmaceutical use, sealing wafers, rice paper and similar products."), 
                                                            Element == "Import Quantity") %>%
  group_by(Area) %>%
  mutate(Total = sum(Value)) %>%
  select(Area, Total) %>%
  distinct(Area, .keep_all = TRUE) %>%
  rename(country_name = Area, wheat_flour_products_imports = Total)  %>%
  mutate(source_wheat_flour_products_imports = paste0("FAO. Crops and livestock Products. Italy. ", config_list$source_year, 
                                                     ". [https://www.fao.org/faostat/en/#data/TCL]."))

# Wheat Flour Products Exports
wheat_flour_products_exports_data <- nonfao_trade_data %>% filter(Item %in% c("Bran of wheat", 
                                                                        "Germ of wheat", 
                                                                        "Bread", "Bulgur", 
                                                                        "Pastry", 
                                                                        "Breakfast cereals", 
                                                                        "Mixes and doughs for the preparation of bakers' wares", 
                                                                        "Food preparations of flour, meal or malt extract",
                                                                        "Communion wafers, empty cachets of a kind suitable for pharmaceutical use, sealing wafers, rice paper and similar products."), 
                                                            Element == "Export Quantity") %>%
  group_by(Area) %>%
  mutate(Total = sum(Value)) %>%
  select(Area, Total) %>%
  distinct(Area, .keep_all = TRUE) %>%
  rename(country_name = Area, wheat_flour_products_exports = Total) %>%
  mutate(source_wheat_flour_products_exports = paste0("FAO. Crops and livestock Products. Italy. ", config_list$source_year, 
                                                     ". [https://www.fao.org/faostat/en/#data/TCL]."))

# Join items
wheat_sheet <- list(names, wheat_prod_data, wheat_grain_imports_data, wheat_grain_exports_data, 
                    wheat_flour_imports_data, wheat_flour_exports_data, 
                    wheat_flour_products_imports_data, wheat_flour_products_exports_data) %>% 
  reduce(left_join, by = "country_name")

# export 
file_name_3 <- paste0("Output_CSV_Files/wheat_cropslivestock", config_list$year, ".csv")
write.csv(wheat_sheet, 
          file = here::here(file_name_3))
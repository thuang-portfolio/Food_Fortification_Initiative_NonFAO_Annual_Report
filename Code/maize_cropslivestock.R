# load packages
pacman::p_load(tidyverse, here)

# specify file location relative to project folder
here::i_am("Code/maize_cropslivestock.R")

# get year parameter
config_list <- config::get()

# read in FAO crops and livestocks data and country names
file_name_1 <- paste0("Cleaned_Data/nonfao_production_data_", config_list$year, ".rds")
nonfao_production_data <- readRDS(here::here(file_name_1))

file_name_2 <- paste0("Cleaned_Data/nonfao_trade_data_", config_list$year, ".rds")
nonfao_trade_data <- readRDS(here::here(file_name_2))

names <- read.csv(here::here("Raw_Data/nonfao_country_names.csv"), header = TRUE)

# compile maize data
# Maize (Grain) Production
maize_prod_data <- nonfao_production_data %>% filter(Item == "Maize (corn)") %>%
  dplyr::select(Area, Value) %>%
  rename(country_name = Area, maize_prod = Value) %>%
  mutate(source_maize_prod = paste0("FAO. Crops and livestock Products. Italy. ", config_list$source_year, 
                                          ". [https://www.fao.org/faostat/en/#data/TCL]."))

# Maize (Grain) Imports
maize_grain_imports_data <- nonfao_trade_data %>% filter(Item == "Maize (corn)", Element == "Import Quantity") %>%
  dplyr::select(Area, Value) %>%
  rename(country_name = Area, maize_grain_imports = Value) %>%
  mutate(source_maize_grain_imports = paste0("FAO. Crops and livestock Products. Italy. ", config_list$source_year, 
                                       ". [https://www.fao.org/faostat/en/#data/TCL]."))

# Maize (Grain) Exports
maize_grain_exports_data <- nonfao_trade_data %>% filter(Item == "Maize (corn)", Element == "Export Quantity") %>%
  dplyr::select(Area, Value) %>%
  rename(country_name = Area, maize_grain_exports = Value) %>%
  mutate(source_maize_grain_exports = paste0("FAO. Crops and livestock Products. Italy. ", config_list$source_year, 
                                       ". [https://www.fao.org/faostat/en/#data/TCL]."))

# Maize Flour Imports
maize_flour_imports_data <- nonfao_trade_data %>% filter(Item == "Flour of maize", Element == "Import Quantity") %>%
  dplyr::select(Area, Value) %>%
  rename(country_name = Area, maize_flour_imports = Value) %>%
  mutate(source_maize_flour_imports = paste0("FAO. Crops and livestock Products. Italy. ", config_list$source_year, 
                                            ". [https://www.fao.org/faostat/en/#data/TCL]."))

# Maize Flour Exports
maize_flour_exports_data <- nonfao_trade_data %>% filter(Item == "Flour of maize", Element == "Export Quantity") %>%
  dplyr::select(Area, Value) %>%
  rename(country_name = Area, maize_flour_exports = Value) %>%
  mutate(source_maize_flour_exports = paste0("FAO. Crops and livestock Products. Italy. ", config_list$source_year, 
                                            ". [https://www.fao.org/faostat/en/#data/TCL]."))

# Maize Flour Products Imports
maize_flour_products_imports_data <- nonfao_trade_data %>% filter(Item %in% c("Germ of maize",
                                                                        "Bran of maize",
                                                                        "Gluten feed and meal"),
                                                            Element == "Import Quantity") %>%
  group_by(Area) %>%
  mutate(Total = sum(Value)) %>%
  select(Area, Total) %>%
  distinct(Area, .keep_all = TRUE) %>%
  rename(country_name = Area, maize_flour_products_imports = Total) %>%
  mutate(source_maize_flour_products_imports = paste0("FAO. Crops and livestock Products. Italy. ", config_list$source_year, 
                                                     ". [https://www.fao.org/faostat/en/#data/TCL]."))

# Maize Flour Products Exports 
maize_flour_products_exports_data <- nonfao_trade_data %>% filter(Item %in% c("Germ of maize",
                                                                        "Bran of maize",
                                                                        "Gluten feed and meal"),
                                                            Element == "Export Quantity") %>%
  group_by(Area) %>%
  mutate(Total = sum(Value)) %>%
  select(Area, Total) %>%
  distinct(Area, .keep_all = TRUE) %>%
  rename(country_name = Area, maize_flour_products_exports = Total) %>%
  mutate(source_maize_flour_products_exports = paste0("FAO. Crops and livestock Products. Italy. ", config_list$source_year, 
                                                     ". [https://www.fao.org/faostat/en/#data/TCL]."))

# Join items
maize_sheet <- list(names, maize_prod_data, maize_grain_imports_data, maize_grain_exports_data, 
                    maize_flour_imports_data, maize_flour_exports_data, maize_flour_products_imports_data, 
                    maize_flour_products_exports_data) %>% 
  reduce(left_join, by = "country_name")

#export
file_name_3 <- paste0("Output_CSV_Files/maize_cropslivestock", config_list$year, ".csv")
write.csv(maize_sheet, file = here::here(file_name_3))
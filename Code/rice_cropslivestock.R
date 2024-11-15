# load packages
pacman::p_load(tidyverse, here)

# specify file location relative to project folder
here::i_am("Code/rice_cropslivestock.R")

# get year parameter
config_list <- config::get()

# read in FAO crops and livestocks data and country names
file_name_1 <- paste0("Cleaned_Data/nonfao_production_data_", config_list$year, ".rds")
nonfao_production_data <- readRDS(here::here(file_name_1))

file_name_2 <- paste0("Cleaned_Data/nonfao_trade_data_", config_list$year, ".rds")
nonfao_trade_data <- readRDS(here::here(file_name_2))

names <- read.csv(here::here("Raw_Data/nonfao_country_names.csv"), header = TRUE)

# compile rice data
# Rice (Grain) Production
rice_prod_data <- nonfao_production_data %>% filter(Item == "Rice") %>%
  dplyr::select(Area, Value) %>%
  rename(country_name = Area, rice_prod = Value) %>%
  mutate(source_rice_prod = paste0("FAO. Crops and livestock Products. Italy. ", config_list$source_year, 
                                         ". [https://www.fao.org/faostat/en/#data/TCL]."))

# Rice (Grain) Imports
rice_grain_imports_data <- nonfao_trade_data %>% filter(Item %in% c("Rice, broken",
                                                         "Rice, milled",
                                                         "Husked rice"),
                                             Element == "Import Quantity") %>%
  group_by(Area) %>%
  mutate(Total = sum(Value)) %>%
  select(Area, Total) %>%
  distinct(Area, .keep_all = TRUE) %>%
  rename(country_name = Area, rice_grain_imports = Total) %>%
  mutate(source_rice_grain_imports = paste0(
    "FAO. Crops and livestock Products. Italy. ", config_list$source_year, 
    ". [https://www.fao.org/faostat/en/#data/TCL]."))

# Rice (Grain) Exports
rice_grain_exports_data <- nonfao_trade_data %>% filter(Item %in% c("Rice, broken",
                                                         "Rice, milled",
                                                         "Husked rice"),
                                             Element == "Export Quantity") %>%
  group_by(Area) %>%
  mutate(Total = sum(Value)) %>%
  select(Area, Total) %>%
  distinct(Area, .keep_all = TRUE) %>%
  rename(country_name = Area, rice_grain_exports = Total) %>%
  mutate(source_rice_grain_exports = paste0("FAO. Crops and livestock Products. Italy. ", config_list$source_year, 
                                      ". [https://www.fao.org/faostat/en/#data/TCL]."))

# Join items
rice_sheet <- list(names, rice_prod_data, rice_grain_imports_data, rice_grain_exports_data) %>% 
  reduce(left_join, by = "country_name")

#export 
file_name_3 <- paste0("Output_CSV_Files/rice_cropslivestock", config_list$year, ".csv")
write.csv(rice_sheet, 
          file = here::here(file_name_3))
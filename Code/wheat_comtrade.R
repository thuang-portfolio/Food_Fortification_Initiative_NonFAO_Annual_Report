# load packages
pacman::p_load(tidyverse, here)

# specify file location relative to project folder
here::i_am("Code/wheat_comtrade.R")

# get year parameter
config_list <- config::get()

# read in comtrade data and country names
file_name_1 <- paste0("Cleaned_Data/comtrade_data_", config_list$year, ".rds")
comtrade_data <- readRDS(here::here(file_name_1))

names <- read.csv(here::here("Raw_Data/nonfao_country_names.csv"), header = TRUE)

# compile wheat data
# Comtrade Wheat (Grain) Imports
wheat_grain_imports_data <- comtrade_data %>% filter(CmdCode == "1001", FlowDesc == "Export") %>%
  group_by(PartnerDesc) %>%
  mutate(Total = sum(Qty)/1000) %>%
  select(PartnerDesc, Total) %>%
  distinct(PartnerDesc, .keep_all = TRUE) %>%
  rename(country_name = PartnerDesc, wheat_grain_imports = Total) %>%
  mutate(source_wheat_grain_imports = paste0("United Nations, Department of Economic and Social Affairs, Statistics Division. UN Comtrade Database. United States of America. ", config_list$source_year, ". [https://comtrade.un.org/data]."))

# Comtrade Wheat (Grain) Exports
wheat_grain_exports_data <- comtrade_data %>% filter(CmdCode == "1001", FlowDesc == "Import") %>%
  group_by(PartnerDesc) %>%
  mutate(Total = sum(Qty)/1000) %>%
  select(PartnerDesc, Total) %>%
  distinct(PartnerDesc, .keep_all = TRUE) %>%
  rename(country_name = PartnerDesc, wheat_grain_exports = Total) %>%
  mutate(source_wheat_grain_exports = paste0("United Nations, Department of Economic and Social Affairs, Statistics Division. UN Comtrade Database. United States of America. ", config_list$source_year, ". [https://comtrade.un.org/data]."))

# Comtrade Wheat Flour Imports
wheat_flour_imports_data <- comtrade_data %>% filter(CmdCode == "1101", FlowDesc == "Export") %>%
  group_by(PartnerDesc) %>%
  mutate(Total = sum(Qty)/1000) %>%
  select(PartnerDesc, Total) %>%
  distinct(PartnerDesc, .keep_all = TRUE) %>%
  rename(country_name = PartnerDesc, wheat_flour_imports = Total) %>%
  mutate(source_wheat_flour_imports = paste0("United Nations, Department of Economic and Social Affairs, Statistics Division. UN Comtrade Database. United States of America. ", config_list$source_year, ". [https://comtrade.un.org/data]."))


# Comtrade Wheat Flour Exports
wheat_flour_exports_data <- comtrade_data %>% filter(CmdCode == "1101", FlowDesc == "Import") %>%
  group_by(PartnerDesc) %>%
  mutate(Total = sum(Qty)/1000) %>%
  select(PartnerDesc, Total) %>%
  distinct(PartnerDesc, .keep_all = TRUE) %>%
  rename(country_name = PartnerDesc, wheat_flour_exports = Total) %>%
  mutate(source_wheat_flour_exports = paste0("United Nations, Department of Economic and Social Affairs, Statistics Division. UN Comtrade Database. United States of America. ", config_list$source_year, ". [https://comtrade.un.org/data]."))

# Comtrade Wheat Flour Products Imports
wheat_flour_products_imports_data <- comtrade_data %>% filter(CmdCode %in% c("190219", "190430", "1905", 
                                                                                "230230", "110811", "1109", 
                                                                                "190120", "190110"), 
                                                                 FlowDesc == "Export") %>%
  group_by(PartnerDesc) %>%
  mutate(Total = sum(Qty)/1000) %>%
  select(PartnerDesc, Total) %>%
  distinct(PartnerDesc, .keep_all = TRUE) %>%
  rename(country_name = PartnerDesc, wheat_flour_products_imports = Total) %>%
  mutate(source_wheat_flour_products_imports = paste0("United Nations, Department of Economic and Social Affairs, Statistics Division. UN Comtrade Database. United States of America. ", config_list$source_year, ". [https://comtrade.un.org/data]."))

# Comtrade Wheat Flour Products Exports
wheat_flour_products_exports_data <- comtrade_data %>% filter(CmdCode %in% c("190219", "190430", "1905", 
                                                                                "230230", "110811", "1109", 
                                                                                "190120", "190110"), 
                                                                 FlowDesc == "Import") %>%
  group_by(PartnerDesc) %>%
  mutate(Total = sum(Qty)/1000) %>%
  select(PartnerDesc, Total) %>%
  distinct(PartnerDesc, .keep_all = TRUE) %>%
  rename(country_name = PartnerDesc, wheat_flour_products_exports = Total) %>%
  mutate(source_wheat_flour_products_exports = paste0("United Nations, Department of Economic and Social Affairs, Statistics Division. UN Comtrade Database. United States of America. ", config_list$source_year, ". [https://comtrade.un.org/data]."))

# Join items
wheat_sheet_comtrade <- list(names, wheat_grain_imports_data, wheat_grain_exports_data, wheat_flour_imports_data, 
                             wheat_flour_exports_data, wheat_flour_products_imports_data, 
                             wheat_flour_products_exports_data) %>% 
  reduce(left_join, by = "country_name")

#export 
file_name_2 <- paste0("Output_CSV_Files/wheat_comtrade_", config_list$year, ".csv")
write.csv(wheat_sheet_comtrade, 
          file = here::here(file_name_2))
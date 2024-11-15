pacman::p_load(tidyverse, here)

# specify file location relative to project folder
here::i_am("Code/maize_comtrade.R")

# get year parameter
config_list <- config::get()

# read in comtrade data and country names
file_name_1 <- paste0("Cleaned_Data/comtrade_data_", config_list$year, ".rds")
comtrade_data <- readRDS(file = here::here(file_name_1))

names <- read.csv(here::here("Raw_Data/nonfao_country_names.csv"), header = TRUE)

# compile maize data
# Maize (Grain) Imports
maize_grain_imports_data <- comtrade_data %>% filter(CmdCode == "1005", FlowDesc == "Export") %>%
  group_by(PartnerDesc) %>%
  mutate(Total = sum(Qty)/1000) %>%
  select(PartnerDesc, Total) %>%
  distinct(PartnerDesc, .keep_all = TRUE) %>%
  rename(country_name = PartnerDesc, maize_grain_imports = Total) %>%
  mutate(source_maize_grain_imports = paste0("United Nations, Department of Economic and Social Affairs, Statistics Division. UN Comtrade Database. United States of America. ", config_list$source_year, ". [https://comtrade.un.org/data]."))


# Maize (Grain) Exports
maize_grain_exports_data <- comtrade_data %>% filter(CmdCode == "1005", FlowDesc == "Import") %>%
  group_by(PartnerDesc) %>%
  mutate(Total = sum(Qty)/1000) %>%
  select(PartnerDesc, Total) %>%
  distinct(PartnerDesc, .keep_all = TRUE) %>%
  rename(country_name = PartnerDesc, maize_grain_exports = Total) %>%
  mutate(source_maize_grain_exports = paste0("United Nations, Department of Economic and Social Affairs, Statistics Division. UN Comtrade Database. United States of America. ", config_list$source_year, ". [https://comtrade.un.org/data]."))


# Maize Flour Imports
maize_flour_imports_data <- comtrade_data %>% filter(CmdCode == "110220", FlowDesc == "Export") %>%
  group_by(PartnerDesc) %>%
  mutate(Total = sum(Qty)/1000) %>%
  select(PartnerDesc, Total) %>%
  distinct(PartnerDesc, .keep_all = TRUE) %>%
  rename(country_name = PartnerDesc, maize_flour_imports = Total) %>%
  mutate(source_maize_flour_imports = paste0("United Nations, Department of Economic and Social Affairs, Statistics Division. UN Comtrade Database. United States of America. ", config_list$source_year, ". [https://comtrade.un.org/data]."))


# Maize Flour Exports
maize_flour_exports_data <- comtrade_data %>% filter(CmdCode == "110220", FlowDesc == "Import") %>%
  group_by(PartnerDesc) %>%
  mutate(Total = sum(Qty)/1000) %>%
  select(PartnerDesc, Total) %>%
  distinct(PartnerDesc, .keep_all = TRUE) %>%
  rename(country_name = PartnerDesc, maize_flour_exports = Total) %>%
  mutate(source_maize_flour_exports = paste0("United Nations, Department of Economic and Social Affairs, Statistics Division. UN Comtrade Database. United States of America. ", config_list$source_year, ". [https://comtrade.un.org/data]."))


# Maize Flour Products Imports
maize_flour_products_imports_data <- comtrade_data %>% filter(CmdCode %in% c("230210", "110812"), 
                                                                 FlowDesc == "Export") %>%
  group_by(PartnerDesc) %>%
  mutate(Total = sum(Qty)/1000) %>%
  select(PartnerDesc, Total) %>%
  distinct(PartnerDesc, .keep_all = TRUE) %>%
  rename(country_name = PartnerDesc, maize_flour_products_imports = Total) %>%
  mutate(source_maize_flour_products_imports = paste0("United Nations, Department of Economic and Social Affairs, Statistics Division. UN Comtrade Database. United States of America. ", config_list$source_year, ". [https://comtrade.un.org/data]."))


# Maize Flour Products Exports 
maize_flour_products_exports_data <- comtrade_data %>% filter(CmdCode %in% c("230210", "110812"), 
                                                                 FlowDesc == "Import") %>%
  group_by(PartnerDesc) %>%
  mutate(Total = sum(Qty)/1000) %>%
  select(PartnerDesc, Total) %>%
  distinct(PartnerDesc, .keep_all = TRUE) %>%
  rename(country_name = PartnerDesc, maize_flour_products_exports = Total) %>%
  mutate(source_maize_flour_products_exports = paste0("United Nations, Department of Economic and Social Affairs, Statistics Division. UN Comtrade Database. United States of America. ", config_list$source_year, ". [https://comtrade.un.org/data]."))

# Join items
maize_sheet_comtrade <- list(names, maize_grain_imports_data, maize_grain_exports_data, 
                             maize_flour_imports_data, maize_flour_exports_data, 
                             maize_flour_products_imports_data, 
                             maize_flour_products_exports_data) %>% 
  reduce(left_join, by = "country_name")

#export 
file_name_2 <- paste0("Output_CSV_Files/maize_comtrade_", config_list$year, ".csv")
write.csv(maize_sheet_comtrade, file = here::here(file_name_2))












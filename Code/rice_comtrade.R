# load packages
pacman::p_load(tidyverse, here)

# specify file location relative to project folder
here::i_am("Code/rice_comtrade.R")

# get year parameter
config_list <- config::get()

# read in comtrade data and country names
file_name_1 <- paste0("Cleaned_Data/comtrade_data_", config_list$year, ".rds")
comtrade_data <- readRDS(here::here(file_name_1))

names <- read.csv(here::here("Raw_Data/nonfao_country_names.csv"), header = TRUE)

# compile rice data
# Rice (Grain) Imports
rice_grain_imports_data <- comtrade_data %>% filter(CmdCode == "1006", FlowDesc == "Export") %>%
  group_by(PartnerDesc) %>%
  mutate(Total = sum(Qty)/1000) %>%
  select(PartnerDesc, Total) %>%
  distinct(PartnerDesc, .keep_all = TRUE) %>%
  rename(country_name = PartnerDesc, rice_grain_imports = Total) %>%
  mutate(source_rice_grain_imports = paste0("United Nations, Department of Economic and Social Affairs, Statistics Division. UN Comtrade Database. United States of America. ", config_list$source_year, ". [https://comtrade.un.org/data]."))

# Rice (Grain) Exports
rice_grain_exports_data <- comtrade_data %>% filter(CmdCode == "1006", FlowDesc == "Import") %>%
  group_by(PartnerDesc) %>%
  mutate(Total = sum(Qty)/1000) %>%
  select(PartnerDesc, Total) %>%
  distinct(PartnerDesc, .keep_all = TRUE) %>%
  rename(country_name = PartnerDesc, rice_grain_exports = Total) %>%
  mutate(source_rice_grain_exports = paste0("United Nations, Department of Economic and Social Affairs, Statistics Division. UN Comtrade Database. United States of America. ", config_list$source_year, ". [https://comtrade.un.org/data]."))

# Join items
rice_sheet_comtrade <- list(names, rice_grain_imports_data, rice_grain_exports_data) %>% 
  reduce(left_join, by = "country_name")

#export 
file_name_2 <- paste0("Output_CSV_Files/rice_comtrade_", config_list$year, ".csv")
write.csv(rice_sheet_comtrade, 
          file = here::here(file_name_2))








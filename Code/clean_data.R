# load packages
pacman::p_load(tidyverse, here)

# specify file location relative to project folder
here::i_am("Code/clean_data.R")

# get year parameter
config_list <- config::get()

# read in comtrade and nonFAO data
file_name_1 <- paste0("Raw_Data/nonfao_production_data_", config_list$year, ".csv")
nonfao_production_data <- read.csv(here::here(file_name_1), header = TRUE)

file_name_2 <- paste0("Raw_Data/nonfao_trade_data_", config_list$year, ".csv")
nonfao_trade_data <- read.csv(here::here(file_name_2), header = TRUE)

file_name_3 <- paste0("Raw_Data/comtrade_data_", config_list$year, ".csv")
comtrade_data <- read.csv(here::here(file_name_3), header = TRUE)

# recode nonfao country names
nonfao_production_data <- nonfao_production_data %>% mutate(Area = recode(Area, 
                                                                          'Palestine' = "Palestine, State of"))
nonfao_trade_data <- nonfao_trade_data %>% mutate(Area = recode(Area, 
                                                                'Palestine' = "Palestine, State of"))

# recode country names
comtrade_data <- comtrade_data %>% mutate(PartnerDesc = recode(PartnerDesc, 
                                                               'Br. Indian Ocean Terr.' = 'British Indian Ocean Territory',
                                                               'Br. Virgin Isds' = 'British Virgin Islands',
                                                               'Cayman Isds' = 'Cayman Islands',
                                                               'Christmas Isds' = 'Christmas Island',
                                                               'Cocos Isds' = 'Cocos (Keelings) Islands',
                                                               'Falkland Isds (Malvinas)' = 'Falkland Islands (Malvinas)',
                                                               'French Guiana (Overseas France)' = 'French Guiana',
                                                               'Guadeloupe (Overseas France)' = 'Guadeloupe',
                                                               'Kosovo' = 'Kosovo, Republic of',
                                                               'Marshall Isds' = 'Marshall Islands',
                                                               'Martinique (Overseas France)' = 'Martinique',
                                                               'Mayotte (Overseas France)' = 'Mayotte',
                                                               'Netherlands Antilles (...2010)' = 'Netherlands Antilles',
                                                               'Norfolk Isds' = 'Norfolk Island',
                                                               'N. Mariana Isds' = 'Northern Mariana Islands',
                                                               'Pitcairn' = 'Pitcairn Islands',
                                                               'Turks and Caicos Isds' = 'Turks and Caicos Islands',
                                                               'US Virgin Isds (...1980)' = 'United States Virgin Islands',
                                                               'Holy See (Vatican City State)' = 'Vatican City',
                                                               'Wallis and Futana Isds' = 'Wallis and Futana Islands')) 

# export cleaned data
file_name_4 <- paste0("Cleaned_Data/nonfao_production_data_", config_list$year, ".rds")
saveRDS(
  nonfao_production_data, 
  file = here::here(file_name_4)
)

file_name_5 <- paste0("Cleaned_Data/nonfao_trade_data_", config_list$year, ".rds")
saveRDS(
  nonfao_trade_data, 
  file = here::here(file_name_5)
)

file_name_6 <- paste0("Cleaned_Data/comtrade_data_", config_list$year, ".rds")
saveRDS(
  comtrade_data, 
  file = here::here(file_name_6)
)

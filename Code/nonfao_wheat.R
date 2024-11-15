# load packages
pacman::p_load(tidyverse, here)

# specify file location relative to project folder
here::i_am("Code/nonfao_wheat.R")

# get year parameter
config_list <- config::get()

# read in CSV files
file_name_1 <- paste0("Output_CSV_Files/wheat_cropslivestock", config_list$year, ".csv")
wheat_sheet_cropslivestock <- read.csv(here::here(file_name_1), header = TRUE)

file_name_2 <- paste0("Output_CSV_Files/wheat_comtrade_", config_list$year, ".csv")
wheat_sheet_comtrade <- read.csv(here::here(file_name_2), header = TRUE)

# merge comtrade and fao wheat sheets
wheat_final <- wheat_sheet_cropslivestock %>% rows_patch(wheat_sheet_comtrade, by = "country_name") 

# create empty columns for wheat supply and wheat intake
wheat_supply = NA
source_wheat_supply = NA

wheat_final <- add_column(wheat_final, wheat_supply, .after = "country_name")
wheat_final <- add_column(wheat_final, source_wheat_supply, .after = "wheat_supply")

wheat_final[ , 'wheat_intake'] = NA
wheat_final[ , 'source_wheat_intake'] = NA

# turn NA's into blanks
wheat_final[is.na(wheat_final)] <- " "

# remove first column
wheat_final = subset(wheat_final, select = -X)

# export data
file_name_3 <- paste0("Final_Output/nonfao_wheat_", config_list$year, ".csv")
write.csv(wheat_final, 
          file = here::here(file_name_3),
          row.names = FALSE)

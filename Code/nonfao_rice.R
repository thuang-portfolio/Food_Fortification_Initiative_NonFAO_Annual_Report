# load packages
pacman::p_load(tidyverse, here)

# specify file location relative to project folder
here::i_am("Code/nonfao_rice.R")

# get year parameter
config_list <- config::get()

# read in CSV files
file_name_1 <- paste0("Output_CSV_Files/rice_cropslivestock", config_list$year, ".csv")
rice_sheet_cropslivestock <- read.csv(here::here(file_name_1), header = TRUE)

file_name_2 <- paste0("Output_CSV_Files/rice_comtrade_", config_list$year, ".csv")
rice_sheet_comtrade <- read.csv(here::here(file_name_2), header = TRUE)

# merge comtrade and fao wheat sheets
rice_final <- rice_sheet_cropslivestock %>% rows_patch(rice_sheet_comtrade, by = "country_name") 

# create empty columns for rice supply and rice intake
rice_supply = NA
source_rice_supply = NA

rice_final <- add_column(rice_final, rice_supply, .after = "country_name")
rice_final <- add_column(rice_final, source_rice_supply, .after = "rice_supply")

rice_final[ , 'rice_intake'] = NA
rice_final[ , 'source_rice_intake'] = NA

# turn NA's into blanks
rice_final[is.na(rice_final)] <- " "

# remove first column
rice_final = subset(rice_final, select = -X)

# export data
file_name_3 <- paste0("Final_Output/nonfao_rice_", config_list$year, ".csv")
write.csv(rice_final, 
          file = here::here(file_name_3),
          row.names = FALSE)
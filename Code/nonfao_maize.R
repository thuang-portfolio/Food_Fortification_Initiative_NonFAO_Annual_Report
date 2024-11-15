# load packages
pacman::p_load(tidyverse, here)

# specify file location relative to project folder
here::i_am("Code/nonfao_maize.R")

# get year parameter
config_list <- config::get()

# read in CSV files
file_name_1 <- paste0("Output_CSV_Files/maize_cropslivestock", config_list$year, ".csv")
maize_sheet_cropslivestock <- read.csv(here::here(file_name_1), header = TRUE)

file_name_2 <- paste0("Output_CSV_Files/maize_comtrade_", config_list$year, ".csv")
maize_sheet_comtrade <- read.csv(here::here(file_name_2), header = TRUE)

# merge comtrade and fao maize sheets
maize_final <- maize_sheet_cropslivestock %>% rows_patch(maize_sheet_comtrade, by = "country_name") 

# create empty columns for maize supply and maize intake
maize_supply = NA
source_maize_supply = NA

maize_final <- add_column(maize_final, maize_supply, .after = "country_name")
maize_final <- add_column(maize_final, source_maize_supply, .after = "maize_supply")

maize_final[ , 'maize_intake'] = NA
maize_final[ , 'source_maize_intake'] = NA

# turn NA's into blanks
maize_final[is.na(maize_final)] <- " "

# remove first column
maize_final = subset(maize_final, select = -X)

# export data
file_name_3 <- paste0("Final_Output/nonfao_maize_", config_list$year, ".csv")
write.csv(maize_final, 
          file = here::here(file_name_3),
          row.names = FALSE)
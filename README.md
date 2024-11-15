# Prep 

Follow the instructions in the "Non-FAO Data Compilation in R" SOP

# Project Directory Description
[replace YEAR with whatever the year of the current annual report is]

-   `Raw_Data/` folder should eventually contain the four raw uncleaned CSV files

    -   "nonfao_trade_data_YEAR.csv"
    -   "nonfao_production_data_YEAR.csv"
    -   "comtrade_data_YEAR.csv"
    -   "nonfao_country_names.csv"

-   `Cleaned_Data/` folder should eventually contain the three cleaned RDS files

    -   "nonfao_trade_data_YEAR.rds"
    -   "nonfao_production_data_YEAR.rds"
    -   "comtrade_data_YEAR.rds"

-   `Output_CSV_Files/` folder should eventually contain six CSV files (three are sheets
    with FAO crops and livestocks data and three are sheets with
    Comtrade data) 

    -   "wheat_cropslivestock_YEAR.csv"
    -   "wheat_comtrade_YEAR.csv"
    -   "maize_cropslivestock_YEAR.csv"
    -   "maize_comtrade_YEAR.csv"
    -   "rice_cropslivestock_YEAR.csv"
    -   "rice_comtrade_YEAR.csv"

-   `Final_Output/` folder should eventually contain three final CSV files that merge FAO
    crops and livestocks data with Comtrade data for each grain

    -   "nonfao_wheat_YEAR.csv"
    -   "nonfao_maize_YEAR.csv"
    -   "nonfao_rice_YEAR.csv"

-   `Code/` folder contains R scripts described below

-   `Makefile` is a document that specifies how to build the three final
    merged grain sheets automatically. Essentially, it contains rules to
    create each output so one can use a shortcut and doesn't have to run
    all of the individual R code scripts separately.

-   `config.yml` is a document that specifies a parameter or variable
    that we don't want hard-coded into any of the code since it can
    change. It contains two parameters (the year of the current annual
    report and the year of the sources) so file names can be customized to the current annual
    report's year.

# Code Description

-   `code/clean_data.R`:
    -   clean FAO Crops and Livestocks and Comtrade data from `Raw_Data/` folder
    -   save cleaned data in `Cleaned_Data/` folder
-   `code/wheat_cropslivestock.R`:
    -   read in and compile FAO Crops and Livestocks trade and
        production data from `Raw_Data/` folder for wheat
    -   save wheat sheet in `Output_CSV_Files/` folder
-   `code/maize_cropslivestock.R`:
    -   read in and compile FAO Crops and Livestocks trade and
        production data from `Raw_Data/` folder for maize
    -   save maize sheet in `Output_CSV_Files/` folder
-   `code/rice_cropslivestock.R`:
    -   read in and compile FAO Crops and Livestocks trade and
        production data from `Raw_Data/` folder for rice
    -   save rice sheet in `Output_CSV_Files/` folder
-   `code/wheat_comtrade.R`:
    -   read in and compile Comtrade data from `Raw_Data/` folder for
        wheat
    -   save wheat sheet in `Output_CSV_Files/` folder
-   `code/maize_comtrade.R`:
    -   read in and compile Comtrade data from `Raw_Data/` folder for
        maize
    -   save maize sheet in `Output_CSV_Files/` folder
-   `code/rice_comtrade.R`:
    -   read in and compile Comtrade data from `Raw_Data/` folder for
        rice
    -   save rice sheet in `Output_CSV_Files/` folder
-   `code/nonfao_wheat.R`:
    -   merge FAO Crops and Livestocks and Comtrade wheat sheets
    -   save merged wheat sheet in `Final_Output/` folder
-   `code/nonfao_maize.R`:
    -   merge FAO Crops and Livestocks and Comtrade maize sheets
    -   save merged maize sheet in `Final_Output/` folder
-   `code/nonfao_rice.R`:
    -   merge FAO Crops and Livestocks and Comtrade rice sheets
    -   save merged rice sheet in `Final_Output/` folder

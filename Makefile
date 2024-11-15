# grouped make rule to create all three merged grain CSV files
.PHONY: merged_files
merged_files: Final_Output/nonfao_wheat_${YEAR}.csv Final_Output/nonfao_maize_${YEAR}.csv Final_Output/nonfao_rice_${YEAR}.csv

# make rules for final merged grain sheets
Final_Output/nonfao_wheat_${YEAR}.csv: Code/nonfao_wheat.R Output_CSV_Files/wheat_cropslivestock_${YEAR}.csv Output_CSV_Files/wheat_comtrade_${YEAR}.csv 
	Rscript Code/nonfao_wheat.R

Final_Output/nonfao_maize_${YEAR}.csv: Code/nonfao_maize.R Output_CSV_Files/maize_cropslivestock_${YEAR}.csv Output_CSV_Files/maize_comtrade_${YEAR}.csv
	Rscript Code/nonfao_maize.R

Final_Output/nonfao_rice_${YEAR}.csv: Code/nonfao_rice.R Output_CSV_Files/rice_cropslivestock_${YEAR}.csv Output_CSV_Files/rice_comtrade_${YEAR}.csv
	Rscript Code/nonfao_rice.R
	
# make rules for fao crops and livestocks sheets
Output_CSV_Files/wheat_cropslivestock_${YEAR}.csv: Code/wheat_cropslivestock.R Cleaned_Data/nonfao_trade_data_${YEAR}.rds Cleaned_Data/nonfao_production_data_${YEAR}.rds Raw_Data/nonfao_country_names.csv 
	Rscript Code/wheat_cropslivestock.R

Output_CSV_Files/maize_cropslivestock_${YEAR}.csv: Code/maize_cropslivestock.R Cleaned_Data/nonfao_trade_data_${YEAR}.rds Cleaned_Data/nonfao_production_data_${YEAR}.rds Raw_Data/nonfao_country_names.csv
	Rscript Code/maize_cropslivestock.R

Output_CSV_Files/rice_cropslivestock_${YEAR}.csv: Code/rice_cropslivestock.R Cleaned_Data/nonfao_trade_data_${YEAR}.rds Cleaned_Data/nonfao_production_data_${YEAR}.rds Raw_Data/nonfao_country_names.csv
	Rscript Code/rice_cropslivestock.R

# make rules for comtrade sheets
Output_CSV_Files/wheat_comtrade_${YEAR}.csv: Code/wheat_comtrade.R Cleaned_Data/comtrade_data_${YEAR}.rds Raw_Data/nonfao_country_names.csv 
	Rscript Code/wheat_comtrade.R

Output_CSV_Files/maize_comtrade_${YEAR}.csv: Code/maize_comtrade.R Cleaned_Data/comtrade_data_${YEAR}.rds Raw_Data/nonfao_country_names.csv
	Rscript Code/maize_comtrade.R

Output_CSV_Files/rice_comtrade_${YEAR}.csv: Code/rice_comtrade.R Cleaned_Data/comtrade_data_${YEAR}.rds Raw_Data/nonfao_country_names.csv
	Rscript Code/rice_comtrade.R

# make rules for cleaned data	
Cleaned_Data/nonfao_trade_data_${YEAR}.rds: Code/clean_data.R Raw_Data/nonfao_trade_data_${YEAR}.csv
	Rscript Code/clean_data.R

Cleaned_Data/nonfao_production_data_${YEAR}.rds: Code/clean_data.R Raw_Data/nonfao_production_data_${YEAR}.csv
	Rscript Code/clean_data.R

Cleaned_Data/comtrade_data_${YEAR}.rds: Code/clean_data.R Raw_Data/comtrade_data_${YEAR}.csv
	Rscript Code/clean_data.R
	
# make clean rule
clean: 
	rm Cleaned_Data/*.rds && rm Output_CSV_Files/*.csv && rm Final_Output/*.csv
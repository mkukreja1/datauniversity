# Usage: Run following command on Cloudera VM Terminal  
# rm -rf covid;sh download_covid.sh;ls -l covid


#!/bin/bash

# Ask the user regarding the start date and end date for downloading 
echo Enter the start date and end date for which data has to be downloaded 
read -p "Enter Start date in yyyy-mm-dd: " num1
read -p "Enter end date in yyyy-mm-dd: " num2
echo echo Downloading date from $num1 till $num2
echo

START_DATE=$num1
END_DATE=$num2    

# Define Linux and Hadoop Directories
BASE_DIR=/home/cloudera/covid
DATA_DIR=/data/covid


# Loop from the start date till end date. Each time download the file and save the file to a dated folder
DOWNLOAD_DATE="$START_DATE"
while [[ "$DOWNLOAD_DATE" < "$END_DATE" ]]; do
  echo $DOWNLOAD_DATE
  COVID_DATE=$( date -d $DOWNLOAD_DATE +%m-%d-%Y ) 
  echo $COVID_DATE  
  mkdir -p $BASE_DIR/$DOWNLOAD_DATE  
  wget "https://github.com/CSSEGISandData/COVID-19/blob/master/csse_covid_19_data/csse_covid_19_daily_reports/$COVID_DATE.csv" -O $BASE_DIR/$DOWNLOAD_DATE/$COVID_DATE.csv    
  DOWNLOAD_DATE=$(date -I -d "$DOWNLOAD_DATE + 1 day")
done


# Save downloaded files to Hadoop
hadoop fs -rm -r $DATA_DIR
hadoop fs -mkdir -p $DATA_DIR
hadoop fs -put $BASE_DIR/* $DATA_DIR
hadoop fs -ls $DATA_DIR

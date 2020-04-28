CREATE DATABASE IF NOT EXISTS ${hive_db_name};
USE ${hive_db_name};

DROP TABLE IF EXISTS ${hive_ext_table_raw_data};

CREATE EXTERNAL TABLE ${hive_ext_table_raw_data} (Year string,Month string,DayofMonth string,DayOfWeek string,DepTime string,CRSDepTime string,ArrTime string,CRSArrTime string,UniqueCarrier string,FlightNum string,TailNum string,ActualElapsedTime string,CRSElapsedTime string,AirTime string,ArrDelay string,DepDelay string,Origin string,Dest string,Distance string,TaxiIn string,TaxiOut string,Cancelled string,CancellationCode string,Diverted string,CarrierDelay string,WeatherDelay string,NASDelay string,SecurityDelay string,LateAircraftDelay string)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE LOCATION  '${hdfs_dir_raw_data}';





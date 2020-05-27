import sys
from pyspark import SparkContext, SparkConf, HiveContext
from pyspark.sql.functions import split
from pyspark.sql import SQLContext
from pyspark.sql import HiveContext
import argparse

"# -------------------------------------------------------------------------\n",
"# Define Variables\n",
"# Use PRODUCTION=False for Development\n",
"# Use PRODUCTION=True for Production\n",
"# -------------------------------------------------------------------------\n",
    
PRODUCTION=True

if PRODUCTION:
    parser = argparse.ArgumentParser()
    parser.add_argument('--job_date', dest='job_date')
    parser.add_argument('--hdfs_orders_path', dest='hdfs_orders_path')
    parser.add_argument('--hdfs_orders_details_path', dest='hdfs_orders_details_path')
    parser.add_argument('--hdfs_customers_path', dest='hdfs_customers_path')
    parser.add_argument('--hive_db', dest='hive_db')
    parser.add_argument('--hive_table', dest='hive_table')
    args = parser.parse_args()
    
    job_date=args.job_date
    hdfs_orders_path=args.hdfs_orders_path
    hdfs_orders_details_path=args.hdfs_orders_details_path
    hdfs_customers_path=args.hdfs_customers_path
    hive_db=args.hive_db
    hive_table=args.hive_table
    
else:
    job_date='20200526'
    hdfs_orders_path='hdfs://quickstart.cloudera:8020/data/orders/orders'
    hdfs_orders_details_path='hdfs://quickstart.cloudera:8020/data/orders/orderdetails'
    hdfs_customers_path='hdfs://quickstart.cloudera:8020/data/orders/customers'
    hive_db='orders'
    hive_table='products'

def read_orders(path):
    orders=sc.textFile(path)
    ordersrdd=orders.map(lambda line: (line.split('|')[0].strip('"'), 
                                       line.split('|')[1].strip('"'),
                                       line.split('|')[2].strip('"'),
                                       line.split('|')[3].strip('"'), 
                                       line.split('|')[4].strip('"'),
                                       line.split('|')[5].strip('"'),
                                       line.split('|')[6].strip('"'))).collect()

    df_orders=hiveContext.createDataFrame(ordersrdd, schema=['orderNumber', 'orderDate', 
                                                            'requiredDate', 'shippedDate', 
                                                            'status', 'comments', 
                                                            'customerNumber'])
    df_orders.registerTempTable('myorders')
    df_orders.show(2)


def read_orders_details(path):
    orderdetails=sc.textFile(path)
    orderdetailsrdd=orderdetails.map(lambda line: (line.split('|')[0].strip('"'), 
                                                   line.split('|')[1].strip('"'),
                                                   line.split('|')[2].strip('"'), 
                                                   line.split('|')[3].strip('"'),
                                                   line.split('|')[4].strip('"'))).collect()
    df_orderdetails=hiveContext.createDataFrame(orderdetailsrdd, 
                                               schema=['orderNumber', 'productCode', 
                                                       'quantityOrdered', 'priceEach', 
                                                       'orderLineNumber'])
    df_orderdetails.registerTempTable('myorderdetails')
    df_orderdetails.show(2)


def read_customers(path):
    customers=sc.textFile(path)
    customersrdd=customers.map(lambda line: (line.split('|')[0].strip('"'), 
                                       line.split('|')[1].strip('"'),
                                       line.split('|')[2].strip('"'),
                                       line.split('|')[3].strip('"'), 
                                       line.split('|')[4].strip('"'),
                                       line.split('|')[5].strip('"'),
                                       line.split('|')[6].strip('"'),
                                       line.split('|')[7].strip('"'),
                                       line.split('|')[8].strip('"'),
                                       line.split('|')[9].strip('"'), 
                                       line.split('|')[10].strip('"'),
                                       line.split('|')[11].strip('"'),
                                       line.split('|')[12].strip('"'))).collect()
    df_customers=hiveContext.createDataFrame(customersrdd, schema=['customerNumber', 'customerName',          
                                                                        'contactLastName', 'contactFirstName',      
                                                                        'phone', 'addressLine1',          
                                                                        'addressLine2', 'city',                  
                                                                        'state', 'postalCode',            
                                                                        'country', 'salesRepEmployeeNumber',
                                                                        'creditLimit' ])
    df_customers.registerTempTable('mycustomers')
    df_customers.show(2)

def write_products():
    product_sql =  " SELECT od.productCode, o.orderDate, SUM(quantityOrdered) AS quantity" \
                   " FROM myorderdetails od" \
                   " JOIN myorders o ON od.orderNumber=o.orderNumber " \
                   " GROUP BY od.productCode, o.orderDate"
    df_product  = hiveContext.sql(product_sql)
    df_product.show(5)
   
    df_product.registerTempTable('myproducts')

    hiveContext.sql("CREATE DATABASE IF NOT EXISTS " + hive_db)
    hiveContext.sql("DROP TABLE "  + hive_db + "." + hive_table)
    hiveContext.sql("CREATE TABLE "  + hive_db + "." + hive_table + " AS SELECT * FROM myproducts")

if __name__ == "__main__":
    conf = SparkConf().setAppName("Spark Products")
    sc = SparkContext(conf=conf)
    sqlContext = SQLContext(sc)
    hiveContext = HiveContext(sc)

    read_customers(hdfs_customers_path)
    read_orders(hdfs_orders_path)
    read_orders_details(hdfs_orders_details_path)  

    write_products()

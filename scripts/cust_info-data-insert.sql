/* ====================================================================
   Script Name: 07_Bulk_Insert_crm_cust_info.sql
   
   Purpose:     
   Performs a high-performance bulk data load from a flat CSV file 
   into the bronze.crm_cust_info ingestion table. This script uses 
   optimized engine locks and precise delimiter definitions to ensure 
   clean parsing of raw data.
   ==================================================================== */

BULK INSERT bronze.crm_cust_info
FROM 'G:\SQL Datawarehouse Project\bronze_crm_cust_info_1000-v2.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',   
    FORMAT = 'CSV',         
    TABLOCK
);
GO
--Validate the rows inserted using
SELECT * FROM [bronze].[crm_cust_info]

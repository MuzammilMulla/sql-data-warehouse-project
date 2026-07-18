/* ====================================================================
   Script Name:  Bronze Layer Bulk Ingestion and Verification
   Description:  Bulk inserts raw CSV data into the Bronze schema tables 
                 and performs initial verification via TOP 10 selections.
   ==================================================================== */

-- Bulk insert into crm_cust_info
BULK INSERT [bronze].[crm_cust_info]
FROM 'G:\SQL Datawarehouse Project\Udemy\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);

-- Bulk insert into crm_prd_info
BULK INSERT [bronze].[crm_prd_info]
FROM 'G:\SQL Datawarehouse Project\Udemy\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);

-- Bulk insert into crm_sales_details
BULK INSERT [bronze].[crm_sales_details]
FROM 'G:\SQL Datawarehouse Project\Udemy\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);

-- Bulk insert into crm_sales_details (Duplicate statement from source script)
BULK INSERT [bronze].[crm_sales_details]
FROM 'G:\SQL Datawarehouse Project\Udemy\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);

-- Bulk insert into erp_cust_az12
BULK INSERT [bronze].[erp_cust_az12]
FROM 'G:\SQL Datawarehouse Project\Udemy\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);

-- Bulk insert into erp_loc_a101
BULK INSERT [bronze].[erp_loc_a101]
FROM 'G:\SQL Datawarehouse Project\Udemy\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);

-- Bulk insert into erp_px_cat_g1v2
BULK INSERT [bronze].[erp_px_cat_g1v2]
FROM 'G:\SQL Datawarehouse Project\Udemy\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);

/* ====================================================================
   Verification Section: Select top 10 rows from each table
   ==================================================================== */

SELECT TOP 10 * FROM [bronze].[crm_cust_info];
SELECT TOP 10 * FROM [bronze].[crm_prd_info];
SELECT TOP 10 * FROM [bronze].[crm_sales_details];
SELECT TOP 10 * FROM [bronze].[erp_cust_az12];
SELECT TOP 10 * FROM [bronze].[erp_loc_a101];
SELECT TOP 10 * FROM [bronze].[erp_px_cat_g1v2];

/* ====================================================================
   Script Name:  load_bronze
   Description:  Creates or alters the stored procedure [bronze].[load_bronze].
                 This procedure performs a full load (Truncate and Reload) of all
                 tables in the Bronze layer by bulk inserting raw CSV data from 
                 both CRM and ERP source systems.
                 
   Features:     - Tracks and logs execution time and duration.
                 - Uses TRY...CATCH for basic error handling.
                 - Includes a post-execution verification script to inspect 
                   the top 10 rows of loaded data.
   ==================================================================== */

CREATE OR ALTER PROCEDURE bronze.load_bronze 
AS
BEGIN 
    BEGIN TRY
        -- Declare variables for execution time tracking
        DECLARE @startTime DATETIME, @endtime DATETIME;
        SET @startTime = GETDATE();

        PRINT '=================================================';
        PRINT 'LOADING BRONZE LAYER';
        PRINT '=================================================';

        /* --------------------------------------------------------------
           1. LOAD CRM TABLES
           -------------------------------------------------------------- */
        PRINT '-----------------------------';
        PRINT 'LOADING CRM TABLES';
        PRINT '-----------------------------';
        
        -- Truncate and Bulk Insert: crm_cust_info
        PRINT CHAR(10) + 'TRUNCATING AND LOADING TABLE :[bronze].[crm_cust_info]';
        TRUNCATE TABLE [bronze].[crm_cust_info];
        BULK INSERT [bronze].[crm_cust_info]
        FROM 'G:\SQL Datawarehouse Project\Udemy\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        -- Truncate and Bulk Insert: crm_prd_info
        PRINT CHAR(10) + 'TRUNCATING AND LOADING TABLE :[bronze].[crm_prd_info]';
        TRUNCATE TABLE [bronze].[crm_prd_info];
        BULK INSERT [bronze].[crm_prd_info]
        FROM 'G:\SQL Datawarehouse Project\Udemy\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        -- Truncate and Bulk Insert: crm_sales_details
        PRINT CHAR(10) + 'TRUNCATING AND LOADING TABLE :[bronze].[crm_sales_details]';
        TRUNCATE TABLE [bronze].[crm_sales_details];
        BULK INSERT [bronze].[crm_sales_details]
        FROM 'G:\SQL Datawarehouse Project\Udemy\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        /* --------------------------------------------------------------
           2. LOAD ERP TABLES
           -------------------------------------------------------------- */
        PRINT '-----------------------------';
        PRINT 'LOADING ERP TABLES';
        PRINT '-----------------------------';
        
        -- Truncate and Bulk Insert: erp_cust_az12
        PRINT CHAR(10) + 'TRUNCATING AND LOADING TABLE :[bronze].[erp_cust_az12]';
        TRUNCATE TABLE [bronze].[erp_cust_az12];
        BULK INSERT [bronze].[erp_cust_az12]
        FROM 'G:\SQL Datawarehouse Project\Udemy\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        -- Truncate and Bulk Insert: erp_loc_a101
        PRINT CHAR(10) + 'TRUNCATING AND LOADING TABLE :[bronze].[erp_loc_a101]';
        TRUNCATE TABLE [bronze].[erp_loc_a101];
        BULK INSERT [bronze].[erp_loc_a101]
        FROM 'G:\SQL Datawarehouse Project\Udemy\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        -- Truncate and Bulk Insert: erp_px_cat_g1v2
        PRINT CHAR(10) + 'TRUNCATING AND LOADING TABLE :[bronze].[erp_px_cat_g1v2]';
        TRUNCATE TABLE [bronze].[erp_px_cat_g1v2];
        BULK INSERT [bronze].[erp_px_cat_g1v2]
        FROM 'G:\SQL Datawarehouse Project\Udemy\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        /* --------------------------------------------------------------
           3. EXECUTION LOGGING & DURATION
           -------------------------------------------------------------- */
        SET @endtime = GETDATE();
        PRINT 'start time ' + CONVERT(VARCHAR(20), @startTime, 120) + ' end time ' + CONVERT(VARCHAR(20), @endtime, 120);
        PRINT 'Duration in seconds: ' + CAST(DATEDIFF(second, @startTime, @endtime) AS VARCHAR(10)); 

    END TRY
    BEGIN CATCH
        PRINT 'LOAD FAILED';
    END CATCH   
END

/* ====================================================================
   Verification Section: Select top 10 rows from each table
   ==================================================================== */
SELECT TOP 10 * FROM [bronze].[crm_cust_info];
SELECT TOP 10 * FROM [bronze].[crm_prd_info];
SELECT TOP 10 * FROM [bronze].[crm_sales_details];
SELECT TOP 10 * FROM [bronze].[erp_cust_az12];
SELECT TOP 10 * FROM [bronze].[erp_loc_a101];
SELECT TOP 10 * FROM [bronze].[erp_px_cat_g1v2];

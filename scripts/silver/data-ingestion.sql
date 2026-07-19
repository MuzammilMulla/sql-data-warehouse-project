/* ====================================================================
   Script Name:  Silver Layer Transformation & Load: crm_cust_info
   Description:  Cleans, standardizes, and deduplicates raw customer 
                 data from the Bronze layer before loading it into the 
                 Silver layer.
                 
   Source Table: [bronze].[crm_cust_info]
   Target Table: [silver].[crm_cust_info]
   
   Transformations Applied:
                 - Deduplication: Retains only the most recent record 
                   per customer ID (cst_id) based on cst_create_date.
                 - Text Cleaning: Trims whitespace from first and last names.
                 - Standardization: Maps gender and marital status codes
                   to full descriptive values (e.g., 'M' -> 'Male', 
                   'S' -> 'Single'); defaults missing/invalid to 'n/a'.
   ==================================================================== */

-- Insert cleaned and deduplicated records into Silver table
INSERT INTO [silver].[crm_cust_info] (
    cst_id, 
    cst_key, 
    cst_firstname, 
    cst_lastname, 
    cst_create_date, 
    cst_gndr, 
    cst_marital_status
)
SELECT 
    cst_id, 
    cst_key, 
    TRIM(cst_firstname) AS cst_firstname,
    TRIM(cst_lastname) AS cst_lastname,
    cst_create_date,
    -- Standardize Gender values
    CASE 
        WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
        WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
        ELSE 'n/a'
    END AS cst_gndr,	
    -- Standardize Marital Status values
    CASE 
        WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
        WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
        ELSE 'n/a'
    END AS cst_marital_status
FROM (
    -- Identify the most recent record per customer using ROW_NUMBER
    SELECT *,
           ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
    FROM [bronze].[crm_cust_info]
) t 
WHERE flag_last = 1;

/* ====================================================================
   Verification Section: Review loaded Silver data
   ==================================================================== */
SELECT * FROM [silver].[crm_cust_info];

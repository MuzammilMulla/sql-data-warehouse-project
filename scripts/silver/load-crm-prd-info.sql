/* =============================================================================
   Script: Data Quality & Profiling - Bronze CRM Product Info
   Description: Exploratory validation and transformation logic checks for 
                product attributes before loading into the silver layer.
   ============================================================================= */

-- =============================================================================
-- 1. Primary Key Validation
-- =============================================================================
-- Check for NULLs or duplicate product IDs
-- Result: No NULLs or duplicates found
SELECT 
    prd_id, 
    COUNT(*) AS cnt
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;


-- =============================================================================
-- 2. Exploratory Reference Queries
-- =============================================================================
-- SELECT TOP 10 * FROM bronze.crm_prd_info;
-- SELECT TOP 10 * FROM bronze.crm_sales_details;


-- =============================================================================
-- 3. String & Key Transformations
-- =============================================================================
-- Derive Category ID: Extract first 5 characters and replace '-' with '_'
SELECT 
    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id 
FROM bronze.crm_prd_info;

-- Derive Product Key: Extract substring from position 7 to the end
SELECT 
    SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key 
FROM bronze.crm_prd_info;


-- =============================================================================
-- 4. Text Cleanliness & Standardizations
-- =============================================================================
-- Check for leading or trailing whitespace in product names
-- Result: None found
SELECT prd_nm 
FROM bronze.crm_prd_info
WHERE LEN(prd_nm) != LEN(TRIM(prd_nm));

-- Inspect distinct product line codes
SELECT DISTINCT prd_line 
FROM bronze.crm_prd_info;

-- Map product line codes to descriptive names
SELECT 
    *, 
    CASE UPPER(TRIM(prd_line))
        WHEN 'M' THEN 'Mountain'
        WHEN 'R' THEN 'Road'
        WHEN 'S' THEN 'Other Sales'
        WHEN 'T' THEN 'Tour'
        ELSE 'n/a'
    END AS prd_line
FROM bronze.crm_prd_info;


-- =============================================================================
-- 5. Numeric Validation & Handling
-- =============================================================================
-- Identify invalid product costs (negative or NULL)
-- Result: 2 records found
SELECT prd_cost 
FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Final transformation: Default NULL product costs to 0
SELECT 
    ISNULL(prd_cost, 0) AS prd_cost 
FROM bronze.crm_prd_info;


-- =============================================================================
-- 6. Temporal Validation & SCD Type 2 Derivations
-- =============================================================================
-- Check for inverted date ranges (start date greater than end date)
SELECT * 
FROM bronze.crm_prd_info
WHERE prd_start_dt > prd_end_dt;

-- Final transformation: Standardize start date to DATE data type
SELECT 
    CAST(prd_start_dt AS DATE) AS prd_start_dt 
FROM bronze.crm_prd_info;

-- Final transformation: Derive historical end date using window function
-- Sets end date to 1 day before the next sequential start date for that product
SELECT 
    CAST(
        LEAD(prd_start_dt) OVER (
            PARTITION BY prd_key 
            ORDER BY prd_start_dt
        ) - 1 AS DATE
    ) AS new_end_date
FROM bronze.crm_prd_info;

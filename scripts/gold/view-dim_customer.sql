USE [Datawarehouse];
GO
--=============================================================
-- View Name : gold.dim_customer
-- Purpose   : Create the Customer Dimension for the Gold layer.
--
-- Business Logic:
--   1. Generate a surrogate key for each customer.
--   2. Retrieve customer details from CRM.
--   3. Enrich customer data with:
--      - Birth date and gender from ERP customer table.
--      - Country from ERP location table.
--   4. Prefer CRM gender when available.
--      If CRM gender is 'n/a', use ERP gender.
--      If ERP gender is also NULL, default to 'n/a'.
--=============================================================
CREATE VIEW gold.dim_customer
AS
SELECT
    -- Surrogate key for the dimension
    ROW_NUMBER() OVER (ORDER BY ci.cst_id) AS customer_key,
-- Customer identifiers
    ci.cst_id                AS customer_id,
    ci.cst_key               AS customer_number,
-- Customer details
    ci.cst_firstname         AS first_name,
    ci.cst_lastname          AS last_name,
-- Customer birth date from ERP
    ca.bdate                 AS birth_date,
-- Gender logic:
    -- 1. Use CRM gender if available.
    -- 2. Otherwise use ERP gender.
    -- 3. If ERP gender is NULL, return 'n/a'.
    CASE
        WHEN ci.cst_gndr <> 'n/a'
            THEN ci.cst_gndr
        ELSE COALESCE(ca.gen, 'n/a')
    END AS gender,
-- Customer country from ERP location
    la.cntry                 AS country,
-- Customer marital status from CRM
    ci.cst_marital_status    AS marital_status,
-- Customer creation date
    ci.cst_create_date       AS create_date
FROM silver.crm_cust_info AS ci
-- Join ERP customer information
LEFT JOIN silver.erp_cust_az12 AS ca
    ON ci.cst_key = ca.cid
-- Join ERP location information
LEFT JOIN silver.erp_loc_a101 AS la
    ON ci.cst_key = la.cid;

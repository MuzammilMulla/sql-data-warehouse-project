
/* ====================================================================
   Script Name: 02_Create_bronze_crm_cust_info.sql
   
   Purpose:     
   Creates the raw ingestion table for CRM customer information in the 
   bronze layer. This table stores untransformed customer data exactly 
   as received from the source CRM system.
   ==================================================================== */
IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE  bronze.crm_cust_info

CREATE TABLE bronze.crm_cust_info (
    cst_id             INT,          -- Customer ID (Source System ID)
    cst_key            NVARCHAR(50), -- Business Key / Alternate Key
    cst_firstname      NVARCHAR(50), -- Customer First Name
    cst_lastname       NVARCHAR(50), -- Customer Last Name
    cst_marital_status NVARCHAR(50), -- Marital Status
    cst_gndr           NVARCHAR(50), -- Gender Code/Text
    cst_create_date    DATE          -- Record Creation Date in Source
);
GO

/* ====================================================================
   Script Name: 03_Create_bronze_crm_prd_info.sql
   
   Purpose:     
   Creates the raw ingestion table for CRM product information in the 
   bronze layer. This table stores product catalog attributes exactly 
   as extracted from the source CRM database.
   ==================================================================== */

CREATE TABLE bronze.crm_prd_info (
    prd_id       INT,          -- Product System ID
    prd_key      NVARCHAR(50), -- Product Catalog Business Key
    prd_nm       NVARCHAR(50), -- Product Name
    prd_cost     INT,          -- Product Cost Amount
    prd_line     NVARCHAR(50), -- Product Line Classification
    prd_start_dt DATETIME,     -- Product Validity Start Date
    prd_end_dt   DATETIME      -- Product Validity End Date
);
GO

/* ====================================================================
   Script Name: 04_Create_bronze_crm_sales_details.sql
   
   Purpose:     
   Creates the raw ingestion table for CRM sales transactions in the 
   bronze layer. This table stores transactional order details exactly 
   as extracted from the source CRM database.
   ==================================================================== */

CREATE TABLE bronze.crm_sales_details (
    sls_ord_num  NVARCHAR(50), -- Sales Order Number (Transaction Key)
    sls_prd_key  NVARCHAR(50), -- Product Business Key (References Product)
    sls_cust_id  INT,          -- Customer System ID (References Customer)
    sls_order_dt DATE,         -- Order Date
    sls_ship_dt  DATE,         -- Shipment Date
    sls_due_dt   DATE,         -- Payment/Delivery Due Date
    sls_sales    INT,          -- Total Sales Amount
    sls_quantity INT,          -- Ordered Item Quantity
    sls_price    INT           -- Unit Price Amount
);
GO

/* ====================================================================
   Script Name: 05_Create_bronze_erp_tables.sql
   
   Purpose:     
   Creates raw ingestion tables for ERP system components (Location, 
   Customer demographics, and Product categories) in the bronze layer. 
   These tables store source-specific data exactly as extracted from 
   various ERP modules.
   ==================================================================== */

-- 1. ERP Location Data (Source: a101)
CREATE TABLE bronze.erp_loc_a101 (
    cid   NVARCHAR(50), -- Customer ID / Location Code
    cntry NVARCHAR(50)  -- Country Name or Code
);
GO

-- 2. ERP Customer Demographic Data (Source: az12)
CREATE TABLE bronze.erp_cust_az12 (
    cid   NVARCHAR(50), -- Customer ID
    bdate DATE,         -- Birth Date
    gen   NVARCHAR(50)  -- Gender / Sex Designator
);
GO

-- 3. ERP Product Category Mapping (Source: g1v2)
CREATE TABLE bronze.erp_px_cat_g1v2 (
    id           NVARCHAR(50), -- Category ID / Product Key Mapping
    cat          NVARCHAR(50), -- Core Category Name
    sucat        NVARCHAR(50), -- Sub-Category Name
    maintainance NVARCHAR(50)  -- Maintenance Description or Flag
);
GO


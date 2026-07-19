/* ====================================================================
   Script Name: create bronze layer schema
   
   Purpose:     
   Consolidates the database schema generation and initialization for 
   all operational ingestion tables within the bronze layer. 
   
   Tables Covered:
   1. crm_cust_info      - Core Customer Profile Data (CRM)
   2. crm_prd_info       - Product Catalog Properties (CRM)
   3. crm_sales_details  - Transactional Sales Orders (CRM)
   4. erp_loc_a101       - Customer Geographic Mappings (ERP)
   5. erp_cust_az12      - Customer Demographics & Birthdates (ERP)
   6. erp_px_cat_g1v2    - Product Category Structural Matrix (ERP)

   Prerequisites:
   - Database 'Datawarehouse' and schema 'bronze' must exist.
   - For BULK INSERT, convert your Excel sheets to CSV format 
     or point directly to your raw text file directory.
   ==================================================================== */

USE Datawarehouse;
GO



-- ====================================================================
-- SECTION 2: TABLE CREATION (BRONZE LAYER)
-- ====================================================================

-- 1. CRM Customer Master Info
CREATE TABLE bronze.crm_cust_info (
    cst_id             INT,          -- Customer ID (Source System ID)
    cst_key            NVARCHAR(50), -- Business Key / Alternate Key
    cst_firstname      NVARCHAR(50), -- Customer First Name
    cst_lastname       NVARCHAR(50), -- Customer Last Name
    cst_marital_status NVARCHAR(50), -- Marital Status
    cst_gndr           NVARCHAR(50), -- Gender Designation
    cst_create_date    DATE          -- Record Creation Date in Source
);
GO

-- 2. CRM Product Catalog Info
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

-- 3. CRM Sales Transaction Details
CREATE TABLE bronze.crm_sales_details (
    sls_ord_num  NVARCHAR(50), -- Sales Order Number (Transaction Key)
    sls_prd_key  NVARCHAR(50), -- Product Business Key (References Product)
    sls_cust_id  INT,          -- Customer System ID (References Customer)
    sls_order_dt DATE,         -- Order Placement Date
    sls_ship_dt  DATE,         -- Shipment Dispatch Date
    sls_due_dt   DATE,         -- Payment Payment Due Date
    sls_sales    INT,          -- Total Calculated Sales Amount
    sls_quantity INT,          -- Ordered Item Units/Quantity
    sls_price    INT           -- Unit Selling Price
);
GO

-- 4. ERP Geographic Location Map
CREATE TABLE bronze.erp_loc_a101 (
    cid   NVARCHAR(50), -- Customer Business Key Mapping
    cntry NVARCHAR(50)  -- Country Assigned Location
);
GO

-- 5. ERP Customer Demographic Profiles
CREATE TABLE bronze.erp_cust_az12 (
    cid   NVARCHAR(50), -- Customer Business Key Mapping
    bdate DATE,         -- Birth Date Record
    gen   NVARCHAR(50)  -- Customer Gender Vector
);
GO

-- 6. ERP Product Category Structural Map
CREATE TABLE bronze.erp_px_cat_g1v2 (
    id           NVARCHAR(50), -- Product Business Key Mapping
    cat          NVARCHAR(50), -- Core Super-Category Name
    sucat        NVARCHAR(50), -- Sub-Category Level Name
    maintainance NVARCHAR(50)  -- Maintenance Description Classification
);
GO


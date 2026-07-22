
/*============================================================
  Validation Check: Customer ID
  Verify that sls_cust_id exists in silver.crm_cust_info.
  Return records that do not have a matching customer.
============================================================*/

SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
FROM bronze.crm_sales_details
WHERE sls_cust_id NOT IN
(
    SELECT cst_id
    FROM silver.crm_cust_info
);



/*============================================================
  Validation Check: Product Key
  Verify that sls_prd_key exists in silver.crm_prd_info.
  Return records with invalid product keys.
============================================================*/

SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
FROM bronze.crm_sales_details
WHERE sls_prd_key NOT IN
(
    SELECT sls_prd_key
    FROM silver.crm_prd_info
);



/*============================================================
  Validation Check: Order Date
  Identify records where Order Date is:
    - 0
    - Not exactly 8 digits (YYYYMMDD)
============================================================*/

SELECT
    sls_order_dt
FROM bronze.crm_sales_details
WHERE LEN(sls_order_dt) <> 8
   OR sls_order_dt = 0;



/*============================================================
  Data Cleansing: Order Date
  Replace invalid values with NULL and convert valid values
  to DATE.
============================================================*/

SELECT
    CASE
        WHEN LEN(sls_order_dt) <> 8
          OR sls_order_dt = 0
            THEN NULL
        ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
    END AS sls_order_dt
FROM silver.crm_sales_details;



/*============================================================
  Data Cleansing: Ship Date
  Replace invalid values with NULL and convert valid values
  to DATE.
============================================================*/

SELECT
    CASE
        WHEN LEN(sls_ship_dt) <> 8
          OR sls_ship_dt = 0
            THEN NULL
        ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
    END AS sls_ship_dt
FROM bronze.crm_sales_details;



/*============================================================
  Data Cleansing: Due Date
  Replace invalid values with NULL and convert valid values
  to DATE.
============================================================*/

SELECT
    CASE
        WHEN LEN(sls_due_dt) <> 8
          OR sls_due_dt = 0
            THEN NULL
        ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
    END AS sls_due_dt
FROM bronze.crm_sales_details;



/*============================================================
  Validation Check: Date Sequence
  Verify chronological order:
      Order Date <= Ship Date <= Due Date

  Return records violating the expected sequence.
============================================================*/

SELECT
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
   OR sls_order_dt > sls_due_dt
   OR sls_ship_dt > sls_due_dt;



/*============================================================
  Validation Check: Sales Amount
  Identify records where Sales Amount is negative.
============================================================*/

SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
FROM bronze.crm_sales_details
WHERE sls_sales < 0;



/*============================================================
  Validation Check & Data Cleansing:
      - Sales Amount
      - Quantity
      - Price

  Rules:
    1. Price must be greater than 0.
       If invalid, calculate:
           Sales / Quantity

    2. Sales must equal Quantity × Price.
       If invalid, recalculate:
           Quantity × ABS(Price)

    3. Return only records containing invalid or missing values.
============================================================*/

SELECT
    sls_sales,
    sls_quantity,
    sls_price,

    -- Correct invalid or missing price
    CASE
        WHEN sls_price IS NULL
          OR sls_price <= 0
            THEN sls_sales / NULLIF(sls_quantity, 0)
        ELSE sls_price
    END AS new_sls_price,

    -- Correct invalid or inconsistent sales amount
    CASE
        WHEN sls_sales IS NULL
          OR sls_sales <= 0
          OR sls_sales <> sls_quantity * ABS(sls_price)
            THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END AS new_sls_sales

FROM bronze.crm_sales_details

WHERE
      sls_sales IS NULL
   OR sls_sales <= 0
   OR sls_quantity IS NULL
   OR sls_quantity <= 0
   OR sls_price IS NULL
   OR sls_price <= 0
   OR sls_sales <> sls_quantity * sls_price;


/*============================================================
    Load CRM Sales Details
    Source : bronze.crm_sales_details
    Target : silver.crm_sales_details

    Data Cleansing & Transformation:
    1. Convert invalid dates (0 or not 8 digits) to NULL.
    2. Convert valid date values from YYYYMMDD to DATE.
    3. Recalculate Sales if missing, invalid, or inconsistent.
    4. Preserve Quantity.
    5. Derive Price if missing or invalid.
============================================================*/

SELECT
    -- Sales Order Number
    sls_ord_num,

    -- Product Key
    sls_prd_key,

    -- Customer ID
    sls_cust_id,

    /*--------------------------------------------------------
      Clean Order Date
      - Replace 0 or invalid length values with NULL.
      - Convert valid YYYYMMDD values to DATE.
    --------------------------------------------------------*/
    CASE
        WHEN sls_order_dt = 0
          OR LEN(sls_order_dt) <> 8
            THEN NULL
        ELSE CAST(CAST(sls_order_dt AS VARCHAR(8)) AS DATE)
    END AS sls_order_dt,

    /*--------------------------------------------------------
      Clean Ship Date
      - Replace 0 or invalid length values with NULL.
      - Convert valid YYYYMMDD values to DATE.
    --------------------------------------------------------*/
    CASE
        WHEN sls_ship_dt = 0
          OR LEN(sls_ship_dt) <> 8
            THEN NULL
        ELSE CAST(CAST(sls_ship_dt AS VARCHAR(8)) AS DATE)
    END AS sls_ship_dt,

    /*--------------------------------------------------------
      Clean Due Date
      - Replace 0 or invalid length values with NULL.
      - Convert valid YYYYMMDD values to DATE.
    --------------------------------------------------------*/
    CASE
        WHEN sls_due_dt = 0
          OR LEN(sls_due_dt) <> 8
            THEN NULL
        ELSE CAST(CAST(sls_due_dt AS VARCHAR(8)) AS DATE)
    END AS sls_due_dt,

    /*--------------------------------------------------------
      Clean Sales Amount
      Recalculate Sales when:
      - Sales is NULL
      - Sales is less than or equal to 0
      - Sales does not equal Quantity × Price
    --------------------------------------------------------*/
    CASE
        WHEN sls_sales IS NULL
          OR sls_sales <= 0
          OR sls_sales <> sls_quantity * ABS(sls_price)
            THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END AS sls_sales,

    /*--------------------------------------------------------
      Quantity
      Preserve the original quantity value.
    --------------------------------------------------------*/
    sls_quantity,

    /*--------------------------------------------------------
      Clean Unit Price
      Derive Price when:
      - Price is NULL
      - Price is less than or equal to 0

      Formula:
      Price = Sales / Quantity
      NULLIF prevents divide-by-zero errors.
    --------------------------------------------------------*/
    CASE
        WHEN sls_price IS NULL
          OR sls_price <= 0
            THEN sls_sales / NULLIF(sls_quantity, 0)
        ELSE sls_price
    END AS sls_price

FROM bronze.crm_sales_details;


USE [Datawarehouse];
GO
--=====================================================================
-- View Name : gold.dim_products
--
-- Purpose:
--     Creates the Product Dimension for the Gold layer by combining
--     product information from the CRM system with product category
--     information from the ERP system.
--
-- Business Logic:
--     1. Generate a surrogate key for each active product.
--     2. Retrieve product attributes from the CRM product table.
--     3. Enrich product records with category details from the ERP
--        category master.
--     4. Load only the current (active) version of each product by
--        excluding records with an end date.
--
-- Source Tables:
--     - silver.crm_prd_info
--     - silver.erp_px_cat_g1v2
--
-- Target Layer:
--     - gold.dim_products
--
-- Grain:
--     One record per active product.
--=====================================================================
CREATE OR ALTER VIEW gold.dim_products
AS
SELECT
-- Surrogate key for the Product Dimension
    ROW_NUMBER() OVER (
        ORDER BY ci.prd_start_dt, ci.prd_key
    ) AS product_key,
-- Business key from source system
    ci.prd_id AS product_id,
-- Product code/number
    ci.prd_key AS product_number,
-- Product descriptive attributes
    ci.prd_nm AS product_name,
    ci.prd_cost AS product_cost,
    ci.prd_line AS product_line,
-- Product category identifier
    ci.cat_id AS category_id,
-- Category information from ERP
    cg.cat AS category,
    cg.subcat AS subcategory,
    cg.maintainance AS maintainance,
-- Product effective start date
    ci.prd_start_dt AS product_start_date
FROM silver.crm_prd_info AS ci
-- Join with ERP Product Category table
LEFT JOIN silver.erp_px_cat_g1v2 AS cg
    ON ci.cat_id = cg.id
-- Load only active products
-- Products with an end date are considered inactive or historical
WHERE ci.prd_end_dt IS NULL;


/*
## Documentation
### Objective
The **`gold.dim_products`** view creates the **Product Dimension** in the Gold layer of the data warehouse. It consolidates product information from the CRM system and enriches it with category information from the ERP system to provide a single, business-friendly product dimension for reporting and analytics.
### Source Tables
| Source Table             | Description                                                                |
| ------------------------ | -------------------------------------------------------------------------- |
| `silver.crm_prd_info`    | Contains product master data including product details and validity dates. |
| `silver.erp_px_cat_g1v2` | Contains product category, subcategory, and maintenance information.       |
### Join Logic
```text
crm_prd_info.cat_id
        =
erp_px_cat_g1v2.id
```
A **LEFT JOIN** is used so that all active products are retained even if no matching category exists in the ERP table.
### Business Rules
* Generate a surrogate key using `ROW_NUMBER()`.
* Keep only active products (`prd_end_dt IS NULL`).
* Enrich products with category and subcategory information.
* Preserve all products even when category information is unavailable.
### Output Columns
| Column               | Description                                        |
| -------------------- | -------------------------------------------------- |
| `product_key`        | Surrogate key generated for the Product Dimension. |
| `product_id`         | Business identifier of the product.                |
| `product_number`     | Product code/key from the source system.           |
| `product_name`       | Product name.                                      |
| `product_cost`       | Product cost.                                      |
| `product_line`       | Product line/category grouping.                    |
| `category_id`        | Category identifier.                               |
| `category`           | Product category.                                  |
| `subcategory`        | Product subcategory.                               |
| `maintainance`       | Product maintenance classification.                |
| `product_start_date` | Product validity start date.                       |
### Note (Data Warehouse Best Practice)
Using `ROW_NUMBER()` to generate surrogate keys is acceptable for learning projects and views, but in a production data warehouse surrogate keys are typically generated during the ETL process using an `IDENTITY` column or a `SEQUENCE`. This ensures that keys remain stable even if the source data changes.
*/











USE [Datawarehouse];
GO
--=====================================================================
-- View Name : gold.fact_sales
--
-- Purpose:
--     Creates the Sales Fact table for the Gold layer by combining
--     transactional sales data with surrogate keys from the Product
--     and Customer dimensions.
--
-- Business Logic:
--     1. Load sales transactions from the CRM sales table.
--     2. Replace business keys with surrogate keys from the
--        Product and Customer dimensions.
--     3. Preserve all sales records even if the corresponding
--        dimension record is missing.
--
-- Source Tables:
--     - silver.crm_sales_details
--     - gold.dim_products
--     - gold.dim_customer
--
-- Target Layer:
--     - gold.fact_sales
--
-- Grain:
--     One record per sales transaction (order line).
--=====================================================================
CREATE OR ALTER VIEW gold.fact_sales
AS
SELECT
-- Sales order number (business key)
    csd.sls_ord_num AS order_number,
-- Foreign key to Product Dimension
    dp.product_key,
-- Foreign key to Customer Dimension
    dc.customer_key,
-- Important business dates
    csd.sls_order_dt AS order_date,
    csd.sls_ship_dt  AS ship_date,
    csd.sls_due_dt   AS due_date,
-- Sales measures
    csd.sls_sales    AS sales,
    csd.sls_quantity AS quantity,
    csd.sls_price    AS price
FROM silver.crm_sales_details AS csd
-- Lookup Product surrogate key
LEFT JOIN gold.dim_products AS dp
    ON csd.sls_prd_key = dp.product_number
-- Lookup Customer surrogate key
LEFT JOIN gold.dim_customer AS dc
    ON csd.sls_cust_id = dc.customer_id;


/*
## Documentation
### Objective
The **`gold.fact_sales`** view creates the **Sales Fact** table in the Gold layer. It stores transactional sales data and links each transaction to the **Product** and **Customer** dimensions using surrogate keys, forming the central fact table of the star schema.
---
### Source Tables
| Source Table               | Description                                            |
| -------------------------- | ------------------------------------------------------ |
| `silver.crm_sales_details` | Contains transactional sales data.                     |
| `gold.dim_products`        | Product Dimension containing surrogate product keys.   |
| `gold.dim_customer`        | Customer Dimension containing surrogate customer keys. |
---
### Join Logic
#### Product Lookup
```text
crm_sales_details.sls_prd_key
            =
dim_products.product_number
```
Retrieves the **Product Dimension surrogate key (`product_key`)**.
#### Customer Lookup
```text
crm_sales_details.sls_cust_id
            =
dim_customer.customer_id
```
Retrieves the **Customer Dimension surrogate key (`customer_key`)**.
Both lookups use **LEFT JOIN** so that sales transactions are retained even if a corresponding dimension record is missing.
---
### Business Rules
* Load all sales transactions from the Silver layer.
* Replace source business keys with surrogate keys from dimension tables.
* Preserve every sales transaction regardless of missing dimension matches.
* Store sales measures and business dates for analytical reporting.
---
### Fact Table Grain
**One row represents one sales transaction (order line).**
Each record contains:
* One customer
* One product
* One order number
* Sales amount
* Quantity sold
* Unit price
* Order, ship, and due dates
---
### Output Columns
| Column         | Description                      |
| -------------- | -------------------------------- |
| `order_number` | Sales order business identifier. |
| `product_key`  | Foreign key to `dim_products`.   |
| `customer_key` | Foreign key to `dim_customer`.   |
| `order_date`   | Date the order was placed.       |
| `ship_date`    | Date the order was shipped.      |
| `due_date`     | Expected delivery date.          |
| `sales`        | Total sales amount.              |
| `quantity`     | Quantity sold.                   |
| `price`        | Unit price of the product.       |
---
### Data Warehouse Design Notes
* This is the **central Fact table** in the star schema.
* `product_key` and `customer_key` are **foreign keys** that reference the corresponding dimension tables.
* The table stores **measures** (`sales`, `quantity`, `price`) and **foreign keys** for dimensional analysis.
* Date columns can later be linked to a dedicated **Date Dimension (`dim_date`)** for efficient time-based reporting.
* Using **LEFT JOIN** ensures that no sales transactions are lost if there is a delay or mismatch in loading the dimension tables.
*/

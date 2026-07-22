-- Load data from Bronze to Silver
INSERT INTO silver.erp_px_cat_g1v2
(
    id,
    cat,
    subcat,
    maintainance
)
SELECT
    id,
    cat,
    subcat,
    maintainance
FROM bronze.erp_px_cat_g1v2;

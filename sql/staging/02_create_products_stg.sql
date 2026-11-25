CREATE OR REPLACE TABLE
  `project-2425d17e-9385-4676-aab.sears_staging.products_stg`
AS
SELECT
  TRIM(product_id) AS product_id,
  TRIM(product_name) AS product_name,
  TRIM(category) AS category,
  TRIM(brand) AS brand,
  SAFE_CAST(list_price AS NUMERIC) AS list_price,
  SAFE_CAST(updated_at AS TIMESTAMP) AS updated_at,
  SAFE_CAST(is_active AS BOOL) AS is_active
FROM
  `project-2425d17e-9385-4676-aab.sears_bronze.products_raw`;
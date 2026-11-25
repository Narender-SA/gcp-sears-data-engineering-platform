CREATE OR REPLACE TABLE
  `project-2425d17e-9385-4676-aab.sears_staging.order_items_stg`
AS
SELECT
  TRIM(order_item_id) AS order_item_id,
  TRIM(order_id) AS order_id,
  TRIM(product_id) AS product_id,
  SAFE_CAST(quantity AS INT64) AS quantity,
  SAFE_CAST(unit_price_at_purchase AS NUMERIC)
    AS unit_price_at_purchase,
  SAFE_CAST(discount_percent AS NUMERIC) AS discount_percent,
  SAFE_CAST(updated_at AS TIMESTAMP) AS updated_at
FROM
  `project-2425d17e-9385-4676-aab.sears_bronze.order_items_raw`;
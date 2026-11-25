CREATE OR REPLACE TABLE
  `project-2425d17e-9385-4676-aab.sears_staging.orders_stg`
AS
SELECT
  TRIM(order_id) AS order_id,
  TRIM(customer_id) AS customer_id,
  SAFE_CAST(order_timestamp AS TIMESTAMP) AS order_timestamp,
  TRIM(order_status) AS order_status,
  TRIM(shipping_city) AS shipping_city,
  TRIM(shipping_state) AS shipping_state,
  TRIM(region) AS region,
  TRIM(currency) AS currency,
  SAFE_CAST(created_at AS TIMESTAMP) AS created_at,
  SAFE_CAST(updated_at AS TIMESTAMP) AS updated_at,
  SAFE_CAST(is_deleted AS BOOL) AS is_deleted
FROM
  `project-2425d17e-9385-4676-aab.sears_bronze.orders_raw`;
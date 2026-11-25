CREATE OR REPLACE TABLE
  `project-2425d17e-9385-4676-aab.sears_staging.payments_stg`
AS
SELECT
  TRIM(payment_id) AS payment_id,
  TRIM(order_id) AS order_id,
  SAFE_CAST(attempt_number AS INT64) AS attempt_number,
  TRIM(payment_method) AS payment_method,
  SAFE_CAST(payment_amount AS NUMERIC) AS payment_amount,
  TRIM(payment_status) AS payment_status,
  SAFE_CAST(transaction_timestamp AS TIMESTAMP)
    AS transaction_timestamp,
  SAFE_CAST(updated_at AS TIMESTAMP) AS updated_at
FROM
  `project-2425d17e-9385-4676-aab.sears_bronze.payments_raw`;
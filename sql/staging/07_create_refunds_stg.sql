CREATE OR REPLACE TABLE
  `project-2425d17e-9385-4676-aab.sears_staging.refunds_stg`
AS
SELECT
  TRIM(refund_id) AS refund_id,
  TRIM(order_id) AS order_id,
  TRIM(payment_id) AS payment_id,
  SAFE_CAST(refund_amount AS NUMERIC) AS refund_amount,
  TRIM(refund_reason) AS refund_reason,
  TRIM(refund_status) AS refund_status,
  SAFE_CAST(refund_timestamp AS TIMESTAMP) AS refund_timestamp,
  SAFE_CAST(updated_at AS TIMESTAMP) AS updated_at
FROM
  `project-2425d17e-9385-4676-aab.sears_bronze.refunds_raw`;
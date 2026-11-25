
CREATE TEMP TABLE payment_candidates AS
SELECT
  *,
  ROW_NUMBER() OVER (
    PARTITION BY payment_id
    ORDER BY updated_at DESC
  ) AS _rn
FROM
  `project-2425d17e-9385-4676-aab.sears_staging.payments_stg`;

CREATE OR REPLACE TABLE
  `project-2425d17e-9385-4676-aab.sears_silver.payments_quarantine`
AS
SELECT
  pay.* EXCEPT (_rn),
  CASE
    WHEN pay.payment_id IS NULL OR TRIM(pay.payment_id) = ''
      THEN 'Missing payment_id'
    WHEN pay.order_id IS NULL OR TRIM(pay.order_id) = ''
      THEN 'Missing order_id'
    WHEN o.order_id IS NULL
      THEN 'Order not found'
    WHEN pay.attempt_number IS NULL OR pay.attempt_number < 1
      THEN 'Invalid attempt_number'
    WHEN pay.payment_amount IS NULL OR pay.payment_amount <= 0
      THEN 'Invalid payment_amount'
    WHEN pay.payment_status IS NULL OR TRIM(pay.payment_status) = ''
      THEN 'Missing payment_status'
    WHEN pay.transaction_timestamp IS NULL
      THEN 'Missing or invalid transaction_timestamp'
    WHEN pay._rn > 1
      THEN 'Duplicate payment_id'
  END AS reject_reason
FROM payment_candidates AS pay
LEFT JOIN
  `project-2425d17e-9385-4676-aab.sears_silver.orders_silver` AS o
  ON pay.order_id = o.order_id
WHERE
  pay.payment_id IS NULL OR TRIM(pay.payment_id) = ''
  OR pay.order_id IS NULL OR TRIM(pay.order_id) = ''
  OR o.order_id IS NULL
  OR pay.attempt_number IS NULL OR pay.attempt_number < 1
  OR pay.payment_amount IS NULL OR pay.payment_amount <= 0
  OR pay.payment_status IS NULL OR TRIM(pay.payment_status) = ''
  OR pay.transaction_timestamp IS NULL
  OR pay._rn > 1;

CREATE OR REPLACE TABLE
  `project-2425d17e-9385-4676-aab.sears_silver.payments_silver`
AS
SELECT
  pay.* EXCEPT (_rn)
FROM payment_candidates AS pay
INNER JOIN
  `project-2425d17e-9385-4676-aab.sears_silver.orders_silver` AS o
  ON pay.order_id = o.order_id
WHERE
  pay.payment_id IS NOT NULL
  AND TRIM(pay.payment_id) != ''
  AND pay.order_id IS NOT NULL
  AND TRIM(pay.order_id) != ''
  AND pay.attempt_number IS NOT NULL
  AND pay.attempt_number >= 1
  AND pay.payment_amount IS NOT NULL
  AND pay.payment_amount > 0
  AND pay.payment_status IS NOT NULL
  AND TRIM(pay.payment_status) != ''
  AND pay.transaction_timestamp IS NOT NULL
  AND pay._rn = 1;

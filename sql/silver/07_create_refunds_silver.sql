
CREATE TEMP TABLE refund_candidates AS
SELECT
  *,
  ROW_NUMBER() OVER (
    PARTITION BY refund_id
    ORDER BY updated_at DESC
  ) AS _rn
FROM
  `project-2425d17e-9385-4676-aab.sears_staging.refunds_stg`;

CREATE OR REPLACE TABLE
  `project-2425d17e-9385-4676-aab.sears_silver.refunds_quarantine`
AS
SELECT
  r.* EXCEPT (_rn),
  CASE
    WHEN r.refund_id IS NULL OR TRIM(r.refund_id) = ''
      THEN 'Missing refund_id'
    WHEN r.order_id IS NULL OR TRIM(r.order_id) = ''
      THEN 'Missing order_id'
    WHEN r.payment_id IS NULL OR TRIM(r.payment_id) = ''
      THEN 'Missing payment_id'
    WHEN o.order_id IS NULL
      THEN 'Order not found'
    WHEN pay.payment_id IS NULL
      THEN 'Payment not found'
    WHEN pay.order_id != r.order_id
      THEN 'Payment does not belong to refund order'
    WHEN r.refund_amount IS NULL OR r.refund_amount <= 0
      THEN 'Invalid refund_amount'
    WHEN r.refund_status IS NULL OR TRIM(r.refund_status) = ''
      THEN 'Missing refund_status'
    WHEN r.refund_timestamp IS NULL
      THEN 'Missing or invalid refund_timestamp'
    WHEN r._rn > 1
      THEN 'Duplicate refund_id'
  END AS reject_reason
FROM refund_candidates AS r
LEFT JOIN
  `project-2425d17e-9385-4676-aab.sears_silver.orders_silver` AS o
  ON r.order_id = o.order_id
LEFT JOIN
  `project-2425d17e-9385-4676-aab.sears_silver.payments_silver` AS pay
  ON r.payment_id = pay.payment_id
WHERE
  r.refund_id IS NULL OR TRIM(r.refund_id) = ''
  OR r.order_id IS NULL OR TRIM(r.order_id) = ''
  OR r.payment_id IS NULL OR TRIM(r.payment_id) = ''
  OR o.order_id IS NULL
  OR pay.payment_id IS NULL
  OR pay.order_id != r.order_id
  OR r.refund_amount IS NULL OR r.refund_amount <= 0
  OR r.refund_status IS NULL OR TRIM(r.refund_status) = ''
  OR r.refund_timestamp IS NULL
  OR r._rn > 1;

CREATE OR REPLACE TABLE
  `project-2425d17e-9385-4676-aab.sears_silver.refunds_silver`
AS
SELECT
  r.* EXCEPT (_rn)
FROM refund_candidates AS r
INNER JOIN
  `project-2425d17e-9385-4676-aab.sears_silver.orders_silver` AS o
  ON r.order_id = o.order_id
INNER JOIN
  `project-2425d17e-9385-4676-aab.sears_silver.payments_silver` AS pay
  ON r.payment_id = pay.payment_id
WHERE
  r.refund_id IS NOT NULL
  AND TRIM(r.refund_id) != ''
  AND r.order_id IS NOT NULL
  AND TRIM(r.order_id) != ''
  AND r.payment_id IS NOT NULL
  AND TRIM(r.payment_id) != ''
  AND pay.order_id = r.order_id
  AND r.refund_amount IS NOT NULL
  AND r.refund_amount > 0
  AND r.refund_status IS NOT NULL
  AND TRIM(r.refund_status) != ''
  AND r.refund_timestamp IS NOT NULL
  AND r._rn = 1;

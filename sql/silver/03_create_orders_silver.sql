
CREATE TEMP TABLE order_candidates AS
SELECT
  *,
  ROW_NUMBER() OVER (
    PARTITION BY order_id
    ORDER BY updated_at DESC
  ) AS _rn
FROM
  `project-2425d17e-9385-4676-aab.sears_staging.orders_stg`;


-- Step 1: Store rejected records in quarantine

CREATE OR REPLACE TABLE
  `project-2425d17e-9385-4676-aab.sears_silver.orders_quarantine`
AS
SELECT
  o.* EXCEPT (_rn),
  CASE
    WHEN o.order_id IS NULL OR TRIM(o.order_id) = ''
      THEN 'Missing order_id'

    WHEN o.customer_id IS NULL OR TRIM(o.customer_id) = ''
      THEN 'Missing customer_id'

    WHEN o.order_timestamp IS NULL
      THEN 'Invalid or missing order_timestamp'

    WHEN c.customer_id IS NULL
      THEN 'Customer not found'

    WHEN o._rn > 1
      THEN 'Duplicate order_id'
  END AS reject_reason
FROM order_candidates o

LEFT JOIN
  `project-2425d17e-9385-4676-aab.sears_silver.customers_silver` c
ON o.customer_id = c.customer_id

WHERE
  o.order_id IS NULL
  OR TRIM(o.order_id) = ''
  OR o.customer_id IS NULL
  OR TRIM(o.customer_id) = ''
  OR o.order_timestamp IS NULL
  OR c.customer_id IS NULL
  OR o._rn > 1;


-- Step 2: Store valid records in Silver

CREATE OR REPLACE TABLE
  `project-2425d17e-9385-4676-aab.sears_silver.orders_silver`
AS
SELECT
  o.* EXCEPT (_rn)
FROM order_candidates o

INNER JOIN
  `project-2425d17e-9385-4676-aab.sears_silver.customers_silver` c
ON o.customer_id = c.customer_id

WHERE
  o.order_id IS NOT NULL
  AND TRIM(o.order_id) != ''
  AND o.customer_id IS NOT NULL
  AND TRIM(o.customer_id) != ''
  AND o.order_timestamp IS NOT NULL
  AND o._rn = 1;

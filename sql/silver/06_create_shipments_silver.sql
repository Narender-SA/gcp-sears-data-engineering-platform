
CREATE TEMP TABLE shipment_candidates AS
SELECT
  *,
  ROW_NUMBER() OVER (
    PARTITION BY shipment_id
    ORDER BY updated_at DESC
  ) AS _rn
FROM
  `project-2425d17e-9385-4676-aab.sears_staging.shipments_stg`;

CREATE OR REPLACE TABLE
  `project-2425d17e-9385-4676-aab.sears_silver.shipments_quarantine`
AS
SELECT
  s.* EXCEPT (_rn),
  CASE
    WHEN s.shipment_id IS NULL OR TRIM(s.shipment_id) = ''
      THEN 'Missing shipment_id'
    WHEN s.order_id IS NULL OR TRIM(s.order_id) = ''
      THEN 'Missing order_id'
    WHEN o.order_id IS NULL
      THEN 'Order not found'
    WHEN s.shipped_at IS NOT NULL
      AND s.delivered_at IS NOT NULL
      AND s.delivered_at < s.shipped_at
      THEN 'Delivery timestamp earlier than shipped timestamp'
    WHEN s._rn > 1
      THEN 'Duplicate shipment_id'
  END AS reject_reason
FROM shipment_candidates AS s
LEFT JOIN
  `project-2425d17e-9385-4676-aab.sears_silver.orders_silver` AS o
  ON s.order_id = o.order_id
WHERE
  s.shipment_id IS NULL OR TRIM(s.shipment_id) = ''
  OR s.order_id IS NULL OR TRIM(s.order_id) = ''
  OR o.order_id IS NULL
  OR (
    s.shipped_at IS NOT NULL
    AND s.delivered_at IS NOT NULL
    AND s.delivered_at < s.shipped_at
  )
  OR s._rn > 1;

CREATE OR REPLACE TABLE
  `project-2425d17e-9385-4676-aab.sears_silver.shipments_silver`
AS
SELECT
  s.* EXCEPT (_rn)
FROM shipment_candidates AS s
INNER JOIN
  `project-2425d17e-9385-4676-aab.sears_silver.orders_silver` AS o
  ON s.order_id = o.order_id
WHERE
  s.shipment_id IS NOT NULL
  AND TRIM(s.shipment_id) != ''
  AND s.order_id IS NOT NULL
  AND TRIM(s.order_id) != ''
  AND NOT (
    s.shipped_at IS NOT NULL
    AND s.delivered_at IS NOT NULL
    AND s.delivered_at < s.shipped_at
  )
  AND s._rn = 1;

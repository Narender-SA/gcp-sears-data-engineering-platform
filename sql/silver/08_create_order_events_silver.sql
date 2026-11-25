
CREATE TEMP TABLE order_event_candidates AS
SELECT
  *,
  ROW_NUMBER() OVER (
    PARTITION BY event_id
    ORDER BY source_updated_at DESC, event_timestamp DESC
  ) AS _rn
FROM
  `project-2425d17e-9385-4676-aab.sears_staging.order_events_stg`;

CREATE OR REPLACE TABLE
  `project-2425d17e-9385-4676-aab.sears_silver.order_events_quarantine`
AS
SELECT
  e.* EXCEPT (_rn),
  CASE
    WHEN e.event_id IS NULL OR TRIM(e.event_id) = ''
      THEN 'Missing event_id'
    WHEN e.order_id IS NULL OR TRIM(e.order_id) = ''
      THEN 'Missing order_id'
    WHEN o.order_id IS NULL
      THEN 'Order not found'
    WHEN e.event_timestamp IS NULL
      THEN 'Missing or invalid event_timestamp'
    WHEN e._rn > 1
      THEN 'Duplicate event_id'
  END AS reject_reason
FROM order_event_candidates AS e
LEFT JOIN
  `project-2425d17e-9385-4676-aab.sears_silver.orders_silver` AS o
  ON e.order_id = o.order_id
WHERE
  e.event_id IS NULL OR TRIM(e.event_id) = ''
  OR e.order_id IS NULL OR TRIM(e.order_id) = ''
  OR o.order_id IS NULL
  OR e.event_timestamp IS NULL
  OR e._rn > 1;

CREATE OR REPLACE TABLE
  `project-2425d17e-9385-4676-aab.sears_silver.order_events_silver`
AS
SELECT
  e.* EXCEPT (_rn)
FROM order_event_candidates AS e
INNER JOIN
  `project-2425d17e-9385-4676-aab.sears_silver.orders_silver` AS o
  ON e.order_id = o.order_id
WHERE
  e.event_id IS NOT NULL
  AND TRIM(e.event_id) != ''
  AND e.order_id IS NOT NULL
  AND TRIM(e.order_id) != ''
  AND e.event_timestamp IS NOT NULL
  AND e._rn = 1;

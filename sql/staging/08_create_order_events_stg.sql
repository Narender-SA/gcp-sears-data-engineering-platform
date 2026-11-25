CREATE OR REPLACE TABLE
  `project-2425d17e-9385-4676-aab.sears_staging.order_events_stg`
AS
SELECT
  TRIM(event_id) AS event_id,
  TRIM(order_id) AS order_id,
  TRIM(old_status) AS old_status,
  TRIM(new_status) AS new_status,
  SAFE_CAST(event_timestamp AS TIMESTAMP) AS event_timestamp,
  SAFE_CAST(source_updated_at AS TIMESTAMP) AS source_updated_at
FROM
  `project-2425d17e-9385-4676-aab.sears_bronze.order_events_raw`;
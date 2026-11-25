CREATE OR REPLACE TABLE
  `project-2425d17e-9385-4676-aab.sears_staging.shipments_stg`
AS
SELECT
  TRIM(shipment_id) AS shipment_id,
  TRIM(order_id) AS order_id,
  TRIM(carrier) AS carrier,
  SAFE_CAST(shipped_at AS TIMESTAMP) AS shipped_at,
  SAFE_CAST(delivered_at AS TIMESTAMP) AS delivered_at,
  TRIM(delivery_status) AS delivery_status,
  SAFE_CAST(updated_at AS TIMESTAMP) AS updated_at
FROM
  `project-2425d17e-9385-4676-aab.sears_bronze.shipments_raw`;
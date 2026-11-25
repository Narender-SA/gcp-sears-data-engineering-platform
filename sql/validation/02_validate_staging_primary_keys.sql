
SELECT
  'customers_stg' AS table_name,
  COUNTIF(customer_id IS NULL OR TRIM(customer_id) = '') AS invalid_primary_keys
FROM `project-2425d17e-9385-4676-aab.sears_staging.customers_stg`

UNION ALL

SELECT
  'products_stg',
  COUNTIF(product_id IS NULL OR TRIM(product_id) = '')
FROM `project-2425d17e-9385-4676-aab.sears_staging.products_stg`

UNION ALL

SELECT
  'orders_stg',
  COUNTIF(order_id IS NULL OR TRIM(order_id) = '')
FROM `project-2425d17e-9385-4676-aab.sears_staging.orders_stg`

UNION ALL

SELECT
  'order_items_stg',
  COUNTIF(order_item_id IS NULL OR TRIM(order_item_id) = '')
FROM `project-2425d17e-9385-4676-aab.sears_staging.order_items_stg`

UNION ALL

SELECT
  'payments_stg',
  COUNTIF(payment_id IS NULL OR TRIM(payment_id) = '')
FROM `project-2425d17e-9385-4676-aab.sears_staging.payments_stg`

UNION ALL

SELECT
  'shipments_stg',
  COUNTIF(shipment_id IS NULL OR TRIM(shipment_id) = '')
FROM `project-2425d17e-9385-4676-aab.sears_staging.shipments_stg`

UNION ALL

SELECT
  'refunds_stg',
  COUNTIF(refund_id IS NULL OR TRIM(refund_id) = '')
FROM `project-2425d17e-9385-4676-aab.sears_staging.refunds_stg`

UNION ALL

SELECT
  'order_events_stg',
  COUNTIF(event_id IS NULL OR TRIM(event_id) = '')
FROM `project-2425d17e-9385-4676-aab.sears_staging.order_events_stg`

ORDER BY table_name;

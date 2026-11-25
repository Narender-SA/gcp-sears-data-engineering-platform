
SELECT
  'customers' AS dataset,
  reject_reason,
  COUNT(*) AS rejected_records
FROM `project-2425d17e-9385-4676-aab.sears_silver.customers_quarantine`
GROUP BY reject_reason

UNION ALL

SELECT
  'products',
  reject_reason,
  COUNT(*)
FROM `project-2425d17e-9385-4676-aab.sears_silver.products_quarantine`
GROUP BY reject_reason

UNION ALL

SELECT
  'orders',
  reject_reason,
  COUNT(*)
FROM `project-2425d17e-9385-4676-aab.sears_silver.orders_quarantine`
GROUP BY reject_reason

UNION ALL

SELECT
  'order_items',
  reject_reason,
  COUNT(*)
FROM `project-2425d17e-9385-4676-aab.sears_silver.order_items_quarantine`
GROUP BY reject_reason

UNION ALL

SELECT
  'payments',
  reject_reason,
  COUNT(*)
FROM `project-2425d17e-9385-4676-aab.sears_silver.payments_quarantine`
GROUP BY reject_reason

UNION ALL

SELECT
  'shipments',
  reject_reason,
  COUNT(*)
FROM `project-2425d17e-9385-4676-aab.sears_silver.shipments_quarantine`
GROUP BY reject_reason

UNION ALL

SELECT
  'refunds',
  reject_reason,
  COUNT(*)
FROM `project-2425d17e-9385-4676-aab.sears_silver.refunds_quarantine`
GROUP BY reject_reason

UNION ALL

SELECT
  'order_events',
  reject_reason,
  COUNT(*)
FROM `project-2425d17e-9385-4676-aab.sears_silver.order_events_quarantine`
GROUP BY reject_reason

ORDER BY dataset, rejected_records DESC;

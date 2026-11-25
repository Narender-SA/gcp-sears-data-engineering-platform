
SELECT 'customers_quarantine' AS table_name, COUNT(*) AS rejected_records
FROM `project-2425d17e-9385-4676-aab.sears_silver.customers_quarantine`

UNION ALL

SELECT 'products_quarantine', COUNT(*)
FROM `project-2425d17e-9385-4676-aab.sears_silver.products_quarantine`

UNION ALL

SELECT 'orders_quarantine', COUNT(*)
FROM `project-2425d17e-9385-4676-aab.sears_silver.orders_quarantine`

UNION ALL

SELECT 'order_items_quarantine', COUNT(*)
FROM `project-2425d17e-9385-4676-aab.sears_silver.order_items_quarantine`

UNION ALL

SELECT 'payments_quarantine', COUNT(*)
FROM `project-2425d17e-9385-4676-aab.sears_silver.payments_quarantine`

UNION ALL

SELECT 'shipments_quarantine', COUNT(*)
FROM `project-2425d17e-9385-4676-aab.sears_silver.shipments_quarantine`

UNION ALL

SELECT 'refunds_quarantine', COUNT(*)
FROM `project-2425d17e-9385-4676-aab.sears_silver.refunds_quarantine`

UNION ALL

SELECT 'order_events_quarantine', COUNT(*)
FROM `project-2425d17e-9385-4676-aab.sears_silver.order_events_quarantine`

ORDER BY table_name;

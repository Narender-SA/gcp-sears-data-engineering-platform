
SELECT 'customers_silver' AS table_name, COUNT(*) AS record_count
FROM `project-2425d17e-9385-4676-aab.sears_silver.customers_silver`

UNION ALL

SELECT 'products_silver', COUNT(*)
FROM `project-2425d17e-9385-4676-aab.sears_silver.products_silver`

UNION ALL

SELECT 'orders_silver', COUNT(*)
FROM `project-2425d17e-9385-4676-aab.sears_silver.orders_silver`

UNION ALL

SELECT 'order_items_silver', COUNT(*)
FROM `project-2425d17e-9385-4676-aab.sears_silver.order_items_silver`

UNION ALL

SELECT 'payments_silver', COUNT(*)
FROM `project-2425d17e-9385-4676-aab.sears_silver.payments_silver`

UNION ALL

SELECT 'shipments_silver', COUNT(*)
FROM `project-2425d17e-9385-4676-aab.sears_silver.shipments_silver`

UNION ALL

SELECT 'refunds_silver', COUNT(*)
FROM `project-2425d17e-9385-4676-aab.sears_silver.refunds_silver`

UNION ALL

SELECT 'order_events_silver', COUNT(*)
FROM `project-2425d17e-9385-4676-aab.sears_silver.order_events_silver`

ORDER BY table_name;

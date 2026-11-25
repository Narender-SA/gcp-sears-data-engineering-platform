
SELECT 'customers_stg' AS table_name, COUNT(*) AS record_count
FROM `project-2425d17e-9385-4676-aab.sears_staging.customers_stg`

UNION ALL

SELECT 'products_stg', COUNT(*)
FROM `project-2425d17e-9385-4676-aab.sears_staging.products_stg`

UNION ALL

SELECT 'orders_stg', COUNT(*)
FROM `project-2425d17e-9385-4676-aab.sears_staging.orders_stg`

UNION ALL

SELECT 'order_items_stg', COUNT(*)
FROM `project-2425d17e-9385-4676-aab.sears_staging.order_items_stg`

UNION ALL

SELECT 'payments_stg', COUNT(*)
FROM `project-2425d17e-9385-4676-aab.sears_staging.payments_stg`

UNION ALL

SELECT 'shipments_stg', COUNT(*)
FROM `project-2425d17e-9385-4676-aab.sears_staging.shipments_stg`

UNION ALL

SELECT 'refunds_stg', COUNT(*)
FROM `project-2425d17e-9385-4676-aab.sears_staging.refunds_stg`

UNION ALL

SELECT 'order_events_stg', COUNT(*)
FROM `project-2425d17e-9385-4676-aab.sears_staging.order_events_stg`

ORDER BY table_name;

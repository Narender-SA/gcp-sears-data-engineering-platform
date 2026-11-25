# SEARS — Silver Layer Design and Business Rules

## 1. Purpose of the Silver Layer

The Silver layer transforms typed and standardized Staging data into validated, deduplicated, business-ready datasets.

The main responsibilities are:

- Validate mandatory fields.
- Remove duplicate records using business keys.
- Validate relationships between related datasets.
- Apply business rules and data-quality checks.
- Separate invalid records into quarantine tables.
- Preserve valid records in Silver tables.

## 2. Processing Flow

```text
BigQuery Staging
       |
       v
Temporary Candidate Tables
       |
       v
Deduplication using ROW_NUMBER()
       |
       v
Business Rule Validation
       |
       +----------------------+
       |                      |
       v                      v
Silver Tables          Quarantine Tables
(Valid records)        (Rejected records)
```

Temporary candidate tables are created during multi-statement script execution. They are not permanent objects and are automatically removed when the script session ends.

Silver and quarantine tables are permanent BigQuery tables.

## 3. Common Deduplication Rule

For datasets with an update timestamp, use:

```sql
ROW_NUMBER() OVER (
    PARTITION BY business_key
    ORDER BY updated_at DESC
)
```

- `PARTITION BY` groups records having the same business key.
- `ORDER BY updated_at DESC` puts the latest updated record first.
- `_rn = 1` identifies the latest record.
- `_rn > 1` identifies older duplicate records.

For order events, use the source event update timestamp and event timestamp because events represent historical status changes.

## 4. Dataset-Level Business Rules

### 4.1 Customers

Business key: `customer_id`

Validation rules:
- customer_id must not be NULL or empty.
- customer_name must not be NULL or empty.
- Duplicate customer records are resolved by retaining the latest updated record.
- Older duplicate records are quarantined.
- Preserve the `is_deleted` flag for soft-delete handling.

### 4.2 Products

Business key: `product_id`

Validation rules:
- product_id must not be NULL or empty.
- product_name must not be NULL or empty.
- list_price must not be NULL.
- list_price must be greater than or equal to zero.
- Duplicate product records are resolved using the latest updated record.
- Preserve product activity information.

### 4.3 Orders

Business key: `order_id`

Validation rules:
- order_id must not be NULL or empty.
- customer_id must not be NULL or empty.
- order_timestamp must be valid.
- customer_id must exist in customers_silver.
- Duplicate order records are resolved using the latest updated record.
- Preserve the `is_deleted` flag.

### 4.4 Order Items

Business key: `order_item_id`

Validation rules:
- order_item_id must not be NULL or empty.
- order_id must not be NULL or empty.
- product_id must not be NULL or empty.
- Referenced order must exist in orders_silver.
- Referenced product must exist in products_silver.
- quantity must be greater than zero.
- unit_price_at_purchase must not be NULL or negative.
- discount_percent must be between 0 and 100, inclusive.
- Duplicate order items are resolved using the latest updated record.

### 4.5 Payments

Business key: `payment_id`

Validation rules:
- payment_id must not be NULL or empty.
- order_id must not be NULL or empty.
- Referenced order must exist in orders_silver.
- attempt_number must be at least 1.
- payment_amount must be greater than zero.
- payment_status must be present.
- transaction_timestamp must be valid.
- Duplicate payment records are resolved using the latest updated record.
- Retain both successful and failed payment attempts in Silver.
- Only successful payments contribute to collected revenue in Gold.

### 4.6 Shipments

Business key: `shipment_id`

Validation rules:
- shipment_id must not be NULL or empty.
- order_id must not be NULL or empty.
- Referenced order must exist in orders_silver.
- If both shipped_at and delivered_at are populated, delivered_at must not be earlier than shipped_at.
- A shipment that has not yet been delivered can have a NULL delivered_at.
- Duplicate shipment records are resolved using the latest updated record.

### 4.7 Refunds

Business key: `refund_id`

Validation rules:
- refund_id must not be NULL or empty.
- order_id and payment_id must not be NULL or empty.
- Referenced order must exist in orders_silver.
- Referenced payment must exist in payments_silver.
- The payment must belong to the same order referenced by the refund.
- refund_amount must be greater than zero.
- refund_status must be present.
- refund_timestamp must be valid.
- Duplicate refund records are resolved using the latest updated record.
- Retain unsuccessful refund attempts in Silver.
- Only successful refunds are deducted from collected revenue in Gold.

### 4.8 Order Events

Business key: `event_id`

Validation rules:
- event_id must not be NULL or empty.
- order_id must not be NULL or empty.
- Referenced order must exist in orders_silver.
- event_timestamp must be valid.
- Deduplicate using event_id.
- Retain event history rather than keeping only the latest event per order.

Order events are append-oriented historical records. Multiple events for the same order are valid because an order can move through several statuses.

## 5. Quarantine Strategy

Records that fail validation are written to separate quarantine tables.

Examples:

- Missing mandatory identifiers.
- Invalid timestamps.
- Missing parent records.
- Invalid quantities or prices.
- Invalid discount percentages.
- Duplicate business keys.

Each quarantine record contains a `reject_reason` describing the first rule that caused rejection.

Quarantine records are retained for investigation and data-quality monitoring instead of being silently discarded.

## 6. Important Financial Rules for Downstream Gold Layer

- Item gross amount = quantity × unit price at purchase.
- Discount amount = item gross amount × discount percentage / 100.
- Item net amount = item gross amount − discount amount.
- Collected revenue = successful payments.
- Successful refunds are deducted from collected revenue.
- Failed payment attempts are not revenue.
- Unsuccessful refunds are not deducted from revenue.

Important: Payment and refund records must be aggregated independently before joining them with other one-to-many datasets. Otherwise, joins can multiply rows and inflate financial metrics.

## 7. Current Implementation Scope

Implemented:
- Eight Silver datasets.
- Temporary candidate tables.
- Duplicate detection.
- Dataset-specific validation.
- Permanent Silver tables.
- Permanent quarantine tables.
- Foreign-key and business-rule validation.

Future enhancements:
- More detailed multi-reason quarantine reporting.
- Cumulative refund validation against successful payments.
- Additional allowed-value checks for statuses.
- Incremental processing and MERGE operations.
- Audit logging and data-quality metrics.
- Partitioning and clustering where justified by data volume and query patterns.


============================================================
Final Silver verification

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
FROM `project-2425d17e-9385-4676-aab.sears_silver.order_events_silver`;

===============================================
quarantined table verification

SELECT 'customers' AS dataset, COUNT(*) AS rejected_records
FROM `project-2425d17e-9385-4676-aab.sears_silver.customers_quarantine`

UNION ALL
SELECT 'products', COUNT(*)
FROM `project-2425d17e-9385-4676-aab.sears_silver.products_quarantine`

UNION ALL
SELECT 'orders', COUNT(*)
FROM `project-2425d17e-9385-4676-aab.sears_silver.orders_quarantine`

UNION ALL
SELECT 'order_items', COUNT(*)
FROM `project-2425d17e-9385-4676-aab.sears_silver.order_items_quarantine`

UNION ALL
SELECT 'payments', COUNT(*)
FROM `project-2425d17e-9385-4676-aab.sears_silver.payments_quarantine`

UNION ALL
SELECT 'shipments', COUNT(*)
FROM `project-2425d17e-9385-4676-aab.sears_silver.shipments_quarantine`

UNION ALL
SELECT 'refunds', COUNT(*)
FROM `project-2425d17e-9385-4676-aab.sears_silver.refunds_quarantine`

UNION ALL
SELECT 'order_events', COUNT(*)
FROM `project-2425d17e-9385-4676-aab.sears_silver.order_events_quarantine`;
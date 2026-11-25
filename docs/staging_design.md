# SEARS — Staging Layer Design and Transformations

## 1. Purpose of the Staging Layer

The Staging layer is the intermediate layer between Bronze and Silver in the Medallion Architecture.

Its main responsibility is to convert raw source data into standardized, typed datasets without yet applying all Silver business validations.

The Staging layer performs:

- Data type conversions.
- Basic string standardization.
- Date and timestamp parsing.
- Numeric and Boolean conversions.
- Preparation of structured datasets for Silver transformations.

## 2. Source and Target Datasets

Source dataset:

`sears_bronze`

Target dataset:

`sears_staging`

BigQuery location:

`asia-south1`

## 3. Source Tables and Staging Tables

| Bronze source table | Staging target table |
|---|---|
| customers_raw | customers_stg |
| products_raw | products_stg |
| orders_raw | orders_stg |
| order_items_raw | order_items_stg |
| payments_raw | payments_stg |
| shipments_raw | shipments_stg |
| refunds_raw | refunds_stg |
| order_events_raw | order_events_stg |

## 4. Data Type Conversion Strategy

All Bronze columns are stored as STRING.

Staging converts them into appropriate BigQuery data types.

| Data category | Staging data type |
|---|---|
| Identifiers | STRING |
| Names and descriptions | STRING |
| Dates | DATE |
| Event and transaction timestamps | TIMESTAMP |
| Prices and payment amounts | NUMERIC |
| Quantities and attempt numbers | INT64 |
| Boolean flags | BOOL |

Examples of conversion:

```sql
SAFE_CAST(quantity AS INT64)

SAFE_CAST(unit_price_at_purchase AS NUMERIC)

SAFE_CAST(order_timestamp AS TIMESTAMP)

SAFE_CAST(registration_date AS DATE)

SAFE_CAST(is_deleted AS BOOL)
```

SAFE_CAST returns NULL instead of failing the entire query when a value cannot be converted.

This allows invalid or malformed values to be identified and handled in downstream data-quality processing.

## 5. String Standardization

TRIM() is used to remove unnecessary leading and trailing spaces from string values.

Example:

```sql
TRIM(customer_name)
```

This helps standardize text values before business validation.

## 6. Staging SQL Implementation

The following SQL files implement the eight Staging transformations:

1. `01_create_customers_stg.sql`
2. `02_create_products_stg.sql`
3. `03_create_orders_stg.sql`
4. `04_create_order_items_stg.sql`
5. `05_create_payments_stg.sql`
6. `06_create_shipments_stg.sql`
7. `07_create_refunds_stg.sql`
8. `08_create_order_events_stg.sql`

Each SQL script creates or replaces its corresponding Staging table using the source Bronze table.

## 7. Primary Key and Referential Integrity Checks

After creating the Staging tables, initial validation was performed.

Checks included:

- NULL primary keys.
- Record counts.
- Relationships between parent and child datasets.

The initial Staging primary-key validation returned zero NULL primary keys.

Foreign-key relationships include:

- orders.customer_id → customers.customer_id
- order_items.order_id → orders.order_id
- order_items.product_id → products.product_id
- payments.order_id → orders.order_id
- shipments.order_id → orders.order_id
- refunds.order_id → orders.order_id
- refunds.payment_id → payments.payment_id
- order_events.order_id → orders.order_id

These relationships are checked again with additional business rules in Silver.

## 8. Initial Staging Record Counts

| Staging table | Initial records |
|---|---:|
| customers_stg | 5 |
| products_stg | 5 |
| orders_stg | 10 |
| order_items_stg | 23 |
| payments_stg | 17 |
| shipments_stg | 5 |
| refunds_stg | 2 |
| order_events_stg | 28 |
| **Total** | **95** |

This is the initial functional testing dataset.

Larger datasets will be generated later for volume and performance testing.

## 9. Staging Versus Silver

| Staging | Silver |
|---|---|
| Converts data types | Applies business validation |
| Standardizes values | Validates business keys |
| Uses SAFE_CAST | Validates relationships |
| Prepares structured data | Deduplicates records |
| Does not represent fully trusted business data | Separates valid and rejected records |

Example:

A quantity value of `abc` in Bronze becomes NULL through SAFE_CAST in Staging. Silver then rejects the corresponding order item because quantity is missing or invalid.

## 10. Current Implementation Status

Implemented:
- Staging dataset.
- Eight Staging tables.
- Data type conversions.
- SAFE_CAST handling.
- String standardization.
- Initial record-count verification.
- Initial primary-key NULL checks.

Future enhancements:
- Detailed Staging-level conversion error metrics.
- Source file and ingestion metadata.
- Automated data-quality monitoring.
- Incremental Staging processing.


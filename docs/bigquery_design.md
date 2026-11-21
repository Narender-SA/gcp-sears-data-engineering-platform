
# SEARS - BigQuery Data Warehouse Design

## 1. Overview

BigQuery is used as the analytical data warehouse for the SEARS e-commerce data engineering platform.

The warehouse follows a Medallion Architecture:

- Bronze: Raw source data
- Staging: Data type conversion and standardization
- Silver: Cleaned and validated data
- Gold: Business-ready analytical datasets

## 2. Current Implementation

The Bronze dataset has been created in BigQuery.

- Project ID: project-2425d17e-9385-4676-aab
- Dataset: sears_bronze
- Location: asia-south1

## 3. Bronze Layer Design

The Bronze layer stores source data received from operational systems through CSV files in Google Cloud Storage.

### Bronze Tables

| Table | Primary Key |
|---|---|
| customers_raw | customer_id |
| products_raw | product_id |
| orders_raw | order_id |
| order_items_raw | order_item_id |
| payments_raw | payment_id |
| shipments_raw | shipment_id |
| refunds_raw | refund_id |
| order_events_raw | event_id |

### Data Type Strategy

All Bronze columns are currently defined as STRING.

Reasons:

1. Preserve original source values.
2. Avoid failures from unexpected date or numeric formats.
3. Perform data type validation downstream.
4. Separate ingestion from business transformations.

## 4. Data Ingestion

A reusable Bash script was created:

scripts/load_bronze_tables.sh

The script uses the BigQuery command-line tool:

bq load

It accepts the source table name and explicit schema, then loads the corresponding CSV file from GCS into BigQuery.

The customers_raw table was loaded separately for the initial test. The reusable script loaded the remaining seven tables.

## 5. Initial Data Validation

The following record counts were verified after ingestion:

| Table | Records |
|---|---:|
| customers_raw | 5 |
| products_raw | 5 |
| orders_raw | 10 |
| order_items_raw | 23 |
| payments_raw | 17 |
| shipments_raw | 5 |
| refunds_raw | 2 |
| order_events_raw | 28 |

Total Bronze records: 95.

## 6. Table Relationships

- Customers to Orders: One-to-Many
- Orders to Order Items: One-to-Many
- Products to Order Items: One-to-Many
- Orders to Payments: One-to-Many
- Orders to Shipments: One-to-Many
- Orders to Refunds: One-to-Many
- Orders to Order Events: One-to-Many

These relationships will be validated in downstream transformations.

When joining multiple one-to-many tables, aggregate each child table to the required grain first to prevent duplicate counting and inflated financial metrics.

## 7. Downstream Transformation Strategy

### Staging

- Convert STRING columns to appropriate data types.
- Standardize date and timestamp formats.
- Prepare source data for validation.

### Silver

- Remove or resolve duplicate records.
- Validate primary and foreign keys.
- Handle invalid and missing values.
- Apply business rules.
- Maintain reliable transactional datasets.

### Gold

- Build customer analytics.
- Build product performance metrics.
- Calculate order and revenue metrics.
- Prepare reporting-ready tables.

## 8. Query Optimization Strategy

Partitioning and clustering will be implemented on suitable larger transactional tables based on expected query patterns.

Planned optimization topics:

- Date-based partitioning.
- Ingestion-time partitioning.
- Clustered tables.
- Partition pruning.
- INFORMATION_SCHEMA metadata checks.
- Query execution plans.
- Bytes processed and query cost analysis.

These optimizations will be implemented and documented during the relevant project phase.

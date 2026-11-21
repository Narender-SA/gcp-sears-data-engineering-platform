
# SEARS - BigQuery Partitioning and Clustering

## 1. Objective

This document tracks the partitioning and clustering strategy for the SEARS BigQuery data warehouse.

The objective is to improve query performance and reduce unnecessary data scanning as the dataset grows.

## 2. Partitioning

Partitioning divides a BigQuery table into smaller sections based on a selected column or ingestion time.

Instead of scanning the entire table, BigQuery can scan only the relevant partitions when a query filters on the partitioning column.

### Planned Partitioning Strategy

| Table | Planned Partition Column |
|---|---|
| orders | order_date |
| payments | transaction_date |
| shipments | shipped_date |
| refunds | refund_date |
| order_events | event_date |

The actual column expressions and partition granularity will be finalized when we create the typed tables in the appropriate layer.

### Partitioning Types to Implement

1. Ingestion-time partitioning
2. Time-unit column partitioning
3. Daily partitioning
4. Partition pruning

## 3. Clustering

Clustering organizes data within BigQuery storage based on selected columns.

It can improve query performance when frequently filtering or joining on clustered columns.

### Planned Clustering Strategy

| Table | Candidate Clustering Columns |
|---|---|
| orders | customer_id, order_status |
| payments | order_id, payment_status |
| order_items | order_id, product_id |
| shipments | order_id, delivery_status |
| refunds | order_id, refund_status |
| order_events | order_id, new_status |

Final clustering choices will be based on actual query patterns and table size.

## 4. Practical Implementation

The project will demonstrate:

- Creating partitioned tables.
- Creating clustered tables.
- Querying specific date ranges.
- Understanding partition pruning.
- Checking partition metadata using INFORMATION_SCHEMA.
- Checking clustering metadata.
- Comparing bytes processed before and after optimization.
- Reviewing BigQuery query execution plans.

## 5. Cost and Performance Analysis

We will compare query performance and bytes processed between:

- Non-partitioned tables.
- Partitioned tables.
- Partitioned and clustered tables.

The results will be recorded using actual BigQuery query executions.

## 6. Current Status

- [ ] Partitioned tables implemented
- [ ] Clustered tables implemented
- [ ] INFORMATION_SCHEMA checks completed
- [ ] Partition pruning demonstrated
- [ ] Query execution plans reviewed
- [ ] Cost comparison documented

## 7. Important Design Considerations

Partitioning and clustering will not be applied blindly to every table.

The final design will consider:

- Table size.
- Query frequency.
- Common filter columns.
- Join patterns.
- Data growth.
- Query cost.

The purpose is to demonstrate meaningful optimization rather than adding unnecessary complexity.

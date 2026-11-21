
# SEARS - GCP Infrastructure Setup

## 1. Project Overview

This document describes the Google Cloud infrastructure created for the SEARS Enterprise E-commerce Data Engineering Platform.

The project uses Google Cloud Storage as the landing layer and BigQuery as the data warehouse.

## 2. GCP Project Configuration

- Cloud Provider: Google Cloud Platform
- Project ID: project-2425d17e-9385-4676-aab
- GCP Region: asia-south1 (Mumbai)

## 3. Google Cloud Storage

### Bucket Details

- Bucket Name: sears-ecommerce-landing-20261121
- Location: asia-south1
- Storage Class: STANDARD
- Access Control: Uniform bucket-level access

### Landing Folder Structure

```text
sears-ecommerce-landing-20261121/
|
├── historical/
│   ├── customers/
│   ├── products/
│   ├── orders/
│   ├── order_items/
│   ├── payments/
│   ├── shipments/
│   ├── refunds/
│   └── order_events/
|
├── daily/
├── archive/
└── quarantine/
```

### Source File Upload

Eight historical CSV datasets were uploaded from the local project into the GCS landing bucket.

## 4. BigQuery Configuration

### Bronze Dataset

- Dataset Name: sears_bronze
- Location: asia-south1
- Purpose: Store source data in its original representation.

### Bronze Tables

| Table Name | Source File |
|---|---|
| customers_raw | customers.csv |
| products_raw | products.csv |
| orders_raw | orders.csv |
| order_items_raw | order_items.csv |
| payments_raw | payments.csv |
| shipments_raw | shipments.csv |
| refunds_raw | refunds.csv |
| order_events_raw | order_events.csv |

## 5. Bronze Ingestion Design

- Source format: CSV
- Header row: Skipped during ingestion
- Schema: Explicitly defined
- Data types: STRING for all source columns
- Ingestion method: BigQuery bq load command
- Historical ingestion: Completed

All source columns are stored as STRING in Bronze to preserve source values. Type conversions and business transformations will be performed in downstream layers.

## 6. Initial Ingestion Validation

| Dataset | Records Loaded |
|---|---:|
| Customers | 5 |
| Products | 5 |
| Orders | 10 |
| Order Items | 23 |
| Payments | 17 |
| Shipments | 5 |
| Refunds | 2 |
| Order Events | 28 |
| Total | 95 |

All eight Bronze tables were successfully loaded and their record counts were verified against the historical source files.

## 7. Infrastructure Status

- [x] GCS landing bucket created
- [x] Historical folder prefixes created
- [x] Eight source CSV files uploaded
- [x] BigQuery Bronze dataset created
- [x] Eight Bronze tables loaded
- [x] Initial record counts verified

## 8. Future Implementation

The following components are planned and will be documented after implementation:

- BigQuery Staging, Silver and Gold layers
- Data quality and deduplication
- Partitioning and clustering
- Incremental ingestion and MERGE operations
- Audit and monitoring
- Apache Airflow orchestration

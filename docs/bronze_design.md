# SEARS — Bronze Layer Design and Ingestion

## 1. Purpose of the Bronze Layer

The Bronze layer is the raw data storage layer in our Medallion Architecture.

Its purpose is to ingest source-system data into BigQuery while preserving the original source values as closely as possible.

The Bronze layer provides:
- Raw data retention.
- Traceability to source files.
- A foundation for downstream transformations.
- Separation between ingestion and data cleansing.

## 2. Source Systems and Datasets

The SEARS project simulates data received from different e-commerce operational systems.

The following eight CSV datasets are used:

| Dataset | Description |
|---|---|
| customers | Customer master data |
| products | Product master data |
| orders | Customer order information |
| order_items | Individual products within orders |
| payments | Payment attempts and statuses |
| shipments | Shipment and delivery information |
| refunds | Refund transactions |
| order_events | Order status change history |

Python source simulators generate synthetic datasets for development and testing. In a production environment, these files would be received from actual operational source systems.

## 3. Google Cloud Storage Landing

Bucket:

`gs://sears-ecommerce-landing-20261121`

Region: `asia-south1`

The historical landing structure is:

```text
historical/
    customers/
    products/
    orders/
    order_items/
    payments/
    shipments/
    refunds/
    order_events/

daily/
archive/
quarantine/
```

The landing zone separates historical data from future daily incremental deliveries.

## 4. BigQuery Bronze Dataset

Dataset:

`sears_bronze`

Location: `asia-south1`

Eight raw tables were created:

- customers_raw
- products_raw
- orders_raw
- order_items_raw
- payments_raw
- shipments_raw
- refunds_raw
- order_events_raw

## 5. Schema Design

All Bronze columns are stored as STRING.

Reasons:

- Preserve source values during ingestion.
- Avoid ingestion failures caused by inconsistent source formats.
- Defer type conversion and validation to the Staging layer.
- Allow downstream investigation of malformed values.

The Staging layer performs SAFE_CAST and other type conversions.

## 6. Ingestion Process

The current ingestion process:

1. Generate synthetic CSV files using Python.
2. Upload the CSV files to Google Cloud Storage.
3. Load the files into BigQuery Bronze tables.
4. Use explicit schemas with STRING columns.
5. Verify record counts after ingestion.

The ingestion script is maintained at:

`scripts/load_bronze_tables.sh`

The customers dataset was loaded separately during the initial setup.

## 7. Initial Ingestion Results

| Bronze table | Initial records |
|---|---:|
| customers_raw | 5 |
| products_raw | 5 |
| orders_raw | 10 |
| order_items_raw | 23 |
| payments_raw | 17 |
| shipments_raw | 5 |
| refunds_raw | 2 |
| order_events_raw | 28 |
| **Total** | **95** |

These records represent the initial baseline dataset for functional testing, not the final production-scale volume.

## 8. Bronze Layer Design Decisions

- Keep raw values as STRING.
- Avoid business transformations in Bronze.
- Preserve source-level information.
- Keep ingestion scripts version-controlled in GitHub.
- Separate historical and daily landing folders.
- Perform data typing and validation in Staging.
- Plan incremental ingestion and audit tracking as future enhancements.

## 9. Current Implementation Status

Implemented:
- GCS landing bucket and folder structure.
- BigQuery Bronze dataset.
- Eight raw Bronze tables.
- CSV ingestion.
- STRING-based raw schemas.
- Initial record-count validation.
- Version-controlled ingestion script.

Future enhancements:
- Automated file-arrival detection.
- File-level ingestion audit.
- Load timestamps and source file metadata.
- Incremental daily ingestion.
- Duplicate-file detection.
- Retry and failure handling.

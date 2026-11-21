
# SEARS - Data Pipeline Execution

## 1. Project Overview

The SEARS Enterprise E-commerce Data Engineering Platform processes e-commerce data received from different operational systems.

The pipeline uses Google Cloud Storage for data landing and BigQuery for analytical processing.

## 2. Source Systems

The datasets represent information received from:

- Customer Management System
- Product Management System
- Order Management System
- Payment Gateway
- Logistics and Shipment System
- Refund Management System
- Order Event System

Note: The current project uses synthetic source data for development and testing because production source-system access is unavailable.

## 3. Source Data Generation

A Python-based source simulator generates sample datasets representing the operational source systems.

The simulator is used only for development and testing.

In a production environment, the pipeline would receive data directly from the actual operational systems.

## 4. Google Cloud Storage Landing

Eight historical CSV datasets are uploaded into the GCS landing bucket.

Bucket:

gs://sears-ecommerce-landing-20261121/

Folder structure:

historical/
    customers/
    products/
    orders/
    order_items/
    payments/
    shipments/
    refunds/
    order_events/

Other prefixes:

- daily/
- archive/
- quarantine/

## 5. Bronze Ingestion

The CSV files are loaded from GCS into BigQuery using the BigQuery command-line tool.

The reusable ingestion script is:

scripts/load_bronze_tables.sh

The script uses:

bq load

All source columns are initially stored as STRING.

## 6. Current Pipeline Status

Completed:

- Source simulator created.
- Eight historical datasets generated.
- Historical data validation completed.
- GCS landing bucket created.
- Eight CSV files uploaded.
- BigQuery Bronze dataset created.
- Eight Bronze tables loaded.
- Record counts verified.

Initial record count: 95.

## 7. Planned Pipeline Stages

### Staging

- Data type conversion.
- Date and timestamp standardization.
- Initial data preparation.

### Silver

- Deduplication.
- Data quality checks.
- Referential integrity.
- Business rule validation.
- Handling invalid and late-arriving records.

### Gold

- Revenue analytics.
- Customer analytics.
- Product performance.
- Order metrics.
- Reporting-ready datasets.

## 8. Future Incremental Processing

The pipeline will eventually support:

- Daily incoming files.
- Incremental ingestion.
- Watermark-based processing.
- BigQuery MERGE operations.
- Duplicate handling.
- Late-arriving records.
- Historical backfills.

## 9. Future Orchestration

Apache Airflow / Cloud Composer will orchestrate the pipeline.

Planned workflow:

1. Check source file availability.
2. Validate incoming files.
3. Load source data into Bronze.
4. Execute Staging transformations.
5. Execute Silver transformations.
6. Build Gold tables.
7. Run data quality checks.
8. Record execution status in audit tables.

## 10. Monitoring and Recovery

Future implementation will include:

- Pipeline execution logs.
- Task retries.
- Failure alerts.
- Data quality reporting.
- Audit tracking.
- Backfill support.

## 11. Implementation Status

The current implementation covers historical data ingestion into the BigQuery Bronze layer.

Staging, Silver, Gold, incremental processing and Airflow orchestration are planned next phases.

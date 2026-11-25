# SEARS — Enterprise E-commerce Data Engineering Platform

## Project Overview

SEARS is an end-to-end cloud data engineering project designed to process e-commerce data from multiple operational source systems and transform it into analytics-ready datasets.

The platform uses Google Cloud Platform (GCP) services and follows the Medallion Architecture (Bronze, Silver and Gold).

The project demonstrates practical data engineering concepts including data ingestion, data validation, data transformation, incremental processing, query optimization, workflow orchestration and business intelligence.

The implementation is being developed incrementally, with source code, SQL scripts, business rules, validation queries and technical documentation maintained in GitHub.

## Business Scenario

An e-commerce business receives data from multiple operational systems:

- Customer Management
- Product Management
- Order Management
- Payment Gateway
- Logistics and Shipment Management
- Refund Management

The objective is to integrate these datasets into a centralized analytical platform for business reporting and decision-making.

Since production source-system access is unavailable, a Python-based source data simulator generates realistic synthetic datasets for development and testing.

The actual data engineering pipeline begins when source files land in Google Cloud Storage.

## Architecture

```text
Operational Source Systems
          |
          v
Python Source Data Simulator
(Development and Testing Only)
          |
          v
Google Cloud Storage
      Landing Zone
          |
          v
BigQuery Bronze
    Raw Tables
          |
          v
BigQuery Staging
(Type Conversion and Standardization)
          |
          v
BigQuery Silver
(Data Quality and Business Validation)
          |
          v
BigQuery Gold
(Analytical Fact and Dimension Tables)
          |
          v
Looker Studio
(Business Dashboards and Reporting)
```

Apache Airflow / Cloud Composer will be introduced for workflow orchestration.

## Technology Stack

| Technology | Purpose | Status |
|---|---|---|
| Python | Synthetic source data generation and validation | Implemented |
| Google Cloud Storage | Source file landing | Implemented |
| BigQuery | Cloud data warehouse | Implemented |
| SQL | Data transformation and validation | Implemented |
| Bash | Bronze ingestion script | Implemented |
| Git and GitHub | Version control and documentation | Implemented |
| Pandas | Future Python-based data processing | Planned |
| Apache Airflow | Workflow orchestration | Planned |
| Cloud Composer | Managed Airflow orchestration | Planned |
| Looker Studio | Business dashboards and reporting | Planned |

## Source Datasets

The project currently uses eight related datasets:

1. Customers
2. Products
3. Orders
4. Order Items
5. Payments
6. Shipments
7. Refunds
8. Order Events

## Current Implementation Status

### Completed

**Project and source data**
- [x] Project structure created.
- [x] Python source data simulator developed.
- [x] Eight historical datasets generated.
- [x] Initial source data quality validation.
- [x] Primary key validation.
- [x] Foreign key validation.

**Google Cloud Storage and Bronze**
- [x] GCS landing bucket created.
- [x] Historical CSV files uploaded to GCS.
- [x] BigQuery Bronze dataset created.
- [x] Eight Bronze tables created and loaded.
- [x] Bronze columns stored as STRING.
- [x] Initial Bronze record counts verified (95 records).
- [x] Reusable Bash ingestion script created.

**Staging**
- [x] BigQuery Staging dataset created.
- [x] Eight Staging transformation tables implemented.
- [x] Data type conversion using SAFE_CAST.
- [x] String standardization using TRIM.
- [x] Initial record counts and primary-key validation.

**Silver**
- [x] BigQuery Silver dataset created.
- [x] Eight Silver tables implemented.
- [x] Deduplication using ROW_NUMBER().
- [x] Business-rule validation implemented.
- [x] Eight quarantine tables implemented.
- [x] Initial quarantine validation.
- [x] Silver business rules documented.

**Documentation and version control**
- [x] GCP infrastructure documentation.
- [x] Bronze layer design documentation.
- [x] Staging layer design documentation.
- [x] Silver layer design and business rules.
- [x] SQL validation scripts created.
- [x] Project files committed and pushed to GitHub.

### Planned

**Gold and analytics**
- [ ] Create BigQuery Gold dataset.
- [ ] Develop analytical fact and dimension tables.
- [ ] Build daily sales and revenue aggregations.
- [ ] Implement financial metrics for payments and refunds.
- [ ] Validate business KPIs and analytical results.

**Data engineering enhancements**
- [ ] Implement partitioning and clustering where appropriate.
- [ ] Perform query performance and cost optimization.
- [ ] Generate larger datasets for volume and performance testing.
- [ ] Implement daily incremental data ingestion.
- [ ] Implement BigQuery MERGE operations.
- [ ] Handle duplicate files and late-arriving records.
- [ ] Develop audit logging and data quality monitoring.

**Orchestration and reporting**
- [ ] Introduce Apache Airflow orchestration.
- [ ] Evaluate Cloud Composer deployment.
- [ ] Build Looker Studio business dashboards.
- [ ] Connect Looker Studio to BigQuery Gold tables.

## Google Cloud Configuration

- Cloud Provider: Google Cloud Platform
- Project ID: `project-2425d17e-9385-4676-aab`
- Region: `asia-south1`
- GCS Bucket: `sears-ecommerce-landing-20261121`
- BigQuery Bronze Dataset: `sears_bronze`
- BigQuery Staging Dataset: `sears_staging`
- BigQuery Silver Dataset: `sears_silver`
- BigQuery Gold Dataset: Planned

## Project Documentation

Detailed technical documentation is maintained in the `docs/` directory.

- [GCP Infrastructure Setup](docs/gcp_setup.md)
- [Bronze Layer Design](docs/bronze_design.md)
- [Staging Layer Design](docs/staging_design.md)
- [Silver Layer Design and Business Rules](docs/silver_design.md)
- [BigQuery Warehouse Design](docs/bigquery_design.md)
- [Partitioning and Clustering](docs/partitioning_clustering.md)
- [Pipeline Execution](docs/pipeline_execution.md)

SQL implementations are maintained under:

- `sql/bronze/`
- `sql/staging/`
- `sql/silver/`
- `sql/validation/`

## Project Objective

The objective is to build a realistic, scalable and maintainable cloud data engineering platform that demonstrates the practical skills required for a GCP Data Engineer role.

The project will progress from raw data ingestion to validated analytical datasets, automated orchestration and business intelligence reporting.

All implementation details, business rules, validation queries and project decisions will be maintained in GitHub.

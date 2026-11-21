
# SEARS - Enterprise E-commerce Data Engineering Platform

## Project Overview

SEARS is an end-to-end cloud data engineering project designed to process e-commerce data from multiple operational source systems and transform it into analytics-ready datasets.

The platform uses Google Cloud Platform services and follows the Medallion Architecture (Bronze, Silver and Gold).

The project demonstrates practical data engineering concepts including data ingestion, data validation, data transformation, incremental processing, query optimization and workflow orchestration.

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
       Landing
          |
          v
BigQuery Bronze
     Raw Tables
          |
          v
BigQuery Staging
          |
          v
BigQuery Silver
          |
          v
BigQuery Gold
          |
          v
Business Reporting / Analytics
```

Apache Airflow / Cloud Composer will be added for workflow orchestration.

## Technology Stack

| Technology | Purpose |
|---|---|
| Python | Source data simulation and data validation |
| Pandas | Local data handling and validation |
| Google Cloud Storage | Source file landing |
| BigQuery | Cloud data warehouse |
| SQL | Data transformation and analytics |
| Apache Airflow | Planned workflow orchestration |
| Git and GitHub | Version control and project management |

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

- [x] Project structure created
- [x] Python source data simulator developed
- [x] Eight historical datasets generated
- [x] Initial data quality validation
- [x] Primary key validation
- [x] Foreign key validation
- [x] GCS landing bucket created
- [x] Eight historical CSV files uploaded
- [x] BigQuery Bronze dataset created
- [x] Eight Bronze tables loaded
- [x] Bronze record counts verified (95 records)
- [x] Reusable Bash ingestion script created

### Planned

- [ ] BigQuery Staging transformations
- [ ] Data type conversion and standardization
- [ ] Silver layer transformations
- [ ] Deduplication and business validation
- [ ] Gold analytical tables
- [ ] Partitioning and clustering
- [ ] Query performance and cost optimization
- [ ] Incremental data ingestion
- [ ] BigQuery MERGE operations
- [ ] Late-arriving data handling
- [ ] Audit and monitoring
- [ ] Apache Airflow orchestration

## Google Cloud Configuration

- Cloud Provider: Google Cloud Platform
- Region: asia-south1
- GCS Bucket: sears-ecommerce-landing-20261121
- BigQuery Bronze Dataset: sears_bronze

## Project Documentation

Detailed technical documentation is available in the `docs/` directory:

- [GCP Infrastructure Setup](docs/gcp_setup.md)
- [BigQuery Warehouse Design](docs/bigquery_design.md)
- [Partitioning and Clustering](docs/partitioning_clustering.md)
- [Pipeline Execution](docs/pipeline_execution.md)

## Project Objective

The objective is to build a realistic, scalable and maintainable cloud data engineering platform that demonstrates the practical skills required for a GCP Data Engineer role.

The project will be developed incrementally, with implementation details and execution evidence maintained in this repository.

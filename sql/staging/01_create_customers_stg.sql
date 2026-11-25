
CREATE OR REPLACE TABLE
  `project-2425d17e-9385-4676-aab.sears_staging.customers_stg`
AS
SELECT
  TRIM(customer_id) AS customer_id,
  TRIM(customer_name) AS customer_name,
  TRIM(email) AS email,
  TRIM(phone) AS phone,
  TRIM(city) AS city,
  TRIM(state) AS state,
  TRIM(region) AS region,

  SAFE_CAST(registration_date AS DATE) AS registration_date,
  SAFE_CAST(updated_at AS TIMESTAMP) AS updated_at,
  SAFE_CAST(is_deleted AS BOOL) AS is_deleted

FROM
  `project-2425d17e-9385-4676-aab.sears_bronze.customers_raw`;

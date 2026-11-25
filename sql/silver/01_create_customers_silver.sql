
CREATE TEMP TABLE customer_candidates AS
SELECT
  *,
  ROW_NUMBER() OVER (
    PARTITION BY customer_id
    ORDER BY updated_at DESC
  ) AS _rn
FROM
  `project-2425d17e-9385-4676-aab.sears_staging.customers_stg`;

CREATE OR REPLACE TABLE
  `project-2425d17e-9385-4676-aab.sears_silver.customers_quarantine`
AS
SELECT
  * EXCEPT (_rn),
  CASE
    WHEN customer_id IS NULL OR TRIM(customer_id) = ''
      THEN 'Missing customer_id'
    WHEN customer_name IS NULL OR TRIM(customer_name) = ''
      THEN 'Missing customer_name'
    WHEN _rn > 1
      THEN 'Duplicate customer_id'
  END AS reject_reason
FROM customer_candidates
WHERE
  customer_id IS NULL
  OR TRIM(customer_id) = ''
  OR customer_name IS NULL
  OR TRIM(customer_name) = ''
  OR _rn > 1;

CREATE OR REPLACE TABLE
  `project-2425d17e-9385-4676-aab.sears_silver.customers_silver`
AS
SELECT * EXCEPT (_rn)
FROM customer_candidates
WHERE
  customer_id IS NOT NULL
  AND TRIM(customer_id) != ''
  AND customer_name IS NOT NULL
  AND TRIM(customer_name) != ''
  AND _rn = 1;

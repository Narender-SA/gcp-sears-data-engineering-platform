
CREATE TEMP TABLE product_candidates AS
SELECT
  *,
  ROW_NUMBER() OVER (
    PARTITION BY product_id
    ORDER BY updated_at DESC
  ) AS _rn
FROM
  `project-2425d17e-9385-4676-aab.sears_staging.products_stg`;

CREATE OR REPLACE TABLE
  `project-2425d17e-9385-4676-aab.sears_silver.products_quarantine`
AS
SELECT
  * EXCEPT (_rn),
  CASE
    WHEN product_id IS NULL OR TRIM(product_id) = ''
      THEN 'Missing product_id'
    WHEN product_name IS NULL OR TRIM(product_name) = ''
      THEN 'Missing product_name'
    WHEN list_price IS NULL
      THEN 'Invalid or missing list_price'
    WHEN list_price < 0
      THEN 'Negative list_price'
    WHEN _rn > 1
      THEN 'Duplicate product_id'
  END AS reject_reason
FROM product_candidates
WHERE
  product_id IS NULL
  OR TRIM(product_id) = ''
  OR product_name IS NULL
  OR TRIM(product_name) = ''
  OR list_price IS NULL
  OR list_price < 0
  OR _rn > 1;

CREATE OR REPLACE TABLE
  `project-2425d17e-9385-4676-aab.sears_silver.products_silver`
AS
SELECT * EXCEPT (_rn)
FROM product_candidates
WHERE
  product_id IS NOT NULL
  AND TRIM(product_id) != ''
  AND product_name IS NOT NULL
  AND TRIM(product_name) != ''
  AND list_price IS NOT NULL
  AND list_price >= 0
  AND _rn = 1;

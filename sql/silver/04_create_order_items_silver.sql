
CREATE TEMP TABLE order_item_candidates AS
SELECT
  *,
  ROW_NUMBER() OVER (
    PARTITION BY order_item_id
    ORDER BY updated_at DESC
  ) AS _rn
FROM
  `project-2425d17e-9385-4676-aab.sears_staging.order_items_stg`;

CREATE OR REPLACE TABLE
  `project-2425d17e-9385-4676-aab.sears_silver.order_items_quarantine`
AS
SELECT
  i.* EXCEPT (_rn),
  CASE
    WHEN i.order_item_id IS NULL OR TRIM(i.order_item_id) = ''
      THEN 'Missing order_item_id'
    WHEN i.order_id IS NULL OR TRIM(i.order_id) = ''
      THEN 'Missing order_id'
    WHEN i.product_id IS NULL OR TRIM(i.product_id) = ''
      THEN 'Missing product_id'
    WHEN o.order_id IS NULL
      THEN 'Order not found'
    WHEN pr.product_id IS NULL
      THEN 'Product not found'
    WHEN i.quantity IS NULL OR i.quantity <= 0
      THEN 'Invalid quantity'
    WHEN i.unit_price_at_purchase IS NULL
      THEN 'Missing purchase price'
    WHEN i.unit_price_at_purchase < 0
      THEN 'Negative purchase price'
    WHEN i.discount_percent IS NULL
      THEN 'Missing discount percent'
    WHEN i.discount_percent < 0 OR i.discount_percent > 100
      THEN 'Discount percent outside 0-100'
    WHEN i._rn > 1
      THEN 'Duplicate order_item_id'
  END AS reject_reason
FROM order_item_candidates AS i
LEFT JOIN
  `project-2425d17e-9385-4676-aab.sears_silver.orders_silver` AS o
  ON i.order_id = o.order_id
LEFT JOIN
  `project-2425d17e-9385-4676-aab.sears_silver.products_silver` AS pr
  ON i.product_id = pr.product_id
WHERE
  i.order_item_id IS NULL OR TRIM(i.order_item_id) = ''
  OR i.order_id IS NULL OR TRIM(i.order_id) = ''
  OR i.product_id IS NULL OR TRIM(i.product_id) = ''
  OR o.order_id IS NULL
  OR pr.product_id IS NULL
  OR i.quantity IS NULL OR i.quantity <= 0
  OR i.unit_price_at_purchase IS NULL
  OR i.unit_price_at_purchase < 0
  OR i.discount_percent IS NULL
  OR i.discount_percent < 0 OR i.discount_percent > 100
  OR i._rn > 1;

CREATE OR REPLACE TABLE
  `project-2425d17e-9385-4676-aab.sears_silver.order_items_silver`
AS
SELECT
  i.* EXCEPT (_rn)
FROM order_item_candidates AS i
INNER JOIN
  `project-2425d17e-9385-4676-aab.sears_silver.orders_silver` AS o
  ON i.order_id = o.order_id
INNER JOIN
  `project-2425d17e-9385-4676-aab.sears_silver.products_silver` AS pr
  ON i.product_id = pr.product_id
WHERE
  i.order_item_id IS NOT NULL
  AND TRIM(i.order_item_id) != ''
  AND i.order_id IS NOT NULL
  AND TRIM(i.order_id) != ''
  AND i.product_id IS NOT NULL
  AND TRIM(i.product_id) != ''
  AND i.quantity IS NOT NULL
  AND i.quantity > 0
  AND i.unit_price_at_purchase IS NOT NULL
  AND i.unit_price_at_purchase >= 0
  AND i.discount_percent IS NOT NULL
  AND i.discount_percent BETWEEN 0 AND 100
  AND i._rn = 1;

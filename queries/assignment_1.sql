USE RetailDB; GO

-- Q1: Expected grain: one row per order line
SELECT TOP (20)
    line_id,
    order_id,
    order_date,
    product_name AS product,
    quantity,
    unit_price AS price_per_unit
FROM dbo.order_items
ORDER BY line_id;

-- Q2. grain: one row per unique region and sales_channel combination
SELECT DISTINCT region, sales_channel
FROM dbo.order_items
WHERE region IS NOT NULL
ORDER BY region, sales_channel;

-- Q3.grain: one row per order line (Electronics, unit_price >= 100, quantity >= 2)
SELECT order_id, order_date, region, product_name, quantity,unit_price
FROM dbo.order_items
WHERE category = 'Electronics'
  AND unit_price >=  100
  AND quantity >= 2
ORDER BY unit_price DESC, order_id;

-- Q4. grain: one row per order line (Online/Partner, 2026-01-01 up to but excluding 2026-04-01)
SELECT order_id,order_date, sales_channel, category, product_name
FROM dbo.order_items
WHERE sales_channel IN ('Online', 'Partner')
  AND order_date >= '2026-01-01'
  AND order_date < '2026-04-01'
ORDER BY order_date ASC, order_id ASC;

-- Q5. grain: one row per order line (top 15 by gross value before discount)
SELECT TOP (15)
    order_id,
    product_name,
    quantity,
    unit_price,
    ROUND(quantity * unit_price, 2) AS gross_line_value
FROM dbo.order_items
ORDER BY gross_line_value DESC, line_id;

-- Q6. grain: one row per order line (trimmed product name starts with S)
SELECT line_id,
       product_name,
       TRIM(UPPER(product_name)) AS product_label
FROM dbo.order_items
WHERE TRIM(UPPER(product_name)) LIKE 'S%'
ORDER BY product_label, line_id;

-- Q7 grain: one row per order line (created in 2026)
-- YEAR() and MONTH() already return INT in SQL Server, so no CAST is needed
SELECT order_id,
       order_date,
       YEAR(order_date) AS order_year,
       MONTH(order_date) AS order_month
FROM dbo.order_items
WHERE YEAR(order_date) = 2026
ORDER BY order_date, order_id;

-- Q8 grain: one row per order line (shipped_date is NULL)
SELECT order_id,
       order_date,
       product_name,
       -- The coalesce ensures that order lines without shipped date (NULL) are replaced with Not shipped. 
       -- And the where filter ensures that only the replaced string is allowed through. 
       -- As such, the column would show the shipment date as text if a shipped row ever got through, so the NULL handling is explicit rather than relying on the filter.
       COALESCE(CAST(shipped_date AS VARCHAR(10)), 'Not shipped') AS shipment_status
FROM dbo.order_items
WHERE shipped_date IS NULL
ORDER BY order_date , line_id;

-- Q9 grain: one row for the whole dataset
SELECT COUNT(*) AS total_rows,
       COUNT(region) AS rows_with_region,
       COUNT(*) - COUNT(region) AS rows_missing_region,
       COUNT(discount_pct) AS rows_with_discount,
       COUNT(*) - COUNT(discount_pct) AS rows_missing_discount
FROM dbo.order_items;

-- Q10 grain: one row for the whole dataset
SELECT COUNT(*) AS order_line_count,
       COUNT(DISTINCT order_id) AS distinct_order_count,
       SUM(quantity) AS total_units,
       ROUND(AVG(unit_price), 2) AS unit_price_avg,
       MIN(unit_price) AS unit_price_min,
       MAX(unit_price) AS unit_price_max,
       ROUND(SUM(quantity * unit_price), 2) AS gross_revenue_total
FROM dbo.order_items;
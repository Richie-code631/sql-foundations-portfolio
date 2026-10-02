USE RetailDB; GO

-- Expected grain: one row per order line
SELECT TOP (20)
    line_id,
    order_id,
    order_date,
    product_name AS product,
    quantity,
    unit_price AS price_per_unit
FROM dbo.order_items
ORDER BY line_id;

--Q2. grain: one row per unique region and sales_channel combination
SELECT DISTINCT region, sales_channel
FROM dbo.order_items
WHERE region IS NOT NULL
ORDER BY region, sales_channel;

--Q3.grain: one row per order line (Electronics, unit_price >= 100, quantity >= 2)
SELECT order_id, order_date, region, product_name, quantity,unit_price
FROM dbo.order_items
WHERE category = 'Electronics'
  AND unit_price >=  100
  AND quantity >= 2
ORDER BY unit_price DESC, order_id;

--Q4. grain: one row per order line (Online/Partner, 2026-01-01 up to but excluding 2026-04-01)
SELECT order_id,order_date, sales_channel, category, product_name
FROM dbo.order_items
WHERE sales_channel IN ('Online', 'Partner')
  AND order_date >= '2026-01-01'
  AND order_date < '2026-04-01'
ORDER BY order_date ASC, order_id ASC;


# SQL Foundations Portfolio

- **Name:** Richmond Panyin Assafuah
- **SQL dialect / DBMS:** SQL Server (T-SQL), run in SSMS
- **The Dataset version:** Week 1 Retail Database (RetailDB), Retail_Database_SQLServer.sql


## Question 5: Calculated gross value

```sql
SELECT TOP (15)
    order_id,
    product_name,
    quantity,
    unit_price,
    ROUND(quantity * unit_price, 2) AS gross_line_value
FROM dbo.order_items
ORDER BY gross_line_value DESC, line_id;
```

**Interpretation:** Across all order lines in the dataset, I measured the highest gross line value and found the top value is 3499.95 (calculated from quantity multiplied by unit price before discount), from Smartphone lines of 5 units at 699.99. 
Every row in the top 15 is from the same product, not a ranking of different products. 
24 lines tie at that value, but only 15 are displayed, chosen by the line_id tiebreaker, which leaves 9 order lines out.

```sql
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
```

**Interpretation:** Of the 1,080 order lines in the dataset, 324 (30%) have no shipment date. 
They appear throughout the year: 163 are from January to June and 161 from July to December, about 30% of the lines in each half. 
A missing shipped_date can mean "not yet shipped" or "date unavailable", so these lines are not all confirmed unshipped.

```sql
-- Q10 grain: one row for the whole dataset
SELECT COUNT(*) AS order_line_count,
       COUNT(DISTINCT order_id) AS distinct_order_count,
       SUM(quantity) AS total_units,
       ROUND(AVG(unit_price), 2) AS unit_price_avg,
       MIN(unit_price) AS unit_price_min,
       MAX(unit_price) AS unit_price_max,
       ROUND(SUM(quantity * unit_price), 2) AS gross_revenue_total
FROM dbo.order_items;
```

**Interpretation:** Across all 1,080 order lines, the total gross revenue before discount reached 481,176.24. 
Structurally, the dataset spans 360 distinct orders, resulting in an average of exactly 3 line items per order. 
Product pricing spans from a minimum unit price of 15.00 to a maximum of 699.99, 150.66 average unit price per order line across all order lines.







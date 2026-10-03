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







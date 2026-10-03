```sql
-- Table: products
-- Columns:
-- ProductID, ProductName, SupplierID, CategoryID, Unit, Price

-- Problem:
-- Find the product(s) with the minimum price in each category.


-- ============================================================
-- Approach 1: GROUP BY + JOIN
-- ============================================================

SELECT
    p.ProductName,
    p.Price
FROM
    (
        SELECT
            CategoryID,
            MIN(Price) AS Price
        FROM products
        GROUP BY CategoryID
    ) AS min_price
JOIN products AS p
    ON min_price.CategoryID = p.CategoryID
    AND min_price.Price = p.Price;


-- ============================================================
-- Approach 2: Correlated Subquery
-- ============================================================

SELECT
    p.ProductName,
    p.Price
FROM products AS p
WHERE p.Price = (
    SELECT MIN(p2.Price)
    FROM products AS p2
    WHERE p2.CategoryID = p.CategoryID
);
```

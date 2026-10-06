-- ============================================================
-- QUESTION:
-- Display customers who have placed more than 2 orders.
--
-- Requirements:
-- 1. Return CustomerID
-- 2. Return CustomerName
-- 3. Return the number of orders placed by each customer
-- 4. Only include customers with more than 2 orders
-- ============================================================


-- ============================================================
-- Table: customers
-- ============================================================
-- Columns:
-- CustomerID
-- CustomerName
-- ContactName
-- Address
-- City
-- PostalCode
-- Country


-- ============================================================
-- Table: orders
-- ============================================================
-- Columns:
-- OrderID
-- CustomerID
-- EmployeeID
-- OrderDate
-- ShipperID


-- ============================================================
-- Approach 1: Pre-aggregate orders and then JOIN
-- ============================================================

SELECT 
    o.CustomerID,
    c.CustomerName,
    o.OrderCount
FROM (
    SELECT 
        CustomerID,
        COUNT(*) AS OrderCount
    FROM orders
    GROUP BY CustomerID
    HAVING COUNT(*) > 2
) AS o
LEFT JOIN customers AS c
    ON c.CustomerID = o.CustomerID;


-- PERFORMANCE:
-- 1. The orders table is grouped first.
-- 2. Customers with <= 2 orders are filtered before the JOIN.
-- 3. The JOIN operates on the smaller aggregated result.
-- 4. LEFT JOIN is not necessary because every CustomerID
--    in the subquery has at least one order.
-- 5. Time Complexity: Approximately O(O + C), depending on
--    the execution plan.
-- 6. Space Complexity: O(C) approximately for the grouped result.
-- 7. Can perform well when the orders table is very large and
--    the HAVING condition significantly reduces the result.
-- 8. However, the derived table makes the query more complex.


-- ============================================================
-- Approach 2: JOIN first and then GROUP BY
-- ============================================================

SELECT 
    c.CustomerID,
    c.CustomerName,
    COUNT(o.OrderID) AS OrderCount
FROM customers AS c
INNER JOIN orders AS o
    ON c.CustomerID = o.CustomerID
GROUP BY 
    c.CustomerID,
    c.CustomerName
HAVING COUNT(o.OrderID) > 2;


-- PERFORMANCE:
-- 1. INNER JOIN is appropriate because customers with zero orders
--    cannot have more than 2 orders.
-- 2. GROUP BY calculates the order count for each customer.
-- 3. HAVING filters customers with more than 2 orders.
-- 4. Simpler query and easier to read and maintain.
-- 5. Time Complexity: Approximately O(O + C), depending on
--    the execution plan.
-- 6. Space Complexity: Depends on the GROUP BY/join strategy.
-- 7. The optimizer may transform this query into an execution
--    plan similar to Approach 1.
-- 8. An index on orders(CustomerID) can improve performance.


-- ============================================================
-- RECOMMENDATION
-- ============================================================

-- BEST CHOICE FOR INTERVIEWS:
-- Approach 2
--
-- Reasons:
-- 1. Simpler
-- 2. More readable
-- 3. Directly expresses JOIN + GROUP BY + HAVING
-- 4. No unnecessary derived table
-- 5. No unnecessary LEFT JOIN
--
-- IMPORTANT:
-- Do NOT say Approach 2 is ALWAYS faster.
-- Actual performance depends on:
--   - Database engine
--   - Indexes
--   - Table size
--   - Data distribution
--   - Statistics
--   - Query optimizer
--   - Execution plan


-- ============================================================
-- RECOMMENDED INDEX
-- ============================================================

-- CREATE INDEX idx_orders_customerid
-- ON orders(CustomerID);

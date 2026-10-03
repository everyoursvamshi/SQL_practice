-- Table: customers
-- Columns: CustomerID, CustomerName, ContactName, Address,
--          City, PostalCode, Country

-- Table: orders
-- Columns: OrderID, CustomerID, EmployeeID, OrderDate, ShipperID


-- ============================================================
-- Approach 1: NOT IN
-- ============================================================

SELECT *
FROM customers
WHERE CustomerID NOT IN (
    SELECT DISTINCT CustomerID
    FROM orders
);

-- PERFORMANCE:
-- 1. DISTINCT requires additional work to remove duplicates.
-- 2. The database may need to scan/process the orders table
--    before evaluating the NOT IN condition.
-- 3. Time Complexity: Approximately O(C + O), depending on
--    the execution plan, where:
--       C = number of customers
--       O = number of orders
-- 4. Space Complexity: O(O) in the worst case if the database
--    materializes the DISTINCT CustomerID values.
-- 5. IMPORTANT: NOT IN can produce unexpected results if
--    orders.CustomerID contains NULL.
-- 6. Generally not the preferred approach.


-- ============================================================
-- Approach 2: LEFT JOIN + IS NULL
-- ============================================================

SELECT c.*
FROM customers AS c
LEFT JOIN orders AS o
    ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;

-- PERFORMANCE:
-- 1. LEFT JOIN allows the database optimizer to use an index
--    on orders.CustomerID efficiently.
-- 2. No DISTINCT is required.
-- 3. Time Complexity: Approximately O(C + O), depending on
--    the execution plan and indexes.
-- 4. Space Complexity: Generally O(C) or O(O), depending on
--    the join algorithm chosen by the optimizer.
-- 5. NULL-safe for this use case.
-- 6. Generally preferred over NOT IN.


-- ============================================================
-- Approach 3: NOT EXISTS
-- ============================================================

SELECT c.*
FROM customers AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM orders AS o
    WHERE o.CustomerID = c.CustomerID
);

-- PERFORMANCE:
-- 1. NOT EXISTS can stop searching as soon as a matching
--    order is found for a customer.
-- 2. An index on orders(CustomerID) can make this very efficient.
-- 3. Time Complexity: Approximately O(C * lookup),
--    where lookup can approach O(log O) with an index.
-- 4. Space Complexity: Generally O(1) additional working space,
--    depending on the execution plan.
-- 5. NULL-safe.
-- 6. No DISTINCT is required.
-- 7. Often an excellent choice for this type of query.


-- ============================================================
-- RECOMMENDATION
-- ============================================================

-- Best practical choices:
--
-- 1. NOT EXISTS       -> Excellent for finding non-matching rows
-- 2. LEFT JOIN        -> Excellent and very common in interviews
-- 3. NOT IN           -> Works, but NULL handling can be problematic
--
-- IMPORTANT:
-- Actual performance depends on the database engine, indexes,
-- table size, data distribution, statistics, and execution plan.
--
-- Recommended index:
--
-- CREATE INDEX idx_orders_customerid
-- ON orders(CustomerID);

use mscds;
select*from amazonsalereport;
select * from internationalsalereport;
SHOW COLUMNS FROM internationalsalereport;


ALTER TABLE internationalsalereport
CHANGE `GROSS AMT` `gross_amt` double;


ALTER TABLE amazonsalereport
CHANGE `Order ID` `order_id` text;


-- 1. SELECT, WHERE, ORDER BY, GROUP BY
-- Select all columns from International Sale Report
SELECT * FROM InternationalSaleReport;

-- Select sales only in June 2021
SELECT customer, style, pcs, gross_amt
FROM InternationalSaleReport
WHERE months = 'Jun-21'
ORDER BY gross_amt DESC;

-- Group sales by Customer and find their total sales
SELECT customer, SUM(gross_amt) AS total_sales
FROM InternationalSaleReport
GROUP BY customer
ORDER BY total_sales DESC;

-- 2. JOINS (INNER JOIN, LEFT JOIN, RIGHT JOIN)

-- INNER JOIN: Matching sales by SKU
SELECT a.order_id, a.sku, a.amount, i.customer, i.gross_amt
FROM AmazonSaleReport a
INNER JOIN InternationalSaleReport i
ON a.sku = i.sku;

-- LEFT JOIN: All Amazon orders, matched with International sales
SELECT a.order_id, a.sku, i.customer, i.gross_amt
FROM AmazonSaleReport a
LEFT JOIN InternationalSaleReport i
ON a.sku = i.sku;

-- RIGHT JOIN: All International sales, matched with Amazon orders
SELECT a.order_id, a.sku, i.customer, i.gross_amt
FROM AmazonSaleReport a
RIGHT JOIN InternationalSaleReport i
ON a.sku = i.sku;
-- (Note: RIGHT JOIN behaves differently if Amazon sales have missing SKUs.)

-- 3. Subqueries

-- Subquery to find customers whose total sales > 5000
SELECT customer, total_sales
FROM (
    SELECT customer, SUM(gross_amt) AS total_sales
    FROM InternationalSaleReport
    GROUP BY customer
) AS sales_summary
WHERE total_sales > 5000;

-- 4. Aggregate Functions (SUM, AVG)
-- Total sales amount
SELECT SUM(gross_amt) AS total_gross_sales FROM InternationalSaleReport;

-- Average number of pieces sold per order
SELECT AVG(pcs) AS avg_pieces_sold FROM InternationalSaleReport;

-- Amazon sales: Average order amount
SELECT AVG(amount) AS avg_order_amount FROM AmazonSaleReport;


-- 5. Views
-- Create a view for high-value international sales
CREATE VIEW HighValueInternationalSales AS
SELECT customer, style, pcs, gross_amt
FROM InternationalSaleReport
WHERE gross_amt > 1000;

-- Create a view for Amazon Delivered Orders
CREATE VIEW AmazonDeliveredOrders AS
SELECT order_id, sku, amount
FROM AmazonSaleReport
WHERE status LIKE '%Delivered%';


-- 6. Indexes (to speed up queries)
-- Index on SKU to speed up JOINs
CREATE INDEX idx_sku_international ON InternationalSaleReport(sku(50));

-- Index on Amazon order date for faster date-based queries
CREATE INDEX idx_order_date_amazon ON AmazonSaleReport(date(20));
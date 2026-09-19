CREATE DATABASE ecommerce_sales;
USE ecommerce_sales;
SELECT COUNT(*) AS total_records 
FROM ecommerce_sales.sales_orders; 

SELECT * 
FROM ecommerce_sales.sales_orders 
LIMIT 10; 

DESCRIBE 
ecommerce_sales.sales_orders; 

SELECT COUNT(*) AS total_rows, 
SUM(Order_ID IS NULL) AS missing_order_id, 
SUM(Order_Date IS NULL) AS missing_order_date, 
SUM(Customer_ID IS NULL) AS missing_customer_id, 
SUM(Customer_Name IS NULL) AS missing_customer_name,
SUM(Region IS NULL) AS missing_region, 
SUM(City IS NULL) AS missing_city, 
SUM(Category IS NULL) AS missing_category, 
SUM(Product IS NULL) AS missing_product, 
SUM(Quantity IS NULL) AS missing_quantity, 
SUM(Unit_Price IS NULL) AS missing_price, 
SUM('Discount_%' IS NULL) AS missing_discount, 
SUM(Payment_Method IS NULL) AS missing_payment, 
SUM(Order_Status IS NULL) AS missing_status, 
SUM(Delivery_Days IS NULL) AS missing_delivery_days, 
SUM(Customer_Rating IS NULL) AS missing_rating 
FROM ecommerce_sales.sales_orders; 

SELECT 
Customer_Rating, 
COUNT(*) AS frequency 
FROM ecommerce_sales.sales_orders 
GROUP BY Customer_Rating 
ORDER BY Customer_Rating; 

ALTER TABLE ecommerce_sales.sales_orders
DROP COLUMN Customer_Rating_Num;
ALTER TABLE ecommerce_sales.sales_orders
ADD COLUMN Customer_Rating_Num DECIMAL(3,1);

SET SQL_SAFE_UPDATES = 0;
UPDATE ecommerce_sales.sales_orders
SET Customer_Rating_Num = CAST(TRIM(Customer_Rating) AS DECIMAL(3,1))
WHERE Customer_Rating IS NOT NULL AND Customer_Rating != '';
SET SQL_SAFE_UPDATES = 1;

SELECT Customer_Rating, Customer_Rating_Num
FROM ecommerce_sales.sales_orders
LIMIT 20;

SELECT 
Order_ID, 
COUNT(*) AS occurrences 
FROM ecommerce_sales.sales_orders 
GROUP BY Order_ID 
HAVING COUNT(*) > 1; 

SELECT 
Order_Status, 
COUNT(*) AS total_orders 
FROM ecommerce_sales.sales_orders 
GROUP BY Order_Status; 

SELECT 
Order_ID, 
Product, 
Quantity, 
Unit_Price, 
'Discount_%', 
Quantity * Unit_Price AS Gross_Sales 
FROM ecommerce_sales.sales_orders 
LIMIT 20; 

SELECT 
Order_ID, 
Product, 
Quantity, 
Unit_Price, 
'Discount_%', 
Quantity * Unit_Price AS Gross_Sales, 
Quantity * Unit_Price * (1 - 'Discount_%') AS Net_Sales 
FROM ecommerce_sales.sales_orders 
LIMIT 20; 

SELECT 
SUM(Quantity * Unit_Price) 
AS Gross_Sales, 
SUM(Quantity * Unit_Price * (1 - 'Discount_%')) AS Net_Sales 
FROM ecommerce_sales.sales_orders 
WHERE Order_Status = 'Delivered'; 

SELECT Region, 
SUM(Quantity * Unit_Price * (1 - 'Discount_%')) AS Total_Sales 
FROM ecommerce_sales.sales_orders 
WHERE Order_Status = 'Delivered' 
GROUP BY Region 
ORDER BY Total_Sales DESC; 

SELECT Category, 
SUM(Quantity * Unit_Price * (1 - 'Discount_%')) AS Total_Sales 
FROM ecommerce_sales.sales_orders 
WHERE Order_Status = 'Delivered' 
GROUP BY Category 
ORDER BY Total_Sales DESC; 

SELECT
Product, 
SUM(Quantity) AS Units_Sold, 
SUM(Quantity * Unit_Price * (1 - 'Discount_%')) AS Total_Sales 
FROM ecommerce_sales.sales_orders
WHERE Order_Status = 'Delivered' 
GROUP BY Product 
ORDER BY Total_Sales DESC; 

SELECT 
Product, 
SUM(Quantity) AS Units_Sold, 
SUM(Quantity * Unit_Price * (1 - 'Discount_%')) AS Total_Sales 
FROM ecommerce_sales.sales_orders 
WHERE Order_Status = 'Delivered' 
GROUP BY Product 
ORDER BY Total_Sales DESC 
LIMIT 10; 

SELECT 
City, 
SUM(Quantity * Unit_Price * (1 - 'Discount_%')) AS Total_Sales 
FROM ecommerce_sales.sales_orders 
WHERE Order_Status = 'Delivered' 
GROUP BY City 
ORDER BY Total_Sales DESC; 

SELECT 
Payment_Method, 
COUNT(*) AS Number_of_Orders, 
SUM(Quantity * Unit_Price * (1 - 'Discount_%')) AS Total_Sales 
FROM ecommerce_sales.sales_orders 
WHERE Order_Status = 'Delivered' 
GROUP BY Payment_Method 
ORDER BY Total_Sales DESC; 

SELECT AVG(Customer_Rating_Num) AS Average_Rating 
FROM ecommerce_sales.sales_orders; 

SELECT Category, 
AVG(Customer_Rating_Num) AS Average_Rating 
FROM ecommerce_sales.sales_orders 
GROUP BY Category 
ORDER BY Average_Rating DESC; 

SELECT AVG(Delivery_Days) AS Average_Delivery_Days 
FROM ecommerce_sales.sales_orders; 

SELECT Region, 
AVG(Delivery_Days) AS Average_Delivery_Days 
FROM ecommerce_sales.sales_orders 
GROUP BY Region 
ORDER BY Average_Delivery_Days; 

SELECT Delivery_Days, 
AVG(Customer_Rating_Num) AS Average_Rating, 
COUNT(*) AS Number_of_Orders 
FROM ecommerce_sales.sales_orders 
GROUP BY Delivery_Days 
ORDER BY Delivery_Days; 

SELECT 
DATE_FORMAT(Order_Date, '%Y-%m') AS Month, 
SUM(Quantity * Unit_Price * (1 - 'Discount_%')) AS Total_Sales 
FROM ecommerce_sales.sales_orders 
WHERE Order_Status = 'Delivered' 
GROUP BY Month 
ORDER BY Month; 

SELECT COUNT(*) AS Cancelled_Orders 
FROM ecommerce_sales.sales_orders 
WHERE Order_Status = 'Cancelled'; 

SELECT 
COUNT(CASE WHEN Order_Status = 'Cancelled' THEN 1 END) * 100.0 / COUNT(*) AS Cancellation_Rate 
FROM ecommerce_sales.sales_orders; 

SELECT 
Region, 
COUNT(*) AS Total_Orders, 
SUM(Order_Status = 'Cancelled') AS Cancelled_Orders, 
SUM(Order_Status = 'Cancelled') * 100.0 / COUNT(*) AS Cancellation_Rate 
FROM ecommerce_sales.sales_orders 
GROUP BY Region 
ORDER BY Cancellation_Rate DESC; 

CREATE OR REPLACE VIEW 
ecommerce_sales.sales_analysis AS 
SELECT 
Order_ID, 
Order_Date, Customer_ID, 
Customer_Name, 
Region, 
City, 
Category, 
Product, 
Quantity, 
Unit_Price, 
'Discount_%', 
Payment_Method, 
Order_Status, 
Delivery_Days, 
Customer_Rating_Num, 
Quantity * Unit_Price AS Gross_Sales, 
Quantity * Unit_Price * (1 - 'Discount_%') AS Net_Sales 
FROM ecommerce_sales.sales_orders; 

SELECT * 
FROM ecommerce_sales.sales_analysis 
LIMIT 10;
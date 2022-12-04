/*Answering problems using SQL Join queries and Subqueries*/
-- I use this database from a W3School tutorial. Even the dataset was common, it feels like 
-- I'm doing real world problems with this database and
-- especially a good practice for Joins because it has many tables and each table has primary keys and even foreign keys and a good
-- practice for subqueries. This database helps me to become more familiarize and skillful about SQL.
-- Simple queries can also answer problems.
-- I made also complicated codes to find the output what I desire such as "what are the products that their total sales are greater than 
-- the average of total sales of all products in this dataset?".
-- I also use UNION  for categories totalsales > avg total sales of all categories and total sales < avg total sales of all categories

-- NOTE: You can't do this MAX(SUM(()). It should be inner querry for SUM() then outer querry for MAX(), This is Subquery.
-- Left table join right table
-- INNER JOIN also known as JOIN

SELECT * FROM order_details;
SELECT * FROM products;
SELECT * FROM Suppliers;
SELECT * FROM shippers;
SELECT * FROM categories;
SELECT * FROM customers;
SELECT * FROM orders;
SELECT * FROM employees;

-- Shows the important data of each Order ID
-- product table should be on 2nd join because there's no productID in orders table.
SELECT OrderID,CustomerName,ProductName,ProductID,Unit,Quantity,Price,(Price*Quantity) AS TotalPrice FROM orders
JOIN order_details USING(orderID)
JOIN products USING(productID) 
JOIN customers USING(customerID) ORDER BY OrderID;

-- Shows the total quantity and Total Price recorded.
SELECT ProductID,ProductName,SUM(Quantity) AS TotalQuantity,ROUND(SUM(Quantity*Price),2) AS TotalPrice
FROM order_details
RIGHT JOIN products USING(productID) GROUP BY ProductID;

-- Greatest sales of the products
-- NOTE: Use SUM(Quantity*Price) becaues the data were grouped by productID or each product.
SELECT ProductID,ProductName, Price,SUM(Quantity) AS TotalQuantity,ROUND(SUM(Quantity*Price),2) AS TotalPrice
FROM order_details
JOIN products USING(productID) GROUP BY ProductID ORDER BY TotalPrice DESC LIMIT 1;

-- Least sales of the products
SELECT ProductID,ProductName, Price,SUM(Quantity) AS TotalQuantity,ROUND(SUM(Quantity*Price),2) AS TotalPrice
FROM order_details
JOIN products USING(productID) GROUP BY ProductID ORDER BY TotalPrice ASC LIMIT 1;

-- Max and minimum total quanty of the products.
/*MAX*/
SELECT ProductID,SupplierName,ProductName, Price,SUM(Quantity) AS TotalQuantity,ROUND(SUM(Quantity*Price),2) AS TotalPrice
FROM products
JOIN suppliers USING(SupplierID)
JOIN order_details USING(productID) GROUP BY ProductID ORDER BY TotalQuantity DESC LIMIT 1;
/*MIN*/
SELECT ProductID,SupplierName,ProductName, Price,SUM(Quantity) AS TotalQuantity,ROUND(SUM(Quantity*Price),2) AS TotalPrice
FROM products
JOIN suppliers USING(SupplierID)
JOIN order_details USING(productID) GROUP BY ProductID ORDER BY TotalQuantity ASC LIMIT 1;

-- Shows the total price of data.
SELECT ROUND(SUM(Quantity*Price),2) AS TotalPriceOfData 
FROM order_details
JOIN products USING(productID);

-- Shows the total sales of each SupplierID by their products
SELECT SupplierID, SupplierName, ProductName, SUM(Quantity),ROUND(SUM(Price),2),ROUND(SUM(Price*Quantity),2) AS SalesByProducts 
FROM Order_details
JOIN products USING(ProductID) 
JOIN Suppliers USING(SupplierID)
GROUP BY ProductName ORDER BY SalesByProducts DESC;

-- Shows the total sales of each Suppliers
SELECT SupplierID, ROUND(SUM(Price*Quantity),2) FROM Order_details
LEFT JOIN products USING(ProductID) GROUP BY SupplierID ORDER BY SupplierID;

-- Shows the total sales of each Suppliers with Supplier name.
SELECT SupplierID, SupplierName, ContactName, Country,ROUND(SUM(Price*Quantity),2) AS Sales FROM Products
JOIN Order_Details USING(ProductID) 
JOIN Suppliers USING(SupplierID) GROUP BY SupplierID ORDER BY Sales DESC;

-- Shows the total sales of each countries
SELECT Country,ROUND(SUM(Price*Quantity),2) AS SalesByCountry FROM Products
JOIN Order_Details USING(ProductID) 
JOIN Suppliers USING(SupplierID) GROUP BY Country ORDER BY SalesByCountry DESC;

-- Shows the number of shippings of each shippers.
SELECT ShipperID,ShipperName,Phone,Count(ShipperID) AS NumberOfShippings FROM shippers
JOIN Orders USING(ShipperID) GROUP BY ShipperID Order BY NumberOfShippings DESC;

-- Customer Ranking base on orders
-- repeated orderID because different product may have same OrderID because they were transacted all at once.
SELECT CustomerID, CustomerName, Count(CustomerID) AS NumberOfOrders FROM orders
JOIN customers USING(customerID) 
JOIN order_details USING(OrderID) WHERE CustomerID GROUP BY CustomerID ORDER BY NumberOfOrders DESC;
/*CHECKING IF ERNST HANDEL order 35 */
SELECT CustomerID, CustomerName, OrderID, ProductName, OrderDate FROM orders
JOIN customers USING(customerID) 
JOIN order_details USING(OrderID) 
JOIN products USING(productID)WHERE CustomerName LIKE 'Ernst%' ORDER BY customerID;
/*Ernst Handel Number of product with OrderID, How manyy orders in one transcation or OrderID*/
SELECT CustomerID, CustomerName, OrderID, OrderDate, COUNT(*) AS NoOfproductWithOrderID FROM orders
JOIN customers USING(customerID) 
JOIN order_details USING(OrderID) 
JOIN products USING(productID)WHERE CustomerName LIKE 'Ernst%' GROUP BY OrderID ORDER BY customerID;

-- each orderID. This mean how many transaction are done by each Customer.
SELECT CustomerID, CustomerName, Count(CustomerID) AS NumberOfOrders FROM orders
JOIN customers USING(customerID) 
WHERE CustomerID GROUP BY CustomerID ORDER BY NumberOfOrders DESC;

-- Top 1 customer with just includes ProductName and the products by each order ID.
SELECT CustomerID, CustomerName, OrderID, ProductName, OrderDate, Quantity FROM orders
JOIN customers USING(customerID) 
JOIN order_details USING(OrderID) 
JOIN products USING(productID)WHERE CustomerName LIKE 'Ernst%' ORDER BY customerID;
/*CHECKING for OrderID 10258 if quantity is the same as the above code.*/
SELECT OrderID,ProductName,ProductID,Unit,Quantity,Price,(Price*Quantity) AS TotalPrice FROM order_details
JOIN products USING(productID) WHERE orderID = 10258 GROUP BY ProductID ORDER BY ProductID;

-- Count of customers who didn't ordered anything
/* Using Left Join will return all data from Customers table 
and to know if their values in Orders table are null.*/
-- NOTE: Left table is Customers and right table is Orders
SELECT COUNT(*) AS CustomersWithoutOrders
FROM Customers
LEFT JOIN ORDERS USING(CustomerID)
WHERE Orders.OrderID IS NULL;

-- List of customers who didn't ordered anything
/* Using Left Join will return all data 
from Customers table and to know if their values in Orders table are null.*/
-- NOTE: Left table is Customers and right table is Orders.
SELECT *
FROM Customers
LEFT JOIN ORDERS USING(CustomerID)
WHERE Orders.OrderID IS NULL;
/*You can also use WHERE NOT EXISTS*/
SELECT *
FROM Customers WHERE NOT EXISTS
(SELECT * FROM Orders WHERE orders.customerID = customers.customerID);

-- There are 196 customers who bought something.
SELECT COUNT(*) AS CusWithoutOrders FROM orders
RIGHT JOIN customers USING(customerID) WHERE 
OrderID IS NOT NULL;


-- YEAR
SELECT YEAR(OrderDate) AS Years, COUNT(DISTINCT OrderID) FROM orders GROUP BY Years;

-- Use Distinct orderID to remove repeated orderID, the reason for repeated orderID  is
-- because of more than 1 products in one orderID
-- it shows that the data in 1996, it has greater transactions than in 1997.
SELECT YEAR(OrderDate) AS Years,COUNT(DISTINCT OrderID) AS NumberOfTransactions FROM orders
JOIN order_details USING(orderID)
JOIN products USING(productID)
JOIN customers USING(customerID)
GROUP BY Years;

SELECT YEAR(OrderDate) AS Years,COUNT(DISTINCT OrderID) AS NumberOfTransactions, 
ROUND(SUM(price*quantity),2) AS Sales FROM orders
JOIN order_details USING
(orderID)
JOIN products USING(productID)
JOIN customers USING(customerID)
GROUP BY Years;
-- Month
SELECT YEAR(OrderDate) AS Years,MONTHNAME(OrderDate) AS Months, COUNT(DISTINCT OrderID) AS NumberOfTransactions, 
ROUND(SUM(price*quantity),2) AS Sales FROM orders
JOIN order_details USING
(orderID)
JOIN products USING(productID)
JOIN customers USING(customerID)
GROUP BY Months ORDER BY Years ASC, MONTH(STR_TO_DATE(Months, '%M')) ASC;

-- Biggest product sale of the year
SELECT YEAR(OrderDate) AS Years, ProductID, ProductName,
ROUND(SUM(price*quantity),2) AS Sales, SUM(quantity) AS TotalQuantity, price FROM orders
JOIN order_details USING
(orderID)
JOIN products USING(productID)
JOIN customers USING(customerID) 
GROUP BY Years,ProductID ORDER BY Sales DESC LIMIT 2;

-- Biggest sales product per moth
-- MONTH(STR_TO_DATE(months, '%M')) To make chronological order instead of alphabetical order(April,August,December,Feb)
-- Use subquery, joins and group by to make this possible
-- NOTE: You can't do this MAX(SUM(()). inner querry for SUM() then outer querry for MAX()
-- outer table queries on the inner table to select and MAX the SumofSales(inside the q2) then they were group by months to see 
-- the highest product sales per month
SELECT q2.Years,q2.Months,q2.ProductID,q2.ProductName,MAX(q2.Sales) AS SalesByMonth FROM(
SELECT YEAR(OrderDate) AS Years, MONTHNAME(OrderDate) AS Months, ProductID,ProductName,
ROUND(SUM(price*quantity),2) AS Sales FROM orders 
JOIN order_details  USING
(orderID) 
JOIN products USING(productID)
JOIN customers USING(customerID)
GROUP BY Months,ProductID ORDER BY Years ASC, MONTH(STR_TO_DATE(Months, '%M')) ASC,Sales DESC) AS q2 
GROUP BY Months;

-- Sales of all products each month
SELECT YEAR(OrderDate) AS Years, MONTHNAME(OrderDate) AS Months, ProductID,ProductName,
ROUND(SUM(price*quantity),2) AS Sales FROM orders 
JOIN order_details  USING
(orderID) 
JOIN products USING(productID)
JOIN customers USING(customerID)
GROUP BY Months,ProductID ORDER BY Years ASC, MONTH(STR_TO_DATE(Months, '%M')) ASC,Sales DESC;

-- Supplier of the month by sales
SELECT q2.Years,q2.Months,q2.SupplierID,q2.SupplierName,q2.ProductID,q2.ProductName,MAX(q2.Sales) AS SalesByMonth FROM(
SELECT YEAR(OrderDate) AS Years, MONTHNAME(OrderDate) AS Months, ProductID,ProductName, e.SupplierName,e.SupplierID,
ROUND(SUM(price*quantity),2) AS Sales FROM orders 
JOIN order_details  USING
(orderID) 
JOIN products USING(productID)
JOIN suppliers e USING(supplierID) 
GROUP BY Months,e.SupplierID ORDER BY Years ASC, MONTH(STR_TO_DATE(Months, '%M')) ASC,Sales DESC) AS q2 
GROUP BY Months;
/*BELOW CODE IS FOR CHECKING IF Pavlova, Ltd. has the total sales of 11450.45 for the month of October 1996. 
Sum all the Sales from the output below.
 If Pavlova, Ltd total sales is the same with above and below code, the supplier of the month code is correct.*/
SELECT q2.orderdate, q2.years,q2.months, q2.SupplierID, q2.SupplierName, q2.Sales FROM
(SELECT orderdate, YEAR(OrderDate) AS Years, MONTHNAME(OrderDate) AS Months, SupplierName,SupplierID, SUM(Price*Quantity) AS Sales, 
ProductID, ProductName From Orders
JOIN order_details USING(orderID)
JOIN products  USING(productID) 
JOIN suppliers USING(SupplierID) GROUP BY SupplierID, orderdate ORDER BY Years ASC, MONTH(STR_TO_DATE(Months, '%M')) ASC,Sales DESC) q2
WHERE SupplierID = 7 AND q2.years = 1996 AND Months = 'October';

-- Total number of customers per country
SELECT Country, COUNT(*) AS NumberOfCustomers 
FROM customers 
GROUP BY Country ORDER BY NumberOfCustomers DESC;
-- Total number of customers per country and city
SELECT Country, City, COUNT(*) AS NumberOfCustomers 
FROM customers 
GROUP BY Country, City ORDER BY NumberOfCustomers DESC,Country,City;
-- Total number supplers per country
SELECT Country, COUNT(*) AS NumberOfSuppliers 
FROM Suppliers
GROUP BY Country ORDER BY NumberOfSuppliers DESC;
-- List of suppliers per country
SELECT Country,SupplierName
FROM Suppliers
GROUP BY Country,SupplierName ORDER BY Country DESC;
-- Category
-- Number of products by category
SELECT c.CategoryID,c.CategoryName,COUNT(*) AS NumberOfProducts,c.Description FROM products
JOIN categories c USING(categoryID)
GROUP BY CategoryID ORDER BY NumberOfProducts DESC;
-- Total Sales by category
SELECT c.CategoryID, c.CategoryName,c.Description, ROUND(SUM(p.price*od.quantity),2) AS TotalSales FROM orders
JOIN order_details od USING(orderID)
JOIN products p USING(productID)
JOIN categories c USING(categoryID)
GROUP BY categoryID ORDER BY TotalSales DESC;

-- Categories which their total sales are greater than the average of total sales of all categories in this dataset.
SELECT q2.categoryID,q2.CategoryName,q2.TotalSales,q4.AVGTotalSales FROM
(SELECT c.CategoryID, c.CategoryName,c.Description, ROUND(SUM(p.price*od.quantity),2) AS TotalSales FROM orders
JOIN order_details od USING(orderID)
JOIN products p USING(productID)
JOIN categories c USING(categoryID)
GROUP BY categoryID)q2
JOIN
(SELECT ROUND(AVG(q3.TotalSales)) AS AVGTotalSales FROM (SELECT categoryID ,CategoryName,categories.Description, 
ROUND(SUM(price*quantity),2) AS TotalSales
FROM orders
JOIN order_details USING(orderID)
JOIN products USING(productID)
JOIN categories USING(categoryID)
GROUP BY categoryID)q3)q4 ON q2.TotalSales > AVGTotalSales;

-- Categories which their total sales are less than the average of total sales of all categories in this dataset.
SELECT q2.categoryID,q2.CategoryName,q2.TotalSales,q4.AVGTotalSales FROM
(SELECT c.CategoryID, c.CategoryName,c.Description, ROUND(SUM(p.price*od.quantity),2) AS TotalSales FROM orders
JOIN order_details od USING(orderID)
JOIN products p USING(productID)
JOIN categories c USING(categoryID)
GROUP BY categoryID)q2
JOIN
(SELECT ROUND(AVG(q3.TotalSales)) AS AVGTotalSales FROM (SELECT categoryID ,CategoryName,categories.Description, 
ROUND(SUM(price*quantity),2) AS TotalSales
FROM orders
JOIN order_details USING(orderID)
JOIN products USING(productID)
JOIN categories USING(categoryID)
GROUP BY categoryID)q3)q4 ON q2.TotalSales < AVGTotalSales;


-- Total Sales of Products that are greater than the average of total sales of products or all products sales combined.
-- Joining subqueries
SELECT q2.ProductID,q2.ProductName, q2.TotalSales, ROUND(q4.AVGSALES,2) AS AverageOfTotalSales FROM
(SELECT ProductID,ProductName, ROUND(SUM(quantity*Price),2) AS TotalSales FROM orders
JOIN order_details USING(orderID)
JOIN products USING(productID)
GROUP BY ProductID) q2 
JOIN
(SELECT AVG(q3.TotalSales) AS AVGSales FROM (SELECT ProductID,ProductName, ROUND(SUM(quantity*Price),2) AS TotalSales FROM orders
JOIN order_details USING(orderID)
JOIN products USING(productID)
GROUP BY ProductID)q3) q4 ON q2.TotalSales> q4.AVGSales ORDER BY q2.TotalSales DESC;

-- Total Sales of Products that are less than the average of total sales of products or all products sales combined.
SELECT q2.ProductID,q2.ProductName, q2.TotalSales, ROUND(q4.AVGSALES,2) AS AverageOfTotalSales FROM
(SELECT ProductID,ProductName, ROUND(SUM(quantity*Price),2) AS TotalSales FROM orders
JOIN order_details USING(orderID)
JOIN products USING(productID)
GROUP BY ProductID) q2 
JOIN
(SELECT AVG(q3.TotalSales) AS AVGSales FROM (SELECT ProductID,ProductName, ROUND(SUM(quantity*Price),2) AS TotalSales FROM orders
JOIN order_details USING(orderID)
JOIN products USING(productID)
GROUP BY ProductID)q3) q4 ON q2.TotalSales < q4.AVGSales ORDER BY q2.TotalSales ASC;


-- Number of transactions made by Employees excluding repeated orderID
SELECT EmployeeID, CONCAT(FirstName,' ',LastName) AS FullName ,COUNT(OrderID) AS NumberOfTransactionsMade FROM employees
JOIN orders USING(employeeID) GROUP BY EmployeeID ORDER BY NumberOfTransactionsMade DESC;

-- Best Employee by total money from their transaction
SELECT q2.EmployeeID,q2.FullName,ROUND(SUM(q2.MoneyMakes),2) AS TotalMoney FROM
(SELECT OrderID,EmployeeID,productName, CONCAT(FirstName,' ',LastName) AS FullName, price,quantity, SUM(price*quantity) AS MoneyMakes FROM employees
JOIN orders USING(employeeID) 
JOIN order_details USING(OrderID)
JOIN products USING(productID)
GROUP BY ORDERId,EmployeeID) q2 GROUP BY EmployeeID ORDER BY TotalMoney DESC;

-- Categories which their total sales are greater than the average of total sales of all categories in this dataset.
SELECT q2.categoryID,q2.CategoryName,q2.TotalSales,q4.AVGTotalSales FROM
(SELECT c.CategoryID, c.CategoryName,c.Description, ROUND(SUM(p.price*od.quantity),2) AS TotalSales FROM orders
JOIN order_details od USING(orderID)
JOIN products p USING(productID)
JOIN categories c USING(categoryID)
GROUP BY categoryID)q2
JOIN
(SELECT ROUND(AVG(q3.TotalSales)) AS AVGTotalSales FROM (SELECT categoryID ,CategoryName,categories.Description, 
ROUND(SUM(price*quantity),2) AS TotalSales
FROM orders
JOIN order_details USING(orderID)
JOIN products USING(productID)
JOIN categories USING(categoryID)
GROUP BY categoryID)q3)q4 ON q2.TotalSales > AVGTotalSales;

-- Categories which their total sales are less than the average of total sales of all categories in this dataset.
SELECT q2.categoryID,q2.CategoryName,q2.TotalSales,q4.AVGTotalSales FROM
(SELECT c.CategoryID, c.CategoryName,c.Description, ROUND(SUM(p.price*od.quantity),2) AS TotalSales FROM orders
JOIN order_details od USING(orderID)
JOIN products p USING(productID)
JOIN categories c USING(categoryID)
GROUP BY categoryID)q2
JOIN
(SELECT ROUND(AVG(q3.TotalSales)) AS AVGTotalSales FROM (SELECT categoryID ,CategoryName,categories.Description, 
ROUND(SUM(price*quantity),2) AS TotalSales
FROM orders
JOIN order_details USING(orderID)
JOIN products USING(productID)
JOIN categories USING(categoryID)
GROUP BY categoryID)q3)q4 ON q2.TotalSales < AVGTotalSales;

-- USING UNION for CATEGORIES then shows totalsales > avg total sales and total sales < avg total sales

SELECT * FROM
(SELECT q2.categoryID,q2.CategoryName,q2.TotalSales,q4.AVGTotalSales FROM
(SELECT c.CategoryID, c.CategoryName,c.Description, ROUND(SUM(p.price*od.quantity),2) AS TotalSales FROM orders
JOIN order_details od USING(orderID)
JOIN products p USING(productID)
JOIN categories c USING(categoryID)
GROUP BY categoryID)q2
JOIN
(SELECT ROUND(AVG(q3.TotalSales)) AS AVGTotalSales FROM (SELECT categoryID ,CategoryName,categories.Description, 
ROUND(SUM(price*quantity),2) AS TotalSales
FROM orders
JOIN order_details USING(orderID)
JOIN products USING(productID)
JOIN categories USING(categoryID)
GROUP BY categoryID)q3)q4 ON q2.TotalSales > AVGTotalSales) q5
UNION
(SELECT q2.categoryID,q2.CategoryName,q2.TotalSales,q4.AVGTotalSales FROM
(SELECT c.CategoryID, c.CategoryName,c.Description, ROUND(SUM(p.price*od.quantity),2) AS TotalSales FROM orders
JOIN order_details od USING(orderID)
JOIN products p USING(productID)
JOIN categories c USING(categoryID)
GROUP BY categoryID)q2
JOIN
(SELECT ROUND(AVG(q3.TotalSales)) AS AVGTotalSales FROM (SELECT categoryID ,CategoryName,categories.Description, 
ROUND(SUM(price*quantity),2) AS TotalSales
FROM orders
JOIN order_details USING(orderID)
JOIN products USING(productID)
JOIN categories USING(categoryID)
GROUP BY categoryID)q3)q4 ON q2.TotalSales < AVGTotalSales) ORDER BY TotalSales DESC;

-- USING UNION for PRDDUCTS then shows totalsales > avg total sales and total sales < avg total sales

SELECT * FROM
(SELECT q2.ProductID,q2.ProductName, q2.TotalSales, ROUND(q4.AVGSALES,2) AS AverageOfTotalSales FROM
(SELECT ProductID,ProductName, ROUND(SUM(quantity*Price),2) AS TotalSales FROM orders
JOIN order_details USING(orderID)
JOIN products USING(productID)
GROUP BY ProductID) q2 
JOIN
(SELECT AVG(q3.TotalSales) AS AVGSales FROM (SELECT ProductID,ProductName, ROUND(SUM(quantity*Price),2) AS TotalSales FROM orders
JOIN order_details USING(orderID)
JOIN products USING(productID)
GROUP BY ProductID)q3) q4 ON q2.TotalSales> q4.AVGSales ORDER BY q2.TotalSales DESC) q5
UNION
(SELECT q2.ProductID,q2.ProductName, q2.TotalSales, ROUND(q4.AVGSALES,2) AS AverageOfTotalSales FROM
(SELECT ProductID,ProductName, ROUND(SUM(quantity*Price),2) AS TotalSales FROM orders
JOIN order_details USING(orderID)
JOIN products USING(productID)
GROUP BY ProductID) q2 
JOIN
(SELECT AVG(q3.TotalSales) AS AVGSales FROM (SELECT ProductID,ProductName, ROUND(SUM(quantity*Price),2) AS TotalSales FROM orders
JOIN order_details USING(orderID)
JOIN products USING(productID)
GROUP BY ProductID)q3) q4 ON q2.TotalSales < q4.AVGSales ORDER BY q2.TotalSales ASC) ORDER BY TotalSales DESC;
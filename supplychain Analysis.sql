use [SupplyChain_p]

--Sales Order Analysis:

--What is the total number of orders?
SELECT COUNT(*) AS TotalSalesOrders
FROM [dbo].[salesOrder];

--How many unique channels are there?
SELECT DISTINCT [Channel]
FROM [dbo].[salesOrder];

--What is the average order quantity?
SELECT AVG([Order_Quantity]) AS "Average of order quantity"
FROM [dbo].[salesOrder];

--Find the total revenue generated from all the sales orders.
SELECT SUM([Order_Quantity] * [Unit_Price]) AS "Total Revenue"
FROM [dbo].[salesOrder];

--Which warehouse has the highest number of orders?
SELECT top 1 so.[Warehouse_Index] , w.[Warehouse_Code] , count(so.[OrderNumber]) AS "Number_of_Orders"
FROM [dbo].[salesOrder] so join [dbo].[warehouse] w 
     on so.[Warehouse_Index] = w.[Warehouse_Index]
GROUP BY so.[Warehouse_Index] ,w.[Warehouse_Code]
ORDER BY Number_of_Orders DESC ;
 
--What is the total cost for each product?
SELECT so.[Product_Index] , p.[Product_Name] , 
       SUM(so.[Unit_Cost] * so.[Order_Quantity]) AS "Total_Cost"
FROM [dbo].[salesOrder] so join [dbo].[products] p
     on so.[Product_Index] = p.[Index]
GROUP BY so.[Product_Index] , p.[Product_Name]
ORDER BY Total_Cost DESC;

--Calculate the profit margin for each product.

SELECT p.[Index] , p.[Product_Name] , 
((SUM(so.[Unit_Price]*so.[Order_Quantity])-
SUM(so.[Unit_Cost]*so.[Order_Quantity]))/
(SUM(so.[Unit_Price]*so.[Order_Quantity])))*100

FROM [dbo].[salesOrder] so join [dbo].[products] p
     on so.[Product_Index] = p.[Index]
GROUP BY p.[Index] , p.[Product_Name];

--Identify the top 5 customers with the highest order quantity.
SELECT top 5 so.[Customer_Index] , c.[Customer_Names] ,sum(so.[Order_Quantity]) AS "Total_order_qty" 
FROM [dbo].[salesOrder] so join [dbo].[customers] c
     on so.[Customer_Index] = c.[Customer_Index]
GROUP BY so.[Customer_Index] ,c.[Customer_Names]
ORDER BY Total_order_qty DESC;

--What is the average unit price for each channel?
SELECT [Channel] , AVG([Unit_Price]) AS "Avg_unit_price"
FROM [dbo].[salesOrder]
GROUP BY [Channel]
ORDER BY Avg_unit_price;

--Find the total sales orders for each region.
SELECT so.[Region_Index],r.[City] ,r.[Country] ,
       COUNT(so.[OrderNumber]) AS "Total_orders"
FROM [dbo].[salesOrder] so join [dbo].[region] r
     on so.[Region_Index] = r.[Index]
GROUP BY so.[Region_Index],r.[City] ,r.[Country];

--Warehouse Analysis:

SELECT * FROM [dbo].[warehouse]

--Remove null values
DELETE FROM [dbo].[warehouse]
WHERE [Warehouse_Index]  IS NULL;

--How many warehouses are there in each country?
SELECT [Country] , COUNT(*) AS "Number_of_warehouse"
FROM [dbo].[warehouse]
GROUP BY [Country];

--List the warehouses in a specific city.
SELECT [Warehouse_Code],[Country] ,[City], COUNT(*) AS "Number_of_warehouse"
FROM [dbo].[warehouse]
GROUP BY [Country] ,[City] ,[Warehouse_Code]
 
--Calculate the average latitude and longitude for all warehouses.
SELECT AVG([Latitude]) AS "AVERAGE_OF_Latitude" , 
       AVG([Longitude]) AS "AVERAGE_OF_Longitude"
FROM [dbo].[warehouse]

--Find the warehouse with the highest number of orders.
SELECT w.[Warehouse_Index] , w.[Warehouse_Code] ,
       COUNT(so.[OrderNumber]) AS "Number_of_orders"
from [dbo].[salesOrder] so join [dbo].[warehouse] w
     on so.[Warehouse_Index] = w.[Warehouse_Index]
GROUP BY w.[Warehouse_Index] , w.[Warehouse_Code];

--Identify the warehouse with the lowest latitude.
SELECT TOP 1 *
FROM [dbo].[warehouse]
ORDER BY [Latitude] ASC;

--Count the number of warehouses in each province.
SELECT [Province] , COUNT([Warehouse_Index]) AS "Number_of_warehouse"
FROM [dbo].[warehouse]
GROUP BY [Province]

--Calculate the average unit cost for each warehouse.
SELECT w.[Warehouse_Index] , w.[Warehouse_Code] , 
       AVG(so.[Unit_Cost]) AS "AVERAGE_UNIT_COST"
FROM [dbo].[salesOrder] so join [dbo].[warehouse] w
     on so.[Warehouse_Index] = w.[Warehouse_Index]
GROUP BY w.[Warehouse_Index] , w.[Warehouse_Code]

--Identify the warehouse with the highest profit margin.
SELECT w.[Warehouse_Index] ,  w.[Full_Name],
((SUM(so.[Unit_Price]*so.[Order_Quantity])-
SUM(so.[Unit_Cost]*so.[Order_Quantity]))/
(SUM(so.[Unit_Price]*so.[Order_Quantity])))*100 AS "P_MARGIN"

FROM [dbo].[salesOrder] so JOIN  [dbo].[warehouse] w
     on so.[Product_Index] = w.[Warehouse_Index]
GROUP BY w.[Warehouse_Index] ,  w.[Full_Name]
ORDER BY P_MARGIN DESC;

--What is the total unit cost for all warehouses in a specific country?
SELECT w.[Warehouse_Index] , w.[Warehouse_Code] , 
       w.[Country], SUM([Unit_Cost]) AS "Total_of_unit_cost"
FROM [dbo].[salesOrder] so join [dbo].[warehouse] w
     on so.[Warehouse_Index] = w.[Warehouse_Index]
GROUP BY w.[Warehouse_Index] , w.[Warehouse_Code] ,w.[Country];

--Customer Analysis:

SELECT * FROM [dbo].[customers];

--Remove null values
DELETE FROM [dbo].[customers]
WHERE  [Customer_Index] IS NULL;

--Count the number of customers.
SELECT COUNT(*) AS "Numbre_of_customers"
FROM [dbo].[customers];

--Identify the top 10 customers with the highest total order quantity.
SELECT TOP 10 sum(so.[Order_Quantity]) AS "Total_number_order_quantity" , count(so.[OrderNumber]) AS "Number_of_orders" , c.[Customer_Names] 
from [dbo].[customers] c join [dbo].[salesOrder] so
     on c.[Customer_Index] = so.[Customer_Index]
GROUP BY c.[Customer_Names];

--Calculate the average order quantity for each customer.
SELECT c.[Customer_Names] ,
       AVG(so.[Order_Quantity]) AS "Average_of_order_quantity"
from [dbo].[customers] c join [dbo].[salesOrder] so
     on c.[Customer_Index] = so.[Customer_Index]
GROUP BY c.[Customer_Names];
 
--List customers who have not placed any orders.
SELECT c.[Customer_Index] ,c.[Customer_Names]
from [dbo].[customers] c  LEFT join [dbo].[salesOrder] so
     on c.[Customer_Index] = so.[Customer_Index]
WHERE c.[Customer_Index] IS NULL ;

--Calculate the total revenue generated by each customer.
SELECT c.[Customer_Index] ,c.[Customer_Names] , 
       SUM(so.[Unit_Price] * so.[Order_Quantity]) AS "Total_revenue"
from [dbo].[customers] c join [dbo].[salesOrder] so
     on c.[Customer_Index] = so.[Customer_Index]
GROUP BY c.[Customer_Index] ,c.[Customer_Names]; 	 

--Number of customers who have placed orders in a specific city.
SELECT  r.[City] , COUNT(so.[Customer_Index]) AS "Number_of_customer"
FROM [dbo].[salesOrder] so join [dbo].[region] r
     on so.[Region_Index] = r.[Index] 
GROUP BY r.[City];

--Calculate the average profit margin for each customer.
SELECT so.[Customer_Index] ,c.[Customer_Names],
((SUM(so.[Unit_Price]*so.[Order_Quantity])-
SUM(so.[Unit_Cost]*so.[Order_Quantity]))/
(SUM(so.[Unit_Price]*so.[Order_Quantity])))*100 AS "P.MARGIN"
FROM [dbo].[salesOrder] so join [dbo].[customers] c
     on so.[Customer_Index] = c.[Customer_Index]
GROUP BY so.[Customer_Index] ,c.[Customer_Names];



--Region Analysis:

SELECT * FROM [dbo].[region]

--Remove null values
DELETE FROM [dbo].[region]
WHERE [Index]  IS NULL;

--Count the number of cities in each province.
SELECT [Province] , COUNT([City]) AS "Number_of_cities"
FROM [dbo].[region]
GROUP BY [Province];

--Identify the regions with the highest and lowest latitude.
SELECT MAX([Latitude]) AS MaxLatitude, 
       MIN([Latitude]) AS MinLatitude,
	   MAX([Longitude]) AS MaxLongitude, 
	   MIN([Longitude]) AS MinLongitude
FROM [dbo].[region];

--Calculate the total revenue generated in each region.
SELECT r.[Index] , r.[Full_Name], 
       SUM(so.[Unit_Price]*so.[Order_Quantity]) AS "Total_revenue"
FROM [dbo].[salesOrder] so join [dbo].[region] r
     on so.[Region_Index] = r.[Index]
GROUP BY r.[Index] , r.[Full_Name];

--List the regions in a specific province.
SELECT [Province] , [Full_Name] 
FROM [dbo].[region]
GROUP BY [Province],[Full_Name];

--Find the region with the highest number of orders.
SELECT TOP 1 [Index] , [Full_Name] , COUNT(so.[OrderNumber]) AS "Number_of_orders"
FROM [dbo].[salesOrder] so join [dbo].[region] r
     on so.[Region_Index] = r.[Index]
GROUP BY [Index] , [Full_Name] 
ORDER BY Number_of_orders DESC;

--Calculate the average longitude for each province.
SELECT [Province] , AVG([Longitude]) AS "Average_longitude"
FROM [dbo].[region]
GROUP BY [Province];

--Count the number of regions in each province.
SELECT [Province] , COUNT([Index]) AS "Number_of_regions"
FROM [dbo].[region]
GROUP BY [Province];

--Calculate the average unit price for each region.
SELECT r.[Index] , r.[Full_Name] , AVG(so.[Unit_Price]) AS "Average_of_unit_price"
FROM [dbo].[salesOrder] so join [dbo].[region] r
     on so.[Region_Index] = r.[Index]
GROUP BY [Index] , [Full_Name] ;

--Product Analysis:

SELECT * FROM [dbo].[products]

--Remove null values
DELETE FROM [dbo].[products]
WHERE [Index] IS NULL;

--Count the number of unique products.
SELECT COUNT(DISTINCT [Index] ) AS "Number_of_unique_products"
FROM [dbo].[products];

--Identify the top 5 products with the highest order quantity.
SELECT TOP 5 [Index] ,[Product_Name] , 
       SUM([Order_Quantity]) AS "Number_of_order_qty"
FROM [dbo].[salesOrder] so join [dbo].[products] p
     on so.[Product_Index] = p.[Index]
GROUP BY [Index] ,[Product_Name];

--Calculate the total revenue generated by each product.
SELECT p.[Index] , p.[Product_Name], 
       SUM(so.[Unit_Price]*so.[Order_Quantity]) AS "Total_revenue"
FROM [dbo].[salesOrder] so join [dbo].[products] p
     on so.[Product_Index] = p.[Index]
GROUP BY [Index] ,[Product_Name];

--List products that have not been ordered.
SELECT so.* , p.*
FROM [dbo].[salesOrder] so FULL OUTER join [dbo].[products] p
     on so.[Product_Index] = p.[Index]
WHERE so.[Product_Index] IS NULL;

--Calculate the average order quantity for each product.
SELECT p.[Index] , p.[Product_Name] , 
       AVG(so.[Order_Quantity]) AS "Average_order_qty"
FROM [dbo].[salesOrder] so join [dbo].[products] p
     on so.[Product_Index] = p.[Index]
GROUP BY p.[Index] , p.[Product_Name];


--Date Analysis:

--Extract the year from the order date and calculate the total revenue for each year.
SELECT YEAR([OrderDate]) AS "Order_Year", SUM([Unit_Price]*[Order_Quantity]) AS "Total_revenue"
FROM [dbo].[salesOrder]
GROUP BY YEAR([OrderDate])


--Calculate the difference in days between the order date and delivery date.
SELECT [OrderDate],[Delivery_Date], 
       DATEDIFF(DAY,[OrderDate],[Delivery_Date]) AS "Number_of_days"
FROM [dbo].[salesOrder]

--Maximum and Minmum number of days for delivering order
SELECT
       MIN(DATEDIFF(DAY,[OrderDate],[Delivery_Date])
	   )AS "MIN_Number_of_days"
FROM [dbo].[salesOrder]

SELECT
       MAX(DATEDIFF(DAY,[OrderDate],[Delivery_Date])
	   )AS "MAX_Number_of_days"
FROM [dbo].[salesOrder]

--Find the average order quantity for orders placed in the last six months.
SELECT AVG([Order_Quantity]) AS "Avg_Order_Quantity"
FROM [dbo].[salesOrder]
WHERE [OrderDate] >= DATEADD(MONTH, -6, GETDATE());


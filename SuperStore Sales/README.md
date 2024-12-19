Data Cleaning and Analysis Project: Sample Superstore Dataset
Dataset
Dataset Name: Sample Superstore Dataset
Source: Kaggle - Sample Supermarket Dataset
Queried using: MS SQL Server
🚀 Project Overview
In this project, I cleaned and analyzed data from the Sample Superstore dataset using SQL. The primary goal was to clean and structure the data, apply constraints, and create relevant queries for business insights. The analysis includes sales performance, profitability by sub-categories, and insights into shipping modes and product categories.

🧹 Data Cleaning Steps
Applied NOT NULL Constraints:

Ensured the ORDERID in both ORDERS and SALES tables are NOT NULL to maintain data integrity.
sql
Copiază codul
ALTER TABLE ORDERS ALTER COLUMN ORDERID INT NOT NULL;
ALTER TABLE SALES ALTER COLUMN ORDERID INT NOT NULL;
Created Primary Key (PK) and Foreign Key (FK):

Set ORDERID as the primary key in the ORDERS table.
Established a foreign key relationship between SALES and ORDERS tables.
sql
Copiază codul
ALTER TABLE ORDERS ADD CONSTRAINT PK_ORDERID PRIMARY KEY(ORDERID);
ALTER TABLE SALES ADD CONSTRAINT FK_ORDERID FOREIGN KEY (ORDERID) REFERENCES ORDERS(ORDERID);
Modified Data Types:

Adjusted the data types for columns in the SALES table (e.g., converting SALES, PROFIT, and DISCOUNT to FLOAT).
sql
Copiază codul
ALTER TABLE SALES ALTER COLUMN SALES FLOAT NOT NULL;
ALTER TABLE SALES ALTER COLUMN PROFIT FLOAT NOT NULL;
ALTER TABLE SALES ALTER COLUMN DISCOUNT FLOAT NOT NULL;
🔍 Analysis and Queries
1. Top Product Sub-Categories by Total Sales and Lowest Profit
This query identifies which product sub-categories have the highest total sales and the lowest total profit.
sql
Copiază codul
SELECT [Sub-Category], ROUND(SUM(SALES),2) AS TOTAL_SALES, ROUND(SUM(PROFIT),2) AS TOTAL_PROFIT
FROM SALES
GROUP BY [Sub-Category]
ORDER BY TOTAL_SALES DESC, TOTAL_PROFIT ASC;
2. Ship Mode Analysis
This query analyzes which shipping modes are associated with the highest number of orders and their impact on total profit.
sql
Copiază codul
SELECT Orders.[Ship Mode], COUNT(ORDERS.ORDERID) AS TOTAL_ORDERS, ROUND(SUM(PROFIT),2) AS TOTAL_PROFIT
FROM Orders
INNER JOIN SALES ON Orders.OrderID = SALES.OrderID
GROUP BY [Ship Mode]
ORDER BY TOTAL_ORDERS DESC;
3. Most Profitable Sub-Categories by Region
This query calculates the profitability of product sub-categories in each region based on the ratio of profit to sales.
sql
Copiază codul
SELECT SALES.[Sub-Category],
       REGION,
       ROUND(ROUND(SUM(PROFIT),2) / ROUND(SUM(SALES),2),4) * 100 AS PROFITABILITY
FROM SALES
INNER JOIN Orders ON SALES.OrderID = Orders.OrderID
GROUP BY [Sub-Category], REGION
ORDER BY PROFITABILITY DESC;
4. Product Category Rank by Sales in Each Region
This query ranks product categories based on total sales within each region.
sql
Copiază codul
SELECT REGION,
       Category,
       ROUND(SUM(SALES),2) AS TOTAL_SALES,
       RANK() OVER (PARTITION BY REGION ORDER BY ROUND(SUM(SALES),2)) AS CATEGORY_RANK
FROM Orders
INNER JOIN SALES ON Orders.OrderID = SALES.OrderID
GROUP BY REGION, Category;
5. Total Discount per Category by Region
This query calculates the total discount amount for each product category per region, ranking categories based on the largest discount.
sql
Copiază codul
WITH CTE_DISCOUNT AS (
  SELECT REGION,
         CATEGORY,
         ROUND(SUM(DISCOUNT),2) AS TOTAL_DISCOUNT
  FROM Orders
  INNER JOIN SALES ON Orders.OrderID = Sales.OrderID
  GROUP BY REGION, CATEGORY
)
SELECT REGION,
       CATEGORY,
       TOTAL_DISCOUNT,
       RANK() OVER(PARTITION BY REGION ORDER BY TOTAL_DISCOUNT DESC) AS DISCOUNT_RANK
FROM CTE_DISCOUNT
ORDER BY REGION, DISCOUNT_RANK;
🔑 Key Learnings
Learned how to manage constraints (PK, FK) and data types to ensure data integrity.
Gained experience in writing complex SQL queries for business analysis, including ranking, profitability analysis, and identifying trends.
Developed an understanding of how shipping methods and product categories impact sales and profitability.
📂 Project Files
SQL Scripts: All SQL queries are stored in this repository.
Database Schema: Details about tables, relationships, and constraints.

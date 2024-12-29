--Dataset: Sample Superstore Dataset
-- Source: https://www.kaggle.com/datasets/bravehart101/sample-supermarket-dataset
-- Queried using: MS SQL


/* Applied a NOT NULL constraint on the tabels to create the PK and FK */
ALTER TABLE ORDERS
ALTER COLUMN ORDERID INT NOT NULL

ALTER TABLE SALES
ALTER COLUMN ORDERID INT NOT NULL

/* Created the PK */
ALTER TABLE ORDERS
ADD CONSTRAINT PK_ORDERID PRIMARY KEY(ORDERID)

/* Created the FK and the reference to PK */
ALTER TABLE SALES
ADD CONSTRAINT FK_ORDERID
FOREIGN KEY (ORDERID) REFERENCES ORDERS(ORDERID)


--MODIFIED THE DATA TYPES 

ALTER TABLE SALES
ALTER COLUMN SALES FLOAT NOT NULL

ALTER TABLE SALES
ALTER COLUMN PROFIT FLOAT NOT NULL

ALTER TABLE SALES
ALTER COLUMN DISCOUNT FLOAT NOT NULL



--Which product sub-categories have the highest total sales and the lowest total profit?

SELECT [Sub-Category], ROUND(SUM(SALES),2) AS TOTAL_SALES, ROUND(SUM(PROFIT),2) AS TOTAL_PROFIT
FROM SALES
GROUP BY [Sub-Category]
ORDER BY TOTAL_SALES DESC,TOTAL_PROFIT ASC


--Which ship modes are associated with the highest number of orders, and how do they impact total profit?

SELECT Orders.[Ship Mode], COUNT(ORDERS.ORDERID) AS TOTAL_ORDERS, ROUND(SUM(PROFIT),2) AS TOTAL_PROFIT
FROM Orders
INNER JOIN SALES
ON Orders.OrderID = SALES.OrderID
GROUP BY [Ship Mode]
ORDER BY TOTAL_ORDERS DESC


--Which sub-categories are the most profitable in each region?


SELECT SALES.[Sub-Category],
			REGION,
			ROUND(ROUND(SUM(PROFIT),2) / ROUND(SUM(SALES),2),4) * 100  AS PROFITABILITY
FROM SALES
INNER JOIN Orders
ON SALES.OrderID = Orders.OrderID
GROUP BY [Sub-Category], REGION
ORDER BY PROFITABILITY DESC

--For each region, determine the rank of each product category based on total sales within that region.

SELECT REGION,
		Category,
		ROUND(SUM(SALES),2) AS TOTAL_SALES,
		RANK() OVER (PARTITION BY REGION ORDER BY ROUND(SUM(SALES),2)) AS CATEGORY_RANK
	FROM Orders
	INNER JOIN SALES
	ON Orders.OrderID = SALES.OrderID
	GROUP BY REGION, Category
	

	--For each region, determine the product category with the largest total discount, and display the total discount amount

	
	WITH CTE_DISCOUNT AS(
	SELECT
		REGION,
		CATEGORY,
		ROUND(SUM(DISCOUNT),2) AS TOTAL_DISCOUNT
		FROM Orders
		INNER JOIN SALES
		ON Orders.OrderID = Sales.OrderID
		GROUP BY REGION, CATEGORY
		)


		SELECT REGION,
				CATEGORY,
				TOTAL_DISCOUNT,
				RANK() OVER(PARTITION BY REGION ORDER BY TOTAL_DISCOUNT DESC) AS DISCOUNT_RANK
		FROM CTE_DISCOUNT
		ORDER BY REGION, DISCOUNT_RANK

			

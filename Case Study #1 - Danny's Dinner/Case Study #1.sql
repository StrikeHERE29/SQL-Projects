
SELECT *
FROM DANNYS_DINER.MENU

SELECT * 
FROM DANNYS_DINER.SALES

SELECT *
FROM DANNYS_DINER.MEMBERS

--What is the total amount each customer spent at the restaurant?
SELECT  CUSTOMER_ID, SUM(PRICE) AS TOTAL
FROM DANNYS_DINER.SALES
INNER JOIN DANNYS_DINER.MENU ON DANNYS_DINER.SALES.PRODUCT_ID = DANNYS_DINER.MENU.PRODUCT_ID
GROUP BY CUSTOMER_ID


--How many days has each customer visited the restaurant?
SELECT CUSTOMER_ID, COUNT(DISTINCT ORDER_DATE) AS DAYS
FROM DANNYS_DINER.SALES
GROUP BY CUSTOMER_ID

--What was the first item from the menu purchased by each customer?
SELECT	CUSTOMER_ID, 
		MIN(PRODUCT_NAME) AS PRODUCT_NAME, 
		MIN(ORDER_DATE) AS ORDER_DATE
FROM DANNYS_DINER.SALES
INNER JOIN DANNYS_DINER.MENU ON DANNYS_DINER.SALES.PRODUCT_ID = DANNYS_DINER.MENU.PRODUCT_ID
GROUP BY CUSTOMER_ID
ORDER BY CUSTOMER_ID

--WITH FirstOrders AS (
--    SELECT CUSTOMER_ID, PRODUCT_ID, ORDER_DATE,
--           ROW_NUMBER() OVER (PARTITION BY CUSTOMER_ID ORDER BY ORDER_DATE ASC) AS rn
--    FROM DANNYS_DINER.SALES
--)
--SELECT FO.CUSTOMER_ID, M.PRODUCT_NAME, FO.ORDER_DATE
--FROM FirstOrders AS FO
--INNER JOIN DANNYS_DINER.MENU AS M ON FO.PRODUCT_ID = M.PRODUCT_ID
--WHERE FO.rn = 1;





--What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT TOP 1 PRODUCT_NAME, COUNT(S.PRODUCT_ID) AS SOLD
FROM DANNYS_DINER.SALES AS S
LEFT JOIN DANNYS_DINER.MENU AS M ON S.PRODUCT_ID = M.PRODUCT_ID
GROUP BY PRODUCT_NAME
ORDER BY SOLD DESC

--Which item was the most popular for each customer?

WITH RANKEDPRODUCTS AS(
	SELECT CUSTOMER_ID, PRODUCT_NAME, COUNT(S.PRODUCT_ID) AS SOLD,
DENSE_RANK() OVER (PARTITION BY CUSTOMER_ID ORDER BY COUNT(S.PRODUCT_ID)DESC) AS RN 
FROM DANNYS_DINER.SALES AS S
INNER JOIN DANNYS_DINER.MENU AS M
ON S.PRODUCT_ID = M.PRODUCT_ID
GROUP BY CUSTOMER_ID, PRODUCT_NAME
)
SELECT CUSTOMER_ID, PRODUCT_NAME, SOLD
FROM RANKEDPRODUCTS
WHERE RN=1;


--Which item was purchased first by the customer after they became a member?

WITH FIRST_PURCHASED AS(
SELECT  PRODUCT_NAME, ORDER_DATE, S.CUSTOMER_ID,
ROW_NUMBER() OVER (PARTITION BY S.CUSTOMER_ID ORDER BY ORDER_DATE ASC) AS RN
FROM DANNYS_DINER.SALES AS S
JOIN DANNYS_DINER.members AS MEM
ON S.customer_id = MEM.customer_id
JOIN DANNYS_DINER.MENU AS M
ON S.PRODUCT_ID = M.product_id
WHERE ORDER_DATE > join_date 
)

SELECT PRODUCT_NAME, ORDER_DATE, customer_id
FROM FIRST_PURCHASED
WHERE RN = 1
ORDER BY ORDER_DATE ASC

--Which item was purchased just before the customer became a member?

WITH LAST AS (
SELECT PRODUCT_NAME, S.CUSTOMER_ID, ORDER_DATE,
ROW_NUMBER() OVER(PARTITION BY S.CUSTOMER_ID ORDER BY ORDER_DATE DESC) AS RN
FROM DANNYS_DINER.SALES AS S
JOIN DANNYS_DINER.members AS MEM
ON S.customer_id = MEM.customer_id
JOIN DANNYS_DINER.MENU AS M
ON S.PRODUCT_ID = M.product_id
WHERE order_date<join_date
)

SELECT PRODUCT_NAME, CUSTOMER_ID, ORDER_DATE
FROM LAST
WHERE RN = 1
ORDER BY ORDER_DATE DESC

--What is the total items and amount spent for each member before they became a member?

--WITH TOTAL AS (
--SELECT product_name, PRICE,
--ROW_NUMBER() OVER (PARTITION BY S.CUSTOMER_ID ORDER BY ORDER_DATE DESC) AS RN
--FROM dannys_diner.sales AS S
--JOIN dannys_diner.menu AS M ON S.product_id = M.product_id
--JOIN dannys_diner.members AS MEM ON S.customer_id = MEM.customer_id
--WHERE ORDER_DATE < join_date
--)

--SELECT COUNT(PRODUCT_ID), SUM(PRICE)
--FROM TOTAL
--ORDER BY ORDER_DATE DESC


SELECT 
	S.CUSTOMER_ID,
	COUNT(S.PRODUCT_ID)AS TOTAL_ITEMS_BEFORE_MEMBER, 
	SUM(PRICE) AS TOTAL_PRICE_BEFORE_MEMBER
	FROM 
	dannys_diner.sales AS S
	JOIN dannys_diner.menu AS M
	ON S.product_id = M.product_id
	JOIN dannys_diner.members AS MEM
	ON S.customer_id = MEM.customer_id
	WHERE ORDER_DATE < JOIN_DATE
	GROUP BY S.customer_id
	

	--If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

	WITH CTE AS 
	(
	SELECT 
	 S.CUSTOMER_ID,
	CASE
		WHEN S.PRODUCT_ID = 1 THEN (PRICE * 20)
		ELSE (PRICE * 10)
		END AS POINTS
	FROM
	dannys_diner.sales AS S
	JOIN dannys_diner.menu AS M
	ON S.product_id = M.product_id
	)

	SELECT CUSTOMER_ID, SUM(POINTS)
	FROM CTE
	GROUP BY CUSTOMER_ID

	
	--In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

	WITH Date_Ranges AS (
    SELECT 
        customer_id, 
        join_date,
        DATEADD(DAY, 7, join_date) AS first_week_end
    FROM 
        dannys_diner.members
)

SELECT 
    S.customer_id,
    SUM(
        CASE
            WHEN S.order_date BETWEEN DR.join_date AND DR.first_week_end THEN M.price * 20
            WHEN S.product_id = 1 THEN M.price * 20
            ELSE M.price * 10
        END
    ) AS total_points_january
FROM 
    dannys_diner.sales AS S
JOIN 
    dannys_diner.menu AS M ON S.product_id = M.product_id
JOIN 
    Date_Ranges AS DR ON S.customer_id = DR.customer_id
WHERE 
    S.order_date <= '2021-01-31'  
GROUP BY 
    S.customer_id;


	--Bonus Questions Join All The Things
	--The following questions are related creating basic data tables that Danny and his team can use to quickly derive insights without needing to join the underlying tables using SQL.
	SELECT 
	S.CUSTOMER_ID,
	ORDER_DATE,
	PRODUCT_NAME,
	PRICE,
	CASE
		WHEN ORDER_DATE >= JOIN_DATE THEN 'Y'
		ELSE 'N'
		END AS MEMBER
	FROM dannys_diner.sales AS S
	LEFT JOIN dannys_diner.menu AS M
	ON S.product_id = M.product_id
	LEFT JOIN dannys_diner.members AS MEM
	ON S.customer_id = MEM.CUSTOMER_ID


	--Rank All The Things
	--Danny also requires further information about the ranking of customer products, but he purposely does not need the ranking for non-member purchases so he expects null ranking values for the records when customers are not yet part of the loyalty program.


	WITH CTE AS (
		SELECT 
	S.CUSTOMER_ID,
	ORDER_DATE,
	PRODUCT_NAME,
	PRICE,
	CASE
		WHEN ORDER_DATE >= JOIN_DATE THEN 'Y'
		ELSE 'N'
		END AS MEMBER
	FROM dannys_diner.sales AS S
	LEFT JOIN dannys_diner.menu AS M
	ON S.product_id = M.product_id
	LEFT JOIN dannys_diner.members AS MEM
	ON S.customer_id = MEM.CUSTOMER_ID
	)


	SELECT *,
	  CASE 
	  WHEN CTE.MEMBER = 'Y' THEN RANK() OVER (PARTITION BY CUSTOMER_ID, MEMBER ORDER BY ORDER_DATE)
	  ELSE NULL
	  END AS RANKING
	FROM CTE
	
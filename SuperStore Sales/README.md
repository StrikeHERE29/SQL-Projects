# Superstore Sales Analysis

## Overview

This project involves analyzing sales data from a sample Superstore dataset. The dataset includes information about orders, products, sales, profits, and customer data. The goal of this project is to gain insights into sales performance, product profitability, shipping methods, and regional performance, using SQL queries to extract meaningful business insights.

## Dataset

- **Dataset Source:** [Sample Supermarket Dataset](https://www.kaggle.com/datasets/bravehart101/sample-supermarket-dataset)
- **Tables:**
  - `ORDERS`: Contains order details like `OrderID`, `OrderDate`, `ShipMode`, `Region`, etc.
  - `SALES`: Contains product sales information like `OrderID`, `Product`, `Sales`, `Profit`, `Discount`, etc.

## SQL Queries and Insights

This project uses SQL to answer key business questions based on the dataset. The main areas of analysis include:

- **Top Performing Products:** Identifying product sub-categories with the highest sales and lowest profits.
- **Ship Mode Analysis:** Analyzing which shipping methods are associated with the highest number of orders and their impact on profits.
- **Regional Profitability:** Determining which product sub-categories are the most profitable in each region.
- **Sales Ranking:** Ranking product categories based on total sales within specific regions.
- **Discount Analysis:** Identifying product categories with the largest total discount across regions.

### Key SQL Operations Applied:

- **Primary Key and Foreign Key Creation:**
  - Applied a `NOT NULL` constraint to ensure the integrity of foreign key references.
  - Created primary keys for tables and foreign key relationships between `ORDERS` and `SALES` tables.

- **Data Type Modifications:**
  - Modified columns to ensure they use appropriate data types (e.g., changing `SALES`, `PROFIT`, and `DISCOUNT` columns to `FLOAT`).

- **Aggregation and Grouping:**
  - Used `SUM()`, `ROUND()`, and `GROUP BY` to calculate total sales and profits, as well as profitability for product sub-categories and regions.

- **Window Functions:**
  - Applied `RANK()` to rank product categories based on total sales and discounts within each region.

- **Common Table Expressions (CTE):**
  - Used CTEs for intermediate calculations, such as calculating total discounts by region and category.




# Superstore Sales Analysis

## About This Project

Welcome to the Superstore Sales Analysis project! 🎉 This project is all about exploring and analyzing sales data from a fictional superstore to uncover insights that can help businesses improve their performance and make smarter decisions. Using SQL, I’ve tackled various business questions like which products are the most profitable, which shipping methods drive the most orders, and how sales perform across different regions.

The dataset contains a wealth of information, including order details, product sales, profits, and customer demographics. My goal was to bring these numbers to life with powerful queries that help us see the bigger picture of sales performance.

## The Dataset

- **Dataset Source:** [Sample Supermarket Dataset](https://www.kaggle.com/datasets/bravehart101/sample-supermarket-dataset)
- **Tables Included:**
  - **ORDERS:** This table stores details about each order, such as `OrderID`, `OrderDate`, `ShipMode`, `Region`, and more.
  - **SALES:** Contains sales-related information like `OrderID`, `Product`, `Sales`, `Profit`, and `Discount`.

## What I’ve Analyzed

Throughout this project, I’ve applied SQL to answer a series of business-focused questions. Here’s a quick look at some of the key analyses I performed:

- **Best and Worst Performing Products:** By analyzing total sales and profit, I identified which product sub-categories brought in the most revenue and which ones performed the weakest.
- **Impact of Shipping Methods:** I looked into which ship modes resulted in the most orders and how they affected profit margins.
- **Regional Performance:** I analyzed which product sub-categories were most profitable in each region and how each region stacked up in terms of overall sales.
- **Sales Ranking:** I ranked product categories within each region based on total sales to get a clear picture of what’s driving revenue.
- **Discount Analysis:** I also explored which product categories were receiving the highest total discounts across different regions.

## SQL Techniques Used

This project isn’t just about querying the data – it’s about digging deep and getting creative with SQL! Here are some of the techniques I used to turn raw data into actionable insights:

- **Key Constraints:** I ensured the integrity of the database by applying `NOT NULL` constraints and creating relationships between tables using primary and foreign keys.
- **Data Type Adjustments:** I made sure columns like `SALES`, `PROFIT`, and `DISCOUNT` used the appropriate data types (i.e., `FLOAT`) for accurate calculations.
- **Aggregations & Grouping:** I used `SUM()` and `ROUND()` along with `GROUP BY` to calculate total sales, profits, and profitability, giving me the big picture of product performance.
- **Window Functions:** To rank product categories by sales within each region, I utilized `RANK()`, helping us identify top performers.
- **CTEs (Common Table Expressions):** For complex calculations, I used CTEs to structure the queries more clearly, especially when analyzing discounts.



# Walmart Sales SQL Analysis Using MySQL

## Project Overview

This project analyses Walmart sales data using MySQL to understand sales performance, customer behaviour, product performance, revenue trends, payment preferences, and branch-level business activity.

The goal of this project was not just to write SQL queries, but to use SQL to answer practical retail business questions. The analysis focuses on identifying which product lines perform best, which customer groups generate more revenue, which branches and cities perform strongly, when customers shop the most, and how customer ratings vary across different parts of the business.

The project was completed using MySQL Workbench and includes database creation, table creation, feature engineering, exploratory analysis, and business-focused SQL queries.

---

## Business Problem

Retail businesses generate large amounts of sales transaction data every day. However, raw transaction records do not automatically explain what is happening in the business.

Without proper analysis, it can be difficult to answer important questions such as:

- Which product lines generate the most revenue?
- Which branches and cities perform best?
- Which customer type contributes more to sales?
- What time of day records the highest sales activity?
- Which payment methods are most commonly used?
- Which product lines receive the best customer ratings?
- How do sales and customer behaviour vary across branches?

This project solves that problem by using SQL to transform raw Walmart sales data into useful business insights that can support decisions around sales strategy, customer experience, branch performance, product planning, and operational improvement.

---

## Dataset Description

The dataset contains Walmart sales transaction records. Each row represents a customer purchase and includes information about the invoice, branch, city, customer type, gender, product line, unit price, quantity, tax, total sales value, payment method, cost of goods sold, gross income, customer rating, date, and time.

The main fields used in the analysis include:

- `invoice_id`
- `branch`
- `city`
- `customer_type`
- `gender`
- `product_line`
- `unit_price`
- `quantity`
- `tax_pct`
- `total`
- `date`
- `time`
- `payment`
- `cogs`
- `gross_margin_pct`
- `gross_income`
- `rating`

Additional fields were created during the analysis to support deeper time-based reporting:

- `time_of_day`
- `day_name`
- `month_name`

---

## Tools Used

- MySQL
- MySQL Workbench
- SQL

---

## Project Workflow

The project followed a structured SQL analysis process:

1. Created a dedicated database for the Walmart sales project.
2. Created a `sales` table using suitable data types.
3. Imported the Walmart sales dataset into MySQL.
4. Checked the table structure and reviewed the records.
5. Created additional columns for time-based analysis.
6. Wrote SQL queries to answer business questions.
7. Grouped the analysis into product, sales, customer, branch, and city-level insights.
8. Interpreted the results from a business decision-making perspective.

---

## Database Creation

The project started by creating and selecting a database for the analysis.

```sql
CREATE DATABASE IF NOT EXISTS walmartSalesData;
USE walmartSalesData;
```

A `sales` table was then created to store the transactional sales records.

```sql
CREATE TABLE IF NOT EXISTS sales (
    invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12,4) NOT NULL,
    `date` DATETIME NOT NULL,
    `time` TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12,4),
    rating FLOAT(2,1)
);
```

---

## Feature Engineering

To make the analysis more useful, new columns were created from the existing date and time fields.

### Time of Day

A `time_of_day` column was created to group transactions into morning, afternoon, and evening periods.

```sql
ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = CASE
    WHEN `time` BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
    WHEN `time` BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
    ELSE 'Evening'
END;
```

This helped identify which part of the day recorded the highest sales activity and customer ratings.

### Day Name

A `day_name` column was created from the transaction date.

```sql
ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(`date`);
```

This made it possible to analyse sales and customer ratings by day of the week.

### Month Name

A `month_name` column was created to support monthly revenue and cost analysis.

```sql
ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(`date`);
```

This allowed revenue, cost of goods sold, and sales trends to be analysed by month.

---

## Business Questions Answered

The SQL analysis was designed around business questions that are relevant to retail performance.

### Product Analysis

- How many unique product lines are in the dataset?
- What is the most selling product line?
- Which product line generated the highest revenue?
- Which product line had the highest average VAT?
- What is the average rating of each product line?
- What is the most common product line by gender?

### Sales Analysis

- What is the total revenue by month?
- Which month had the largest cost of goods sold?
- Which city generated the highest revenue?
- Which customer type generated the most revenue?
- Which time of day recorded the highest number of sales?
- Which branch sold more products than the average branch sales quantity?

### Customer Analysis

- How many unique customer types are in the dataset?
- What is the most common customer type?
- Which customer type buys the most?
- What is the gender distribution across branches?
- Which payment methods are most commonly used?
- Which time of day has the highest average customer rating?

### Branch and City Analysis

- Which city is each branch located in?
- Which branch has the strongest sales activity?
- Which city has the highest average tax/VAT percentage?
- Which day of the week has the highest number of sales per branch?

---

## Sample SQL Queries

Below are some of the key SQL queries used in the analysis. The full SQL script is available in the project file.

### Most Selling Product Line

```sql
SELECT
    product_line,
    SUM(quantity) AS total_quantity
FROM sales
GROUP BY product_line
ORDER BY total_quantity DESC;
```

This query identifies the product lines with the highest sales volume.

---

### Total Revenue by Month

```sql
SELECT
    month_name AS month,
    SUM(total) AS total_revenue
FROM sales
GROUP BY month_name
ORDER BY total_revenue DESC;
```

This query compares monthly revenue performance and helps identify the strongest sales months.

---

### Product Line with the Highest Revenue

```sql
SELECT
    product_line,
    SUM(total) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;
```

This query identifies the product categories contributing the most to total revenue.

---

### Customer Type Generating the Most Revenue

```sql
SELECT
    customer_type,
    SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue DESC;
```

This query compares revenue contribution between different customer groups.

---

### Gender Distribution by Branch

```sql
SELECT
    branch,
    gender,
    COUNT(*) AS gender_count
FROM sales
GROUP BY branch, gender
ORDER BY branch, gender_count DESC;
```

This query shows how customer gender distribution varies across branches.

---

### Average Rating by Product Line

```sql
SELECT
    product_line,
    ROUND(AVG(rating), 2) AS avg_rating
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;
```

This query identifies which product lines received the highest average customer ratings.

---

### Branches Selling Above Average Quantity

```sql
SELECT 
    branch,
    SUM(quantity) AS total_quantity
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (
    SELECT AVG(branch_total)
    FROM (
        SELECT 
            branch,
            SUM(quantity) AS branch_total
        FROM sales
        GROUP BY branch
    ) AS branch_sales
);
```

This query compares each branch’s total quantity sold against the average branch sales quantity.

---

## Key Insights

The SQL analysis provided useful insights into sales performance, product demand, customer behaviour, and branch activity.

Key insights from the analysis include:

- Product lines can be ranked by both sales quantity and revenue to identify high-performing categories.
- Monthly revenue and cost of goods sold can be compared to understand business performance over time.
- Customer type analysis helps identify which customer group contributes more to revenue.
- Branch and city-level analysis helps compare performance across locations.
- Time-of-day analysis helps identify when customer activity is highest.
- Customer rating analysis provides insight into satisfaction across product lines, branches, and shopping periods.
- Payment method analysis helps understand customer payment preferences.

---

## SQL Techniques Used

This project demonstrates the use of several SQL techniques, including:

- Database creation
- Table creation
- Data type selection
- Data querying
- Data transformation
- `ALTER TABLE`
- `UPDATE`
- `CASE` statements
- `GROUP BY`
- `ORDER BY`
- `HAVING`
- Subqueries
- Aggregate functions such as `SUM`, `COUNT`, `AVG`, and `ROUND`
- Date functions such as `DAYNAME()` and `MONTHNAME()`

---

## Project Files

```text
walmart_sales_analysis.sql
README.md
```

If the dataset is included in this repository, the project may also include:

```text
walmart_sales_data.csv
```

---

## How to Use This Project

To run this project locally:

1. Download or clone this repository.
2. Open MySQL Workbench.
3. Open the `walmart_sales_analysis.sql` file.
4. Run the database creation and table creation scripts.
5. Import the Walmart sales dataset into the `sales` table.
6. Run the feature engineering queries to create `time_of_day`, `day_name`, and `month_name`.
7. Run the analysis queries to generate the business insights.

---

## What I Learned

This project helped strengthen my ability to use SQL for business analysis, not just basic data retrieval.

The main learning outcomes from this project include:

- Writing SQL queries to answer practical business questions
- Creating calculated columns for deeper analysis
- Using aggregation to summarise sales performance
- Applying date and time functions for trend analysis
- Using subqueries for more advanced filtering
- Structuring SQL scripts clearly for portfolio presentation
- Translating raw transactional data into useful business insights

---

## Conclusion

This project demonstrates how SQL can be used to analyse retail sales data and extract meaningful business insights.

By creating a structured database, engineering useful time-based fields, and writing business-focused queries, the analysis provides a clearer understanding of Walmart sales performance across products, branches, cities, customer groups, and time periods.

The project highlights how SQL can support practical decision-making in retail operations, sales strategy, customer analysis, and performance monitoring.

-- Create and use database
CREATE DATABASE IF NOT EXISTS walmartSalesData;
USE walmartSalesData;

-- Create sales table
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

-- View all records
SELECT * FROM sales;

-- Create time_of_day column
ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = CASE
    WHEN `time` BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
    WHEN `time` BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
    ELSE 'Evening'
END;

-- Create day_name column
ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(`date`);

-- Create month_name column
ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(`date`);

-- --------------------------------------------------------------------
-- Exploratory Data Analysis
-- --------------------------------------------------------------------

-- How many unique cities does the data have?
SELECT DISTINCT city
FROM sales;

-- In which city is each branch located?
SELECT DISTINCT city, branch
FROM sales;

-- How many unique product lines does the data have?
SELECT DISTINCT product_line
FROM sales;

-- What is the most selling product line?
SELECT
    product_line,
    SUM(quantity) AS total_quantity
FROM sales
GROUP BY product_line
ORDER BY total_quantity DESC;

-- What is the total revenue by month?
SELECT
    month_name AS month,
    SUM(total) AS total_revenue
FROM sales
GROUP BY month_name
ORDER BY total_revenue DESC;

-- What month had the largest COGS?
SELECT
    month_name AS month,
    SUM(cogs) AS total_cogs
FROM sales
GROUP BY month_name
ORDER BY total_cogs DESC;

-- What product line had the largest revenue?
SELECT
    product_line,
    SUM(total) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

-- What city had the largest revenue?
SELECT
    city,
    branch,
    SUM(total) AS total_revenue
FROM sales
GROUP BY city, branch
ORDER BY total_revenue DESC;

-- What product line had the largest VAT?
SELECT
    product_line,
    AVG(tax_pct) AS avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;

-- Which branch sold more products than the average branch sales quantity?
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

-- What is the most common product line by gender?
SELECT
    gender,
    product_line,
    COUNT(*) AS total_count
FROM sales
GROUP BY gender, product_line
ORDER BY total_count DESC;

-- What is the average rating of each product line?
SELECT
    product_line,
    ROUND(AVG(rating), 2) AS avg_rating
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

-- --------------------------------------------------------------------
-- Sales Analysis
-- --------------------------------------------------------------------

-- Number of sales made in each time of day on Sunday
SELECT
    time_of_day,
    COUNT(*) AS total_sales
FROM sales
WHERE day_name = 'Sunday'
GROUP BY time_of_day
ORDER BY total_sales DESC;

-- Which customer type brings the most revenue?
SELECT
    customer_type,
    SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue DESC;

-- Which city has the largest average tax/VAT percentage?
SELECT
    city,
    ROUND(AVG(tax_pct), 2) AS avg_tax_pct
FROM sales
GROUP BY city
ORDER BY avg_tax_pct DESC;

-- Which customer type pays the most VAT on average?
SELECT
    customer_type,
    ROUND(AVG(tax_pct), 2) AS avg_tax
FROM sales
GROUP BY customer_type
ORDER BY avg_tax DESC;

-- --------------------------------------------------------------------
-- Customer Analysis
-- --------------------------------------------------------------------

-- How many unique customer types does the data have?
SELECT DISTINCT customer_type
FROM sales;

-- How many unique payment methods does the data have?
SELECT DISTINCT payment
FROM sales;

-- What is the most common customer type?
SELECT
    customer_type,
    COUNT(*) AS total_count
FROM sales
GROUP BY customer_type
ORDER BY total_count DESC;

-- Which customer type buys the most?
SELECT
    customer_type,
    COUNT(*) AS total_transactions,
    SUM(quantity) AS total_quantity
FROM sales
GROUP BY customer_type
ORDER BY total_quantity DESC;

-- What is the gender of most customers?
SELECT
    gender,
    COUNT(*) AS gender_count
FROM sales
GROUP BY gender
ORDER BY gender_count DESC;

-- What is the gender distribution per branch?
SELECT
    branch,
    gender,
    COUNT(*) AS gender_count
FROM sales
GROUP BY branch, gender
ORDER BY branch, gender_count DESC;

-- Which time of day has the highest average rating?
SELECT
    time_of_day,
    ROUND(AVG(rating), 2) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- Which time of day has the highest average rating per branch?
SELECT
    branch,
    time_of_day,
    ROUND(AVG(rating), 2) AS avg_rating
FROM sales
GROUP BY branch, time_of_day
ORDER BY branch, avg_rating DESC;

-- Which day of the week has the best average rating?
SELECT
    day_name,
    ROUND(AVG(rating), 2) AS avg_rating
FROM sales
GROUP BY day_name
ORDER BY avg_rating DESC;

-- Which day of the week has the highest number of sales per branch?
SELECT 
    branch,
    day_name,
    COUNT(*) AS total_sales
FROM sales
GROUP BY branch, day_name
ORDER BY branch, total_sales DESC;
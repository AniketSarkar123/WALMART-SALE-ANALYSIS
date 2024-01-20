CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);


SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;
/*------------------------------------------------------------------------------------------------------------------------------------------
------------------------ADDING REQUIRED ADDITIONAL ATTRIBUTES IN OUR SALES TABLE----------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------*/

/*-------ADDING A NEW COLUMN time_of_day------------*/
ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);
UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);

SELECT * FROM sales;

SELECT date,DAYNAME(date) FROM sales;
/*-----------ADDING DAY A NEW COLUMN IN THE TABLE------------*/
ALTER TABLE sales ADD COLUMN day VARCHAR(20);
UPDATE sales
	SET day=DAYNAME(date);
    
SELECT * FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);

SELECT * FROM sales;
/*---------------------------------------------------------------------------------------------------------
--GENERIC QUESTIONS---------------------------------------------------
---------------------------------------------------------------------------------------------------------*/

/*------------AVAILABLE PAYMENT MODES------------------------*/
SELECT DISTINCT payment FROM sales;
/*------------HOW MANY DISTINCT CITIES-----------------------*/
SELECT DISTINCT city FROM sales;
/*------------BRANCH CITY LIST-------------------------------*/
SELECT DISTINCT city,branch FROM sales;
/*-------------------------------------------------------------------------------------------------------
----------------------------------ANALYSIS OF PRODUCT SALES----------------------------------------------
--------------------------------------------------------------------------------------------------------*/
/*-------------HOW MANY DISTINCT PRODUCT LINES----------------------------------------------------------*/
SELECT DISTINCT product_line FROM sales;
/*-------------------MONTHLY REVENUE--------------------------------------------------------------------*/
SELECT month_name AS month, SUM(total) AS total_revenue FROM sales
GROUP BY month_name ORDER BY total_revenue;
-- SELECT * FROM sales;
-- What is the most selling product line----------------------------------------------------------------
SELECT
	SUM(quantity) as qty,
    product_line
FROM sales
GROUP BY product_line
ORDER BY qty DESC;

-- SELECT * FROM sales;

-- What month had the largest COGS?--------------------------------------------------------------------
SELECT
	month_name AS month,
	SUM(cogs) AS cogs
FROM sales
GROUP BY month_name 
ORDER BY cogs DESC;

/*--------------WHICH PRODUCT HAD THE LARGEST REVENUE-------------------------------------------------*/
SELECT
	product_line,
    SUM(total) AS total_revenue
    FROM sales
    GROUP BY product_line
    ORDER BY total_revenue DESC;
    
/*------------------------------------HERE CATAGORIZING GOOD SALE IF AVG QUANTITY SOLD IS -------------
------------------------------GREATER THAN A DEFAULT VALUE ELSE WE PRINT BAD AS A REMARK--------------*/
    
SELECT AVG(quantity) as avg_quantity FROM sales;
SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 5.5 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;

-- -----------------------------------AVERAGE RATING OF EACH PRODUCT--------------------------------
SELECT product_line, ROUND(AVG(rating),2) as avg_rating
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;
-- What is the most common product line by gender
SELECT
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

/*-----------------------------------------------------------------------------------------------------
--------------------------------------CUSTOMER STATS---------------------------------------------------
-------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------*/
-- ------------GENDER DISTRIBUTION OF THE BUYERS-------------------------------------------------------
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sales
GROUP BY gender
ORDER BY gender_cnt DESC;
-- ----------------------GENDER DISTRIBUTION IN BRANCHES-----------------------------------------------
SELECT 
	gender,branch,
    COUNT(*) AS gender_cnt
FROM sales
GROUP BY branch,gender
ORDER BY gender_cnt DESC;

-- -------------------------CUSTOMER TYPES------------------------------------------------------------
SELECT DISTINCT customer_type FROM sales;
/*-------------------TYPE OF CUSTOMER---------------------------------------------------------------*/
SELECT 
	customer_type,
    COUNT(*)
    FROM sales
    GROUP BY customer_type;
    
/*----------------WHICH DAY OF THE WEEK HAS BEST RATINGS(ORDER)------------------------------------*/
SELECT 
	day,AVG(rating) AS avg_rating
FROM sales
GROUP BY day
ORDER BY avg_rating DESC;

-- SELECT * FROM sales;

-- Which day of the week has the best average ratings per branch?----------------------------------
SELECT 
	day,branch,AVG(rating) AS avg_rating
    FROM sales
    GROUP BY day,branch
    ORDER BY avg_rating DESC;
    
/*-------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-----------------------------------------SALES-----------------------------------------------------
---------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------*/

-- Number of sales made in each time of the day per weekday----------------------------------------
SELECT
	day,time_of_day,
	COUNT(*) AS total_sales
FROM sales
GROUP BY time_of_day,day
ORDER BY total_sales DESC;

-- -----------------------WHICH CUSTOMER BRINGS MOST REVENUE---------------------------------------
SELECT 
	customer_type,
    SUM(total) as revenue_sum
	FROM sales
    GROUP BY customer_type
    ORDER BY revenue_sum DESC;
    
-- Which city has the largest tax/VAT percent?----------------------------------------------------
SELECT
	city,
    ROUND(AVG(tax_pct), 2) AS avg_tax_pct
FROM sales
GROUP BY city 
ORDER BY avg_tax_pct DESC;

-- Which customer type pays the most in VAT?------------------------------------------------------
SELECT
	customer_type,
	AVG(tax_pct) AS total_tax
FROM sales
GROUP BY customer_type
ORDER BY total_tax;







	



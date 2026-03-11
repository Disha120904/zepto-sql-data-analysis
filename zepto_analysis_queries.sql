drop table if exists zepto;

create table zepto (
sku_id SERIAL PRIMARY KEY,
category VARCHAR (120),
name VARCHAR (150)NOT NULL,
mrp NUMERIC(8,2),
discountPercent Numeric(5,2),
availableQuantity Integer, 
discountedSellingprice NUMERIC(8,2),
weeightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);


--data exploration

--count of rows
SELECT COUNT(*) FROM zepto

--sample data 
SELECT * FROM zepto 
LIMIT 10;

--null values
SELECT * FROM zepto 
WHERE name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountpercent IS NULL
OR
availablequantity IS NULL
OR
weeightingms IS NULL
OR
outofstock IS NULL;

--different product categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

--product in stock vs out of stock
SELECT outofstock,Count (sku_id)
FROM zepto 
GROUP BY outofstock;

--product names present multiple times
SELECT  name ,count(sku_id)
FROM zepto
GROUP BY name
HAVING count(sku_id) > 1
ORDER BY count(sku_id) DESC;

--data cleaning 

--products with price = 0
SELECT * FROM zepto
WHERE mrp=0 OR discountedsellingprice=0;

DELETE FROM zepto
WHERE mrp=0 OR discountedsellingprice=0;

--convert paise to rs
UPDATE zepto
SET mrp=mrp/100.0,
discountedsellingprice=discountedsellingprice/100.0

SELECT mrp,discountedsellingprice From zepto;

-- Q1. Find the top 10 best-value products based on the discount percentage.
SELECT name, mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

-- Q2. What are the products with high MRP but out of stock?
SELECT DISTINCT name,mrp
FROM zepto
WHERE outofstock =TRUE AND mrp>300
ORDER BY mrp DESC

-- Q3. Calculate estimated revenue for each category.
SELECT category,
SUM(discountedSellingPrice * availablequantity) AS estimated_revenue
FROM zepto
GROUP BY category
ORDER BY estimated_revenue DESC;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
SELECT DISTINCT name,mrp,discountpercent
FROM zepto
WHERE mrp>500 AND discountpercent <10
ORDER BY mrp DESC,discountpercent DESC;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT  category,ROUND( avg(discountpercent),2)
FROM zepto
GROUP BY category
ORDER BY avg(discountpercent) DESC
LIMIT 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, weeightInGms,discountedsellingprice,
ROUND(discountedSellingPrice / weeightInGms ,2)AS price_per_gram
FROM zepto
WHERE weeightInGms >= 100
ORDER BY price_per_gram ASC;

-- Q7. Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weeightingms,
CASE 
     WHEN weeightingms < 1000 THEN 'LOW'
     WHEN weeightingms < 5000 THEN 'MEDIUM'
     ELSE 'BULK'
	 END AS weeightcategory
FROM zepto

-- Q8. What is the total inventory weight per category?
SELECT category,
SUM(weeightInGms * availablequantity) AS total_inventory_weight
FROM zepto
GROUP BY category
ORDER BY total_inventory_weight DESC;


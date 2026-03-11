select * 
from ecommerce.Sales;
CREATE TABLE sales_clean AS
SELECT * FROM Sales;
SELECT * FROM sales_clean
where `Profit` is null;

SELECT `Order ID`, COUNT(*)
FROM sales_clean
GROUP BY `Order ID`
HAVING COUNT(*) > 1;

ALTER TABLE sales_clean
MODIFY `Order Date` DATE;

ALTER TABLE sales_clean
MODIFY `Sales` decimal(10,2);

SELECT *
FROM sales_clean
WHERE sales < 0;

DELETE FROM sales_clean
WHERE quantity <= 0;

ALTER TABLE sales_clean
ADD profit_margin DECIMAL(5,2);

UPDATE sales_clean
SET `profit_margin` = `profit` / `Sales` * 100
WHERE Sales > 0;
SELECT * FROM sales_clean;
SELECT COUNT(*) FROM sales_clean;
SELECT distinct `Payment mode` FROM sales_clean;
SELECT distinct `Category` FROM sales_clean;
SELECT distinct `City` FROM sales_clean;
SELECT distinct `Region` FROM sales_clean;
SELECT distinct `Product Name`,`Sub-Category`,`Category` FROM sales_clean;
SELECT distinct  `Product Name` FROM sales_clean;
update sales_clean
 set `Order Date` = str_to_date(`Order Date`,'%m/%d/%Y');
select `Order Date` from sales_clean;
SELECT DISTINCT `Payment Mode`
FROM sales_clean;
SELECT Category, COUNT(*)
FROM sales_clean
GROUP BY Category;




/*Revenue, Profit, Margin (Final Table)*/
CREATE VIEW rpt_kpi_summary AS
SELECT 
    COUNT(DISTINCT `Order ID`) AS total_orders,
    SUM(Quantity) AS total_units,
    ROUND(SUM(Sales), 2) AS total_revenue,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS overall_margin
FROM sales_clean;

/*Monthly Revenue & Profit (Trend Table)*/
CREATE VIEW rpt_monthly_trends AS
SELECT 
    YEAR(`Order Date`) AS year,
    MONTH(`Order Date`) AS month,
    ROUND(SUM(Sales), 2) AS revenue,
    ROUND(SUM(Profit), 2) AS profit
FROM sales_clean
GROUP BY year, month;


/*Category Performance (Decision Table)*/
CREATE VIEW rpt_category_performance AS
SELECT 
    Category,
    COUNT(DISTINCT `Order ID`) AS orders,
    ROUND(SUM(Sales), 2) AS revenue,
    ROUND(SUM(Profit), 2) AS profit,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS margin
FROM sales_clean
GROUP BY Category;


/*Sub-Category Profitability Ranking*/
CREATE VIEW rpt_subcategory_performance AS
SELECT 
    Category,`Sub-Category`,
    COUNT(DISTINCT `Order ID`) AS orders,
    ROUND(SUM(Sales), 2) AS revenue,
    ROUND(SUM(Profit), 2) AS profit,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS margin
FROM sales_clean
GROUP BY Category, `Sub-Category`;


/*Region & City Contribution*/
CREATE VIEW rpt_region_performance AS
SELECT Region,
    ROUND(SUM(Sales), 2) AS revenue,
    ROUND(SUM(Profit), 2) AS profit
FROM sales_clean
GROUP BY Region;

CREATE VIEW rpt_city_performance AS
SELECT City,
    ROUND(SUM(Sales), 2) AS revenue,
    ROUND(SUM(Profit), 2) AS profit
FROM sales_clean
GROUP BY City;

/*Payment Analysis*/
CREATE VIEW rpt_payment_analysis AS
SELECT 
    `Payment Mode`,
    COUNT(DISTINCT `Order ID`) AS orders,
    ROUND(SUM(Sales), 2) AS revenue,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS margin
FROM sales_clean
GROUP BY `Payment Mode`;

/*Discount Impact*/
CREATE VIEW rpt_discount_analysis AS
SELECT Discount,
    COUNT(DISTINCT `Order ID`) AS orders,
    ROUND(SUM(Sales), 2) AS revenue,
    ROUND(SUM(Profit), 2) AS profit,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS margin
FROM sales_clean
GROUP BY Discount;




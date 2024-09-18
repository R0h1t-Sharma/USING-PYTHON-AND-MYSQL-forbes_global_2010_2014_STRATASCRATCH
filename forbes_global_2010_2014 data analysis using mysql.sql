create database forbes_global_2010_2014;
use forbes_global_2010_2014;
-- 1-Find the 3 most profitable companies in the entire world.
--- Output the result along with the corresponding company name.
--- Sort the result based on profits in descending order.

SELECT company,
       profit
FROM
  (SELECT *,
          rank() OVER (
                       ORDER BY profit DESC) as rnk
   FROM
     (SELECT company,
             sum(profits) AS profit
      FROM forbes_global_2010_2014
      GROUP BY company) sq) sq2
WHERE rnk <=3;

--- 2-Find the continet with the highest number of companies.
-- Output the continent along with the corresponding number of companies.
WITH cte AS
  (SELECT continent,
          count(company) AS n_companies
   FROM forbes_global_2010_2014
   GROUP BY continent)
SELECT continent,
       n_companies
FROM cte
WHERE n_companies = (
  SELECT MAX(n_companies)
             FROM cte);

--- 3-Find the total assets of the energy sector.
SELECT 
    sum(assets) AS total_assets
FROM forbes_global_2010_2014
WHERE 
    sector = 'Energy';

--- 4-Find the top 3 sectors in the United States with highest average rank. Output the average rank along with the sector name.
WITH subquery AS
  (SELECT sector,
          avg(`rank`) AS avg_rank,
          rank() OVER (
                       ORDER BY avg(`rank`) ASC) as rnk
   FROM forbes_global_2010_2014
   WHERE country = 'United States'
   GROUP BY sector)
SELECT sector,
       avg_rank
FROM subquery
WHERE rnk <=3;

-- 5-Find the number of USA companies that are on the list.
SELECT 
    count(company) AS n_us_companies
FROM forbes_global_2010_2014
WHERE
    country = 'United States';
-- 6-Find the total market value for the financial sector.
select sum(marketvalue)
from forbes_global_2010_2014
where sector LIKE '%financial%';

--- 6-Find industries with the highest market value in Asia.
-- Output the industry along with the corresponding total market value.
WITH cte AS
  (SELECT industry,
          sum(marketvalue) AS total_marketvalue
   FROM forbes_global_2010_2014
   WHERE continent = 'Asia'
   GROUP BY industry
   ORDER BY total_marketvalue DESC)
SELECT *
FROM cte
WHERE total_marketvalue =
    (SELECT MAX(total_marketvalue)
     FROM cte);
-- 7-- Find the average profit for major banks.
SELECT 
    AVG(profits) AS average_profit
FROM forbes_global_2010_2014
WHERE 
    industry = 'Major Banks';
-- 7.1- Find industries with the highest market value in Asia.
-- Output the industry along with the corresponding total market value.

WITH cte AS
  (SELECT industry,
          sum(marketvalue) AS total_marketvalue
   FROM forbes_global_2010_2014
   WHERE continent = 'Asia'
   GROUP BY industry
   ORDER BY total_marketvalue DESC)
SELECT *
FROM cte
WHERE total_marketvalue =
    (SELECT MAX(total_marketvalue)
     FROM cte);
-- 8--Find industries with the highest number of companies.
-- Output the industry along with the number of companies.
--- Sort records based on the number of companies in descending order
SELECT
    industry,
    count(company) AS n_companies
FROM forbes_global_2010_2014
GROUP BY 
    industry
ORDER BY 
    n_companies DESC;
    
    -- 9.1--
-- 9---Find the most popular sector from the Forbes list based on the number of companies in each sector.
--- Output the sector along with the number of companies.
WITH cte AS(
  SELECT sector,
        COUNT(*) AS n_companies,
        RANK() OVER(
          ORDER BY COUNT(company) DESC) AS rnk
  FROM forbes_global_2010_2014
  GROUP BY sector
)
SELECT sector,
        n_companies
FROM cte
WHERE rnk = 1;

--- 10-- Find the country that has the most companies listed on Forbes.Output the country along with the number of companies.
SELECT 
    country, 
    count(company) AS n_companies
FROM forbes_global_2010_2014
GROUP BY
    country
ORDER BY 
    n_companies DESC 
LIMIT 1;
-- 11--Find all industries with a positive average profit. For those industries extract their lowest sale.
--- Output the industry along with the corresponding lowest sale and average profit.
--- Sort the output based on the lowest sales in ascending order.
SELECT
    industry,
    min(sales) AS min_sales,
    avg(profits) AS avg_profit
FROM
    forbes_global_2010_2014
GROUP BY 
    industry
HAVING 
    avg(profits) > 0
ORDER BY
    min_sales ASC;
-- 12 --Find the highest market value for each sector.
--- Output the sector name along with the result.
SELECT
    sector,
    MAX(marketvalue) AS max_market_value
FROM forbes_global_2010_2014
GROUP BY 
    sector;
-- 13- What is the profit to sales ratio (profit/sales) of Royal Dutch Shell? Output the result along with the company name.
SELECT
    company,
    profits / sales AS profit_to_sales_ratio
FROM forbes_global_2010_2014
WHERE 
    company = 'Royal Dutch Shell';
    -- 14-- Find the industry with lowest average sales. Output that industry.
    WITH industries AS
  (SELECT industry,
          avg(sales) AS sales
   FROM forbes_global_2010_2014
   GROUP BY industry)
SELECT industry
FROM industries
WHERE sales =
    (SELECT min(sales)
     FROM industries);
     -- 15-- Count the number of companies in the Information Technology sector in each country.
--- Output the result along with the corresponding country name.
--- Order the result based on the number of companies in the descending order.
SELECT
    country,
    count(*) AS n_companies
FROM forbes_global_2010_2014
WHERE
    sector = 'Information Technology'
GROUP BY 
    country
ORDER BY
    n_companies DESC;
    -- 16--Finding the highest market value for each sector. Which sector is it best to invest in? Output the result along with the sector name. Order the result based on the highest market value in descending order.
    SELECT
    sector,
    MAX(marketvalue) AS max_marketvalue
FROM forbes_global_2010_2014
GROUP BY 
    sector
ORDER BY 
    max_marketvalue DESC;
    -- 17 --Find the most profitable company from the financial sector. Output the result along with the continent.
    SELECT company, 
       continent 
FROM forbes_global_2010_2014 
WHERE sector = 'Financials' 
      AND profits = (SELECT MAX(profits) 
                     FROM forbes_global_2010_2014 
                     WHERE sector = 'Financials');
	-- 18 ---List all companies working in the financial sector with headquarters in Europe or Asia.
    SELECT
    company
FROM forbes_global_2010_2014
WHERE 
    (continent = 'Asia' OR continent = 'Europe') AND
    (sector = 'Financials');
    
    -- 19--Find the date when Apple's opening stock price reached its maximum
--- use dataset  aapl_historical_stock_price
SELECT date 
FROM aapl_historical_stock_price 
WHERE open = (
    SELECT MAX(open) 
    FROM aapl_historical_stock_price
);
-- 20 - Find the best day of the month for AAPL stock trading. The best day is the one with highest positive difference between average closing price and average opening price. 
---- Output the result along with the average opening and closing prices.
WITH cte AS
  (SELECT DAY(date) AS day_of_month,
          AVG(OPEN) AS avg_open,
          AVG(CLOSE) AS avg_close
   FROM aapl_historical_stock_price
   GROUP BY day_of_month)
SELECT *
FROM cte
WHERE (avg_close - avg_open) =
    (SELECT MAX(avg_close - avg_open)
     FROM cte);


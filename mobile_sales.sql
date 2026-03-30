-- ============================================================
--   MOBILE SALES DATA ANALYST PROJECT — MySQL
--   Dataset: 3,835 transactions | 2021–2024
--   Brands: Apple, Samsung, OnePlus, Vivo, Xiaomi
--   Cities: 19 Indian cities
-- ============================================================


-- ============================================================
-- SECTION 1: DATABASE & TABLE SETUP
-- ============================================================


create database mobile_sales_data;

use mobile_sales_data;


-- =====================DATA CLEANNING ============================

alter table mobile_sales change `Transaction ID` transaction_id int;
alter table mobile_sales change `Day` sale_day tinyint;
alter table mobile_sales change `Month` sale_month tinyint;
alter table mobile_sales change `Year` sale_year smallint;
alter table mobile_sales change `Day Name` day_name varchar(10);
alter table mobile_sales change `Brand` brand varchar(30);
alter table mobile_sales change `Units Sold` units_sold int;
alter table mobile_sales change `Price Per Unit` price_per_unit decimal(10,2);
alter table mobile_sales change `Customer Name` customer_name varchar(80);
alter table mobile_sales change `Customer Age` customer_age tinyint;
alter table mobile_sales change `City` city varchar(40);
alter table mobile_sales change `Payment Method` payment_method varchar(20);
alter table mobile_sales change `Customer Ratings` customer_rating tinyint;
alter table mobile_sales change `Mobile Model` mobile_model varchar(50);

select * from mobile_sales;


alter table mobile_sales
add total_revenue decimal(14,2);

update mobile_sales
set total_revenue = units_sold * price_per_unit;

--- 
update mobile_sales
set day_name = case
    when lower(day_name) in ('mon', 'monday') then 'monday'
    when lower(day_name) in ('tue', 'tuesday') then 'tuesday'
    when lower(day_name) in ('wed', 'wednesday') then 'wednesday'
    when lower(day_name) in ('thu', 'thursday') then 'thursday'
    when lower(day_name) in ('fri', 'friday') then 'friday'
    when lower(day_name) in ('sat', 'saturday') then 'saturday'
    when lower(day_name) in ('sun', 'sunday') then 'sunday'
end;


select * from mobile_sales;

alter table mobile_sales
add sale_date date; 

update mobile_sales
set sale_date = str_to_date(
    concat(sale_year, '-', sale_month, '-', sale_day),
    '%Y-%m-%d'
);

 ## 🔹 1. Overall Business KPI
# Question:
-- How would you calculate total revenue, total units sold, and average order value from the dataset?

select 
    sum(total_revenue) as total_revenue,
    sum(units_sold) as total_units,
    round(avg(total_revenue), 2) as avg_order_value
from mobile_sales;


### 🔹 2. Top Performing Brand
-- Question:
-- How can you identify the brand that generates the highest revenue?
select brand, sum(total_revenue) as revenue
from mobile_sales
group by brand
order by revenue desc
limit 1;


### 🔹 3. Monthly Sales Trend
# Question:
-- How would you analyze the monthly sales trend using sql?
select 
    sale_year, sale_month,
    sum(total_revenue) as revenue
from mobile_sales
group by sale_year, sale_month
order by sale_year, sale_month;


### 🔹 4. Month-over-Month Growth
# Question:
-- How do you calculate Month-over-Month (MoM) growth in SQL?
select 
    sale_year,
    sale_month,
    sum(total_revenue) as revenue,
    sum(total_revenue) - lag(sum(total_revenue)) 
    over (order by sale_year, sale_month) as mom_growth
from mobile_sales
group by sale_year, sale_month;

### 🔹 5. City-wise Revenue Ranking
# Question:
-- How would you rank cities based on total revenue?
select 
    city,
    sum(total_revenue) as revenue,
    rank() over (order by sum(total_revenue) desc) as rank_city
from mobile_sales
group by city;

### 6. Best-Selling Product
# Question:
-- How would you find the best-selling mobile model based on units sold?
select mobile_model, sum(units_sold) as units
from mobile_sales
group by mobile_model
order by units desc
limit 1;

### 7. Customer Segmentation
# Question:
-- How would you segment customers based on age groups in SQL?
select 
    case 
        when customer_age between 18 and 25 then '18-25'
        when customer_age between 26 and 35 then '26-35'
        else '36+'
    end as age_group,
    count(*) as transactions
from mobile_sales
group by age_group;


###🔹 8. Payment Method Analysis
# Question:
-- How would you identify the most commonly used payment method?
select payment_method, count(*) as transactions
from mobile_sales
group by payment_method
order by transactions desc;

### 9. Revenue Contribution Percentage
# Question:
-- How do you calculate each brand’s contribution to total revenue?
select 
    brand,
    sum(total_revenue) as revenue,
    round(sum(total_revenue) * 100.0 / 
          sum(sum(total_revenue)) over(), 2) as contribution_pct
from mobile_sales
group by brand;

### 10. Repeat Customers
# Question:
-- How would you identify repeat customers in your dataset?
select customer_name, count(*) as orders
from mobile_sales
group by customer_name
having count(*) > 1;


###  11. Top 3 Brands per City
# Question:
-- How would you find the top 3 brands in each city?
select *
from (
    select 
        city,
        brand,
        sum(total_revenue) as revenue,
        rank() over (partition by city order by sum(total_revenue) desc) as rnk
    from mobile_sales
    group by city, brand
) t
where rnk <= 3;


# 12. Highest Revenue Month
# Question:
-- How would you determine the month with the highest revenue?
select 
    sale_year,
    sale_month,
    sum(total_revenue) as revenue
from mobile_sales
group by sale_year, sale_month
order by revenue desc
limit 1;

 ### 13. Customer Satisfaction
# Question:
-- How would you calculate average customer ratings for each brand?
select 
    brand,
    round(avg(customer_rating), 2) as avg_rating
from mobile_sales
group by brand
order by avg_rating desc;


### 14. High-Value Transactions
# Question:
-- How would you filter high-value transactions from the dataset?
select *
from mobile_sales
where total_revenue > 50000;


### 15. Running Total (Cumulative Revenue)
-- How would you calculate cumulative (running) revenue over time?
select 
    sale_year,
    sale_month,
    sum(total_revenue) as revenue,
    sum(sum(total_revenue)) over (order by sale_year, sale_month) as running_total
from mobile_sales
group by sale_year, sale_month;







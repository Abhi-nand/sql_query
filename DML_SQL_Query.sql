SET SQL_SAFE_UPDATES = 0;


-- Module: Database Design and Introduction to SQL
-- Session: Database Creation in MySQL Workbench
-- DDL Statements

-- 1. Create a table shipping_mode_dimen having columns with their respective data types as the following:
--    (i) Ship_Mode VARCHAR(25)
--    (ii) Vehicle_Company VARCHAR(25)
--    (iii) Toll_Required BOOLEAN
CREATE TABLE shipping_mode_dimen (
    ship_mode VARCHAR(25),
    vehicle_company VARCHAR(25),
    toll_required BOOLEAN
);
-- 2. Make 'Ship_Mode' as the primary key in the above table.
alter table shipping_mode_dimen
add constraint primary key (ship_mode);

-- -----------------------------------------------------------------------------------------------------------------
-- DML Statements

-- 1. Insert two rows in the table created above having the row-wise values:
--    (i)'DELIVERY TRUCK', 'Ashok Leyland', false
--    (ii)'REGULAR AIR', 'Air India', false
insert into shipping_mode_dimen(ship_mode,vehicle_company,toll_required)
values
('DELIVERY TRUCK','ASHOK LEYLAND',false),
('REGULAR AIR','AIR INDIA',false);

-- 2. The above entry has an error as land vehicles do require tolls to be paid. Update the ‘Toll_Required’ attribute
-- to ‘TRUE’.
UPDATE shipping_mode_dimen 
SET 
    toll_required = TRUE
WHERE
    ship_mode = 'DELIVERY TRUCK';

-- 3. Delete the entry for Air India.
DELETE FROM shipping_mode_dimen 
WHERE
    vehicle_company = 'AIR INDIA';

-- -----------------------------------------------------------------------------------------------------------------
-- Adding and Deleting Columns

-- 1. Add another column named 'Vehicle_Number' and its data type to the created table. 
alter table shipping_mode_dimen
add vehicle_number varchar(20);
-- 2. Update its value to 'MH-05-R1234'.
UPDATE shipping_mode_dimen 
SET 
    vehicle_number = 'MH-05-R1234';
-- 3. Delete the created column.
alter table shipping_mode_dimen
drop column vehicle_number;

-- -----------------------------------------------------------------------------------------------------------------
-- Changing Column Names and Data Types

-- 1. Change the column name ‘Toll_Required’ to ‘Toll_Amount’. Also, change its data type to integer.
alter table shipping_mode_dimen
change toll_required Toll_Amount int;
-- 2. The company decides that this additional table won’t be useful for data analysis. Remove it from the database.
drop table shipping_mode_dimen;

-- -----------------------------------------------------------------------------------------------------------------
-- Session: Querying in SQL
-- Basic SQL Queries

-- 1. Print the entire data of all the customers.
select * 
from cust_dimen;
-- 2. List the names of all the customers.
select customer_name 
from cust_dimen;
-- 3. Print the name of all customers along with their city and state.
select customer_name as 'Customers name',city 'Customers city',state'Customers state'
from cust_dimen
-- 4. Print the total number of customers.
`market_star_schema`
-- 5. How many customers are from West Bengal?
select count(*) as Bengal_Customers
from cust_dimen
where state = 'West Bengal';

-- 6. Print the names of all customers who belong to West Bengal.
select customer_name as 'Customers name',city 'Customers city',state'Customers state'
from cust_dimen
where state = 'West Bengal' and City='kolkata';

-- -----------------------------------------------------------------------------------------------------------------
-- Operators

-- 1. Print the names of all customers who are either corporate or belong to Mumbai.
select Customer_Name as 'Customers name',City 'Customers city',Customer_Segment
from cust_dimen
where city = 'Mumbai' or Customer_Segment='Corporate';
-- 2. Print the names of all corporate customers from Mumbai.
select Customer_Name as 'Customers name',City 'Customers city',Customer_Segment
from cust_dimen
where city = 'Mumbai' and Customer_Segment='Corporate';
-- 3. List the details of all the customers from southern India: namely Tamil Nadu, Karnataka, Telangana and Kerala.
select * 
from cust_dimen
where state in ('Tamil Nadu', 'Karnataka', 'Telangana','Kerala');
-- 4. Print the details of all non-small-business customers.
select * 
from cust_dimen
where Customer_Segment !='small Business';
-- 5. List the order ids of all those orders which caused losses.
select Ord_id, Profit 
from market_fact_full
where Profit < 0;


-- 6. List the orders with '_5' in their order ids and shipping costs between 10 and 15.
select Ord_id, Profit 
from market_fact_full
where Ord_id like '%\_5%' and Shipping_Cost between 10 and 15 ;
-- 7.Write a query to display the cities in the cust_dimen table which begin with the letter 'K'.
select customer_name as 'Customers name',city 'Customers city',state'Customers state'
from cust_dimen
where City like 'K%';
-- -----------------------------------------------------------------------------------------------------------------
-- Aggregate Functions

-- 1. Find the total number of sales made.
select count(sales ) as No_of_sale
from market_fact_full;

-- 2. What are the total numbers of customers from each city?
select count(Customer_Name ) as City_wise_costomer,  City
from cust_dimen
group by City;

select count(Customer_Name ) as City_wise_costomer,  City,Customer_Segment
from cust_dimen
group by City,Customer_Segment;
-- 3. Find the number of orders which have been sold at a loss.
select count(Ord_id ) as los_count
from market_fact_full
where Profit < 0;
-- 4. Find the total number of customers from Bihar in each segment.
select count(Customer_Name ) as Segment_wise_costomer,  State,Customer_Segment
from cust_dimen
where State = 'Bihar'
group by Customer_Segment;
-- 5. Find the customers who incurred a shipping cost of more than 50.
select Ord_id,Customer_Name,Shipping_Cost
from market_fact_full,cust_dimen
where Shipping_Cost>50;


-- -----------------------------------------------------------------------------------------------------------------
-- Ordering

-- 1. List the customer names in alphabetical order.
select  Customer_Name 
from cust_dimen
order by Customer_Name ;

select distinct Customer_Name 
from cust_dimen
order by Customer_Name desc;
-- 2. Print the three most ordered products.
select Prod_id,sum(Order_Quantity)
from market_fact_full
group by Prod_id
order by sum(Order_Quantity) desc
limit 3;
-- 3. Print the three least ordered products.
select Prod_id,sum(Order_Quantity)
from market_fact_full
group by Prod_id
order by sum(Order_Quantity) 
limit 3;
-- 4. Find the sales made by the five most profitable products.
select Prod_id,Profit
from market_fact_full
where Profit > 0
order by Sales desc
limit 5;
-- 5. Arrange the order ids in the order of their recency.
select Ord_id,Order_Date
from orders_dimen
order by Order_Date desc;

-- 6. Arrange all consumers from Coimbatore in alphabetical order.
select distinct Customer_Name ,City
from cust_dimen
where City = 'Coimbatore'
order by Customer_Name ;
-- select -- from -- where-- group by -- having --  order by -- limit 
-- This is the correct order in which clauses are written in a query.
-- -----------------------------------------------------------------------------------------------------------------
-- String and date-time functions

-- 1. Print the customer names in proper case.
select Customer_Name, concat(upper(substring(substring_index(lower(Customer_Name),' ',1),1,1)),
 upper(substring(substring_index(lower(Customer_Name),' ',-1),1,1)),substring_index(lower(Customer_Name),' ',-1)) as costomer_name_camel_case
from cust_dimen;
-- 2. Print the product names in the following format: Category_Subcategory.
select Product_Category ,Product_Sub_Category,
concat(Product_Category,'_' ,Product_Sub_Category) as Product_Name
from prod_dimen;
-- 3. In which month were the most orders shipped?
select count(Ship_id) as ship_count, month(Ship_Date) as Ship_month
from shipping_dimen
group by Ship_month
order by Ship_month desc
limit 1;
-- 4. Which month and year combination saw the most number of critical orders?
select count(Ord_id) as Ord_count, month(Order_Date) as Ord_month,year(Order_Date) as Ord_year
from orders_dimen
where Order_Priority ='critical'
group by Ord_year,Ord_month
order by count(Ord_id) desc;
-- 5. Find the most commonly used mode of shipment in 2011.
select Ship_Mode,count(Ship_Mode) as ship_mode_count
from shipping_dimen
where year(Ship_Date)='2011'
group by  Ship_Mode
order by ship_mode_count desc;

-- -----------------------------------------------------------------------------------------------------------------
-- Regular Expressions

-- 1. Find the names of all customers having the substring 'car'.
select Customer_Name
from cust_dimen
where Customer_Name regexp 'car';
-- 2. Print customer names starting with A, B, C or D and ending with 'er'.
select Customer_Name
from cust_dimen
where Customer_Name regexp '^[abcd].*er$';

-- -----------------------------------------------------------------------------------------------------------------
-- Nested Queries

-- 1. Print the order number of the most valuable order by sales.
select Ord_id,Sales,round(Sales) as rounded_sales
from market_fact_full
where Sales =(select  max(Sales)
from market_fact_full);
-- 2. Return the product categories and subcategories of all the products which don’t have details about the product
-- base margin.
SELECT Prod_id
FROM market_fact_full
WHERE Product_Base_Margin is null
        
SELECT  Prod_id  , Product_Category,Product_Sub_Category
FROM prod_dimen
WHERE   Prod_id IN (SELECT Prod_id
        FROM market_fact_full
        WHERE Product_Base_Margin is null);
-- 3. Print the name of the most frequent customer.
select Customer_Name,Cust_id
from cust_dimen
where Cust_id = ( 
select Cust_id
from market_fact_full
group by Cust_id
order by count( Cust_id) desc
limit 1);

-- 4. Print the three most common products.
select Product_Category,Product_Sub_Category
from prod_dimen
where Prod_id in ( 
select Prod_id 
from market_fact_full
group by Prod_id
order by count( Prod_id) desc
)limit 3;

-- -----------------------------------------------------------------------------------------------------------------
-- CTEs

-- 1. Find the 5 products which resulted in the least losses. Which product had the highest product base
-- margin among these?
select Prod_id,Profit,Product_Base_Margin
from market_fact_full
where Profit < 0
order by Profit desc 
limit 5;
 
with least_losses as (select Prod_id,Profit,Product_Base_Margin
from market_fact_full
where Profit < 0
order by Profit desc 
limit 5)
select *
from least_losses
where Product_Base_Margin = (
select max(Product_Base_Margin)
from least_losses);
-- 2. Find all low-priority orders made in the month of April. Out of them, how many were made in the first half of
-- the month?
with low_priority_orders as (
select *
from orders_dimen
where Order_Priority = 'low' and month(Order_Date) = 4)
select count(Ord_id) as order_count
from low_priority_orders
where day(Order_Date) between 1 and 15;

-- -----------------------------------------------------------------------------------------------------------------
-- Views

-- 1. Create a view to display the sales amounts, the number of orders, profits made and the shipping costs of all
-- orders. Query it to return all orders which have a profit of greater than 1000.
create view order_info as 
select Ord_id,Sales,Order_Quantity,Profit,Shipping_Cost
from market_fact_full;

select Ord_id,Profit
from order_info
where Profit>1000;
-- 2. Which year generated the highest profit?
create view market_fact_and_orders as 
select *
from market_fact_full
inner join orders_dimen
using(Ord_id);

select sum(profit) as Year_wise_profit, year(Order_Date) as order_year
from market_fact_and_orders
group by order_year
order by Year_wise_profit desc
limit 1;
-- select (attributes)
-- from (table)
-- where (filter_condition)
-- group by (attributes_to_be_grouped_upon)
-- having (filter_condition_on_grouped_values)
-- order by (values)
-- limit (no_of_values_to_display);  
-- -----------------------------------------------------------------------------------------------------------------
-- Session: Joins and Set Operations
-- Inner Join

-- 1. Print the product categories and subcategories along with the profits made for each order.
select Ord_id,Product_Category,Product_Sub_Category,Profit
from prod_dimen p 
inner join market_fact_full m
-- using(Prod_id)
on p.Prod_id = m.Prod_id;
-- 2. Find the shipment date, mode and profit made for every single order.
select Ord_id,Ship_Mode,Ship_Date,Profit
from market_fact_full m
inner join shipping_dimen s
using(Ship_id);

-- 3. Print the shipment mode, profit made and product category for each product.
select m.Prod_id,m.Profit,p.Product_Category,s.Ship_Mode
from market_fact_full m inner join prod_dimen p using (Prod_id)
inner join shipping_dimen s on m.Ship_id=s.Ship_id;
-- 4. Which customer ordered the most number of products?
select Customer_Name,sum(Order_Quantity) as total_order
from cust_dimen 
inner join market_fact_full 
using(Cust_id)
group by Customer_Name
order by total_order desc ;
-- 5. Selling office supplies was more profitable in Delhi as compared to Patna. True or false?
select Product_Category,City, sum(Profit) as city_wise_profit
from prod_dimen p
inner join market_fact_full m using (Prod_id)
inner join cust_dimen c on  m.Cust_id=c.Cust_id 
where Product_Category = 'Office_supplies' and (City = 'Delhi' or City = 'Patna')
group by City;
-- 6. Print the name of the customer with the maximum number of orders.
select Customer_Name, sum(Order_Quantity) as No_Of_Orders
from cust_dimen c
inner join market_fact_full m
on c.cust_id = m.cust_id
group by Customer_Name
order by No_Of_Orders desc
limit 1;
-- 7. Print the three most common products.
select Product_Category, Product_Sub_Category,Order_Quantity
from prod_dimen p
inner join market_fact_full m
on p.Prod_id = m.Prod_id
group by Product_Sub_Category
order by Order_Quantity desc
limit 3;

-- -----------------------------------------------------------------------------------------------------------------
-- Outer Join

-- 1. Return the order ids which are present in the market facts table.

-- Execute the below queries before solving the next question.
create table manu (
	Manu_Id int primary key,
	Manu_Name varchar(30),
	Manu_City varchar(30)
);

insert into manu values
(1, 'Navneet', 'Ahemdabad'),
(2, 'Wipro', 'Hyderabad'),
(3, 'Furlanco', 'Mumbai');

alter table Prod_Dimen
add column Manu_Id int;

update Prod_Dimen
set Manu_Id = 2
where Product_Category = 'technology';

-- 2. Display the products sold by all the manufacturers using both inner and outer joins.
select * from manu;
select distinct Manu_Id from prod_dimen;

select Manu_Name,Prod_id
from manu
inner join prod_dimen using(Manu_Id);

select Manu_Name,Prod_id
from manu m 
left join prod_dimen p on m.Manu_Id=p.Manu_Id;
-- 3. Display the number of products sold by each manufacturer.
select Manu_Name,count(Prod_id)
from manu m 
left join prod_dimen p on m.Manu_Id=p.Manu_Id
group by Manu_Name;

select Manu_Name,count(Prod_id)
from manu m 
inner join prod_dimen p on m.Manu_Id=p.Manu_Id
group by Manu_Name;
-- 4. Create a view to display the customer names, segments, sales, product categories and
-- subcategories of all orders. Use it to print the names and segments of those customers who ordered more than 20
-- pens and art supplies products.
create view order_details as 
select Customer_Name,Customer_Segment,Order_Quantity,round(Sales),Product_Category,Product_Sub_Category
from cust_dimen c
inner join market_fact_full m on c.Cust_id=m.Cust_id
inner join prod_dimen p on m.Prod_id=p.Prod_id;

select  *
from order_details
where Order_Quantity > 20 and Product_Sub_Category = 'PENS & ART SUPPLIES'
group by Customer_Name;
-- -----------------------------------------------------------------------------------------------------------------
-- Union, Union all, Intersect and Minus

-- 1. Combine the order numbers for orders and order ids for all shipments in a single column.
(select Order_Number
from orders_dimen
order by Order_Number
)
Union all
(select Order_ID
from shipping_dimen
order by Order_ID
);
-- 2. Return non-duplicate order numbers from the orders and shipping tables in a single column.
(select Order_Number
from orders_dimen
order by Order_Number
)
Union 
(select Order_ID
from shipping_dimen
order by Order_ID
);
-- 3. Find the shipment details of products with no information on the product base margin.
SELECT Ship_id,Product_Base_Margin
FROM shipping_dimen
LEFT JOIN market_fact_full using(Ship_id) 
WHERE Product_Base_Margin IS NULL
order by Ship_id;
-- 4. What are the two most and the two least profitable products?

(select Prod_id,sum(Profit)
from market_fact_full
group by Prod_id
order by sum(Profit) desc
limit 2)
union 
(select Prod_id,sum(Profit)
from market_fact_full
group by Prod_id
order by sum(Profit)
limit 2);
-- -----------------------------------------------------------------------------------------------------------------
-- Module: Advanced SQL
-- Session: Window Functions	
-- Window Functions in Detail

-- 1. Rank the orders made by AARON BERGMAN in the decreasing order of the resulting sales.
select Ord_id,round(Sales) as rounded_sales ,Customer_Name,Cust_id,
rank () over ( order by Sales desc) as sale_amount_rank
from market_fact_full
inner join cust_dimen using (Cust_id)
where Customer_Name = 'AARON BERGMAN';
 -- top 5 orders made by AARON BERGMAN
with rank_info as (
select Ord_id,round(Sales) as rounded_sales ,Customer_Name,Cust_id,
rank () over ( order by Sales desc) as sale_amount_rank
from market_fact_full
inner join cust_dimen using (Cust_id)
where Customer_Name = 'AARON BERGMAN')

select *
from rank_info
where sale_amount_rank <=5;
-- 2. For the above customer, rank the orders in the increasing order of the discounts provided. Also display the
-- dense ranks.
select Ord_id,Customer_Name,Discount,
rank() over( order by Discount ) as sale_amount_rank,
dense_rank() over ( order by Discount ) as Discount_dense_rank
from market_fact_full
inner join cust_dimen using (Cust_id)
where Customer_Name = 'AARON BERGMAN';


with rank_info as (
select Ord_id,Customer_Name,Discount,
rank() over( order by Discount ) as sale_amount_rank,
dense_rank() over ( order by Discount ) as Discount_dense_rank
from market_fact_full
inner join cust_dimen using (Cust_id)
where Customer_Name = 'AARON BERGMAN')
select *
from rank_info
where sale_amount_rank <=5;
-- 3. Rank the customers in the decreasing order of the number of orders placed.
select Customer_Name,Cust_id,Order_Quantity,count(Ord_id) as order_count,
rank () over ( order by count(Ord_id) desc ) as Order_count_rank
from market_fact_full
inner join cust_dimen using (Cust_id)
group by Customer_Name;

-- 4. Create a ranking of the number of orders for each mode of shipment based on the months in which they were
-- shipped. 
select Ship_Mode,count(Order_ID),month(Ship_Date),
rank () over ( order by count(Order_ID) ) as Order_count_rank
from shipping_dimen
group by month(Ship_Date);
-- -------------------------------------------------------------------------------------------------------------
select * ,ROW_NUMBER() OVER (ORDER BY Ship_Date) as row_num 
from shipping_dimen;

select *
from market_fact_full
ORDER BY Cust_id;
-- Another important rank function is row_number(). You can read more about it here.
-- https://www.mysqltutorial.org/mysql-window-functions/mysql-row_number-function/
select ROW_NUMBER() OVER (ORDER BY Ship_Date) as row_num ,
Ship_id ,Order_ID ,Ship_Mode ,Ship_Date 
from shipping_dimen;
-- Removing duplicate rows
CREATE TABLE t (
    id INT,
    name VARCHAR(10) NOT NULL
);

INSERT INTO t(id,name) 
VALUES(1,'A'),
      (2,'B'),
      (2,'B'),
      (3,'C'),
      (3,'C'),
      (3,'C'),
      (4,'D');
      
  WITH dups AS (SELECT 
        id,
        name,
        ROW_NUMBER() OVER(PARTITION BY id, name ORDER BY id) AS row_num
    FROM t)

DELETE FROM t USING t JOIN dups ON t.id = dups.id
WHERE dups.row_num <> 1;    
-- --------------------------------------------------------------------------------------------------
-- find out the rank of Ship_Mode for each Ship_Mode using the 'partition' and overall rank
with ship_table as
(
select Ship_Mode,month(Ship_Date) as ship_month ,count(*) as number_shipment
from shipping_dimen
group by month(Ship_Date),Ship_Mode
order by Ship_Mode , month(Ship_Date)
)
select *,
rank() over(PARTITION BY Ship_Mode order by number_shipment  desc) as shipment_PARTITION_rank,
rank() over ( order by number_shipment desc) as shipment_overall_rank
from ship_table;

-- -----------------------------------------------------------------------------------------------------------------
-- Named Windows

-- 1. Rank the orders in the increasing order of the shipping costs for all orders placed by Aaron Smayling. Also
-- display the row number for each order.
select Ord_id,Customer_Name,Discount,
ROW_NUMBER() OVER w as discount_row_num ,
rank() over w as discount_rank,
dense_rank() over w as Discount_dense_rank
from market_fact_full
inner join cust_dimen using (Cust_id)
where Customer_Name = 'AARON BERGMAN'
window w as (order by Discount desc);

-- -----------------------------------------------------------------------------------------------------------------
-- Frames

-- 1. Calculate the month-wise moving average shipping costs of all orders shipped in the year 2011.
select Shipping_Cost,month(Ship_Date) as ship_month ,year(Ship_Date) as ship_year,
avg(Shipping_Cost) over ( order by month(Ship_Date),year(Ship_Date) rows unbounded preceding) as moving_average,
avg(Shipping_Cost) over ( order by month(Ship_Date),year(Ship_Date) rows 9 preceding) as shipment_prev10_avg
from market_fact_full
inner join shipping_dimen using (Ship_id);
-- -----------------------------------------------------------------------------------------------------------------
-- Session: Programming Constructs in Stored Functions and Procedures
-- IF Statements

-- 1. Classify an order as 'Profitable' or 'Not Profitable'.
select Market_fact_id,Profit,
(case 
when Profit > 0 then ' Profitable'
else 'Not Profitable'
end) as market_fact_report
from market_fact_full

-- -----------------------------------------------------------------------------------------------------------------
-- CASE Statements

-- 1. Classify each market fact in the following ways:
--    Profits less than -500: Huge loss
--    Profits between -500 and 0: Bearable loss 
--    Profits between 0 and 500: Decent profit
--    Profits greater than 500: Great profit
select Market_fact_id,Profit,
(case 
when Profit< -500 then ' huge loss'
when Profit between -500 and 0 then ' bearable loss'
when Profit between 0 and 500 then 'decent profit'
else 'great profit'
end) as market_fact_report
from market_fact_full
-- 2. Classify the customers on the following criteria (TODO)
--    Top 20% of customers: Gold
--    Next 35% of customers: Silver
--    Next 45% of customers: Bronze
with raw_file as 
( 
	with raw_data as 
    (
    select c.Cust_id,c.Customer_Name,round(Sales) as total_sale
    from market_fact_full m
    inner join cust_dimen c
    on m.Cust_id=c.Cust_id
    group by c.Cust_id
    order by total_sale desc
    )
	select *,
    percent_rank() over (order by total_sale desc) as 'rank1'
    from raw_data
    )
   select * ,
   (case 
	when rank1 < 0.2 then ' Gold'
	when rank1 between 0.2 and 0.55 then ' Silver'
	else 'Bronze'
	end) as customer_type
	from raw_file;
-- -----------------------------------------------------------------------------------------------------------------
-- Stored Functions

-- 1. Create and use a stored function to classify each market fact in the following ways:
--    Profits less than -500: Huge loss
--    Profits between -500 and 0: Bearable loss 
--    Profits between 0 and 500: Decent profit
--    Profits greater than 500: Great profit
delimiter $$
create function productstatus(profit int)
returns varchar(25) deterministic
begin 
declare  market_fact_report varchar(25);
if Profit< -500 then
set market_fact_report= ' huge loss';
elseif Profit between -500 and 0 then
set market_fact_report= ' bearable loss';
elseif Profit between 0 and 500 then
set market_fact_report= 'decent profit';
else 
set market_fact_report= 'great profit';
end if;
return  market_fact_report;
end ; $$
delimiter ;

select Market_fact_id,Profit, productstatus(profit) as market_fact_report
from market_fact_full;
-- -----------------------------------------------------------------------------------------------------------------

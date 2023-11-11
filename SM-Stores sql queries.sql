-- SM-STORE PROJECT

-- QUESTIONS AND ANSWERS

-- 1. How many records are in SM-Stores Orders table

select count(*)
from orders;


-- 2. How many Cities does SM-stores have properties in.

select count(distinct "PropertyCity")
from propertyinfo;


-- 3. What are the product categories offered by SM-Stores.

select distinct("ProductCategory")
from products;


 --4. How many products belong to each category.

select "ProductCategory", count("ProductName") as num_of_products
from products
group by "ProductCategory"
order by num_of_products;

-- 5. A customer has requested for a refund claiming they procured goods from the store. 
--   Provide all the details of this order if the OrderID is = ‘3896’

select "OrderID", "OrderDate", orders."ProductID", "ProductName", "ProductCategory", "Quantity", "Price", "PropertyCity", "PropertyState"
from orders
inner join products
on orders."ProductID" = products."ProductID"
inner join propertyinfo
on orders."PropertyID" = propertyinfo."PropID"
where "OrderID" = 3896;


-- 6. How many orders were placed in each date stated in the orders table.

select "OrderDate", count("OrderID") as num_of_orders_by_date
from orders
group by "OrderDate"
order by num_of_orders_by_date desc;


-- 7.  Can you process the number of orders we had in each year of SM-stores data.

select EXTRACT(YEAR FROM "OrderDate") as year, count("OrderID") as num_of_orders_by_year
from orders
group by year
order by num_of_orders_by_year desc;


-- 7b. in each month for the year 2016

select EXTRACT(YEAR FROM "OrderDate") as year, EXTRACT(month FROM "OrderDate") as month, count("OrderID") as num_of_orders_by_month
from orders
where EXTRACT(year from "OrderDate") = 2016
group by month, year
order by month;


--8. What was the total sales derived from each product category for the
--   year 2016?

select extract(year from "OrderDate") as year, "ProductCategory", sum("Quantity" * "Price") as total_sales
from orders
inner join products
on orders."ProductID" = products."ProductID"
where extract(year from "OrderDate") = 2016
group by "ProductCategory", year
order by total_sales desc;


/* 9. SM-stores wants to re-evaluate the prices of their goods, provide a list of their 
      products, categories and the corresponding prices.
      Group their products into categories: cheap, affordable, expensive
*/

select "ProductName", "ProductCategory", "Price",
   CASE
	   WHEN "Price" < 50 THEN 'cheap'
	   WHEN "Price" < 100 THEN 'affordable'
	   ELSE 'expensive'
   END as price_categories
from products;


-- 10. Which category  has the highest sales in each year .

select EXTRACT(YEAR FROM "OrderDate") as year, "ProductCategory", sum("Quantity" * "Price") as total_sales
from orders
inner join products
on orders."ProductID" = products."ProductID"
group by year, "ProductCategory"
order by total_sales desc
limit 2;


-- 11a. Which State has the most properties ordered. 


select count("PropID") as total_property, "PropertyState", sum("Quantity" * "Price") as sales
from orders
inner join propertyinfo
on orders."PropertyID" = propertyinfo."PropID"
inner join products
on orders."ProductID" = products."ProductID"
group by "PropertyState"
order by total_property desc;

-- 11b. Return the sales for each state.(sales>25000)

select "PropertyState", sum("Quantity" * "Price") as sales
from orders
inner join propertyinfo
on orders."PropertyID" = propertyinfo."PropID"
inner join products
on orders."ProductID" = products."ProductID"
group by "PropertyState"
having sum("Quantity" * "Price") > 25000
order by sales desc;


--12. What is the average cost of a ‘Coffee Maker’ located in Texas.

select "ProductName", "PropertyState", round(avg("Price")) as avg_cost
from orders
inner join propertyinfo
on orders."PropertyID" = propertyinfo."PropID"
inner join products
on orders."ProductID" = products."ProductID"
where "ProductName" = 'Coffee Maker' and "PropertyState" = 'Texas'
group by "PropertyState", "ProductName";


--13. Which month in the year 2015 had the highest orders. Calculate the corresponding 
--    sales.

select extract(month from "OrderDate") as month, count("OrderID") as total_order
from orders
where extract(year from "OrderDate") = 2015
group by month
order by total_order desc
limit 1;

--13b. Calculate the corresponding sales

select 
       extract(month from "OrderDate") as month, 
	   count("OrderID") as total_order, 
	   sum("Quantity" * "Price") as sales
from orders
join products
on orders."ProductID" = products."ProductID"
where extract(year from "OrderDate") = 2015
group by month
order by total_order desc
limit 1;


-- 14. Return all orders where the quantity ordered is above 5

select "OrderID", "Quantity" as quantity_above_5
from orders
where "Quantity" > 5;


--15. Find the top 5 most expensive products and the 5 least expensive products

select "ProductName", "Price" as top5_most_expensive
from products
order by "Price" desc
limit 5;

select "ProductName", "Price" as five_least_expensive
from products
order by "Price" asc
limit 5;


-- 16. Find the number of Permanent Markers, ‘Sticky Notes’ and ‘Note Pads’ ordered for each year

select extract(year from "OrderDate") as year, "ProductName", count("OrderID") as num_of_orders
from orders
join products
on orders."ProductID" = products."ProductID"
where "ProductName" in ('Permanent Markers', 'Sticky Notes', 'Note Pads')
group by extract(year from "OrderDate"), "ProductName"
order by "ProductName";
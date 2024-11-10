use campusx;
 ## Swiggy Case Study 
 
select * from users;
select * from restaurants;
select * from food;
select * from menu;
select * from orders;
select * from delivery_partner;
select * from order_details;

-- 1. Find customers who have never ordered
select name from users where user_id not in(select distinct(user_id) from orders);

-- 2. Average Price/dish 
select f.f_name,round(avg(price),2) as "avg_price"
from food f 
join menu m on m.f_id = f.f_id 
group by f.f_name;

-- 3. Find the top restaurant in terms of the number of orders for a given month
select o.r_id ,r.r_name,monthname(date) as `month` ,count(*) from restaurants r
join orders o on r.r_id=o.r_id 
group by `month`,o.r_id ,r.r_name
order by count(*) desc limit 1;

-- 4.restaurants with monthly sales greater than x for 
select r_name,sum(amount) as "revenue" from orders o
join restaurants r 
on  o.r_id=r.r_id 
where monthname(date)='june' 
group by r_name 
having revenue>500;

-- 5. Show all orders with order details for a particular customer in a particular date range
SELECT o.order_id, r.r_name, f.f_name
FROM orders o
JOIN restaurants r ON r.r_id = o.r_id
JOIN order_details od ON o.order_id = od.order_id
JOIN food f ON f.f_id = od.f_id
WHERE o.user_id = (SELECT user_id FROM users WHERE `name` LIKE "Ankit")
  AND o.date > '2022-06-10' 
  AND o.date < '2022-07-10';
  
-- 6. Find restaurants with max repeated customers 
SELECT r.r_name, COUNT(*) AS loyal_customers
FROM (
    SELECT r_id, user_id, COUNT(*) AS visits
    FROM orders
    GROUP BY r_id, user_id
    HAVING visits > 1
) AS t
JOIN restaurants r ON r.r_id = t.r_id
GROUP BY r.r_name
ORDER BY loyal_customers DESC
LIMIT 1;


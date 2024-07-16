--Retrieve the total number of orders placed.

select count(order_id) as Total_orders from orders;

-- Calculate the total revenue generated from pizza sales.

select round(sum(order_details.quantity * pizzas.price),2) as revenue from order_details join pizzas
on order_details.pizza_id = pizzas.pizza_id;


-- Identify the highest-priced pizza.

select pizza_types.name, pizzas.price as price from pizza_types join pizzas 
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by price desc limit 1;


-- Identify the most common pizza size ordered.

select pizzas.size, sum(order_details.quantity) as quantity from pizzas join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size
order by quantity desc limit 1;


-- List the top 5 most ordered pizza types along with their quantities.

select pizza_types.name, sum(order_details.quantity) as Total from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id join order_details 
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name
order by total desc limit 5;  


-- Join the necessary tables to find the total quantity of each pizza category ordered.

select pizza_types.category, sum(order_details.quantity) as quantity from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id join order_details 
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category;


-- Determine the distribution of orders by hour of the day.

select hour(order_time) as hours, count(order_id) as orders from orders
group by hours;


-- Join relevant tables to find the category-wise distribution of pizzas.

select category,count(name) as types_of_pizzas from pizza_types
group by category;


-- Group the orders by date and calculate the average number of pizzas ordered per day.


select orders.order_date, sum(order_details.quantity) as quantity from orders join order_details
on orders.order_id = order_details.order_id
group by orders.order_date;

-- Here, we got total quantities of pizza from each day
-- Now, we need to find the average from each day

select round(avg(quantity),2) as average from
(select orders.order_date, sum(order_details.quantity) as quantity from orders join order_details
on orders.order_id = order_details.order_id
group by orders.order_date) as details;


-- Determine the top 3 most ordered pizza types based on revenue.

select pizza_types.name, sum(order_details.quantity * pizzas.price) as revenue
from pizza_types join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name
order by revenue desc limit 3;


-- Calculate the percentage contribution of each pizza type to total revenue.

select pizza_types.name, 
round(sum(order_details.quantity * pizzas.price) / (select sum(order_details.quantity * pizzas.price)
 from order_details join pizzas 
 on order_details.pizza_id = pizzas.pizza_id) * 100,2) as total_revenue
 
from pizza_types join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id 
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name;


-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select pizza_types.name, pizza_types.category, sum(order_details.quantity * pizzas.price) as revenue from pizza_types
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category, pizza_types.name
order by revenue desc limit 3;

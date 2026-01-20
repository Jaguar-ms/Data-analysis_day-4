create database northwind;
use northwind;

-- Customer Table
create table customers(
	customer_id varchar(10) primary key unique,
    company_name varchar(100),
    contact_name varchar(100),
    country varchar(50)
    );
  
-- Order Table

create table orders(
	order_id int primary key unique,
    customer_id varchar(10),
    order_date date,
    ship_country varchar(50),
    foreign key (customer_id)
    references customers(customer_id)
    );
    
-- categories Table

create table categories(
	category_id int primary key unique,
    category_name varchar(50)
    );
    
-- Product Table

create table  products(
	product_id int primary key unique,
    product_name varchar(100),
    category_id int,
    unit_Price decimal(10,2),
    foreign key (category_id)
    references categories(category_id)
    );
    
-- Order details Table

create table order_details(
	order_id int,
    product_id int,
    unit_price decimal(10,2),
    quantity int,
    discount decimal(4,2),
    foreign key (order_id) references orders(order_id),
    foreign key (product_id) references products(product_id)
    );
/*   
select count(*) from customers;
select count(*) from orders;
select count(*) from categories;
select count(*) from products;
select count(*) from order_details;*/

alter table orders
modify order_date date;

#inner join: orders with customers
select
	o.order_id,
    o.order_date,
    c.customer_id,
    c.customer_name,
    c.country
from orders o
INNER JOIN customers c
	on o.customer_Id = c.customer_id;

select count(*) from orders;

#LEFT JOIN : cusotmers with no order

select
	c.customer_id,
	c.customer_name,
	c.country
        
from customers c 
LEFT JOIN orders o
	on c.customer_id = o.customer_id
where o.order_id is null;

#revenue per product

select
	p.product_id,
    p.product_name,
    round(sum(od.unit_price * od.quantity * (1 - od.discount)), 2) as total_revenue
from order_details od
INNER JOIN products p
	on od.product_id = p.product_id
Group by p.product_id, p.product_name
order by total_revenue DESC;

#revenue by category
select 
	c.category_name,
    round(sum(od.unit_price * od.quantity * (1 - od.discount)), 2) as category_revenue
from order_details od
INNER JOIN products p
	on od.product_id = p.product_id
INNER JOIN categories c
	on p.category_id = c.category_id
group by c.category_name
order by category_revenue DESC;

#Sales in USA from start and end of 1997
select
	o.order_id,
    o.order_date,
    c.country,
    round(Sum(od.unit_price * od.quantity), 2) as order_value
from orders o 
INNER JOIN customers c
	on o.customer_id = c.customer_id
INNER JOIN order_details od
	on o.order_id = od.order_Id
where c.country = 'USA'
	and o.order_date between '1997-01-01' and '1997-12-31'

group by o.order_id, o.order_date,c.country;




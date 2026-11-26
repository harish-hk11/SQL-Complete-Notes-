-- Active: 1785129076134@@127.0.0.1@3306@subquery_practice
create database subquery_practice;
use subquery_practice;

drop table if exists order_items;
drop table if exists orders;
drop table if exists products;
drop table if exists customers;
drop table if exists employees;

create table customers (customer_id int primary key,customer_name varchar(50),city varchar(50),signup_date date);
create table products (product_id int primary key,product_name varchar(50),category varchar(50),price decimal(10,2));
create table orders (order_id int primary key,customer_id int,order_date date,status varchar(20),total_amount decimal(10,2));
create table order_items (item_id int primary key,order_id int,product_id int,quantity int);
create table employees (emp_id int primary key,emp_name varchar(50),department varchar(50),salary decimal(10,2),manager_id int,hire_date date);

insert into customers values
(1,'Arun Kumar','Chennai','2024-01-10'),
(2,'Priya Nair','Kochi','2024-02-14'),
(3,'Rahul Verma','Delhi','2024-03-05'),
(4,'Sneha Iyer','Chennai','2024-03-21'),
(5,'Vikram Singh','Mumbai','2024-04-09'),
(6,'Meena Das','Kolkata','2024-05-17'),
(7,'Karthik Raj','Coimbatore','2024-06-02'),
(8,'Anita Joshi','Mumbai','2024-06-25'),
(9,'Farhan Ali','Delhi','2024-07-13'),
(10,'Divya Menon','Kochi','2024-08-01');

insert into products values
(1,'Laptop','Electronics',55000),
(2,'Smartphone','Electronics',30000),
(3,'Headphones','Electronics',3500),
(4,'Office Chair','Furniture',8500),
(5,'Desk','Furniture',12000),
(6,'Notebook','Stationery',120),
(7,'Pen Set','Stationery',450),
(8,'Backpack','Accessories',1800),
(9,'Water Bottle','Accessories',600),
(10,'Monitor','Electronics',14000),
(11,'Tablet','Electronics',22000),
(12,'Standing Desk','Furniture',25000);

insert into orders values
(1,1,'2024-02-01','Delivered',58500),
(2,1,'2024-03-12','Delivered',2100),
(3,2,'2024-03-20','Delivered',30000),
(4,3,'2024-04-02','Delivered',17000),
(5,3,'2024-05-10','Cancelled',20500),
(6,4,'2024-05-28','Delivered',3000),
(7,5,'2024-06-15','Delivered',28000),
(8,5,'2024-07-04','Shipped',7000),
(9,5,'2024-08-19','Delivered',2400),
(10,6,'2024-09-03','Delivered',33500),
(11,7,'2024-09-21','Shipped',55000),
(12,7,'2024-10-08','Cancelled',1800),
(13,8,'2024-11-11','Delivered',2250),
(14,2,'2024-12-02','Delivered',3600),
(15,1,'2025-01-14','Delivered',14000);

insert into order_items values
(1,1,1,1),(2,1,3,1),
(3,2,6,10),(4,2,7,2),
(5,3,2,1),
(6,4,4,2),
(7,5,5,1),(8,5,4,1),
(9,6,8,1),(10,6,9,2),
(11,7,10,2),
(12,8,3,2),
(13,9,6,20),
(14,10,2,1),(15,10,3,1),
(16,11,1,1),
(17,12,9,3),
(18,13,7,5),
(19,14,8,2),
(20,15,10,1);

insert into employees values
(1,'Ramesh Kumar','Management',150000,null,'2019-01-15'),
(2,'Lakshmi Devi','Sales',90000,1,'2020-03-10'),
(3,'Suresh Babu','Sales',60000,2,'2021-06-01'),
(4,'Anjali Rao','Sales',60000,2,'2022-01-20'),
(5,'Mohan Das','IT',95000,1,'2020-07-05'),
(6,'Kavya Reddy','IT',70000,5,'2021-09-15'),
(7,'Naveen Pillai','IT',72000,5,'2023-02-01'),
(8,'Pooja Sharma','HR',65000,1,'2021-11-30'),
(9,'Arjun Mehta','HR',48000,8,'2023-05-12'),
(10,'Divakar S','Support',42000,2,'2023-08-18');

-- subquery : query inside another query.
-- inner query produce a result, outer query use result to run its job.

-- scalar subquery : returns only one value.

-- 1. List the products that are cheaper than the average product price.
select product_id, product_name,category,price
from products
where price < (select avg(price) from products);

-- 2. List the customers who signed up after Meena Das.
select customer_id, customer_name, city, signup_date 
from customers 
where signup_date > (select signup_date from customers where customer_name = 'Meena Das');

-- 3. Find the order with the highest total_amount.
select order_id,customer_id,order_date,status,total_amount
from orders
where total_amount = (select max(total_amount) from orders);

-- 4. List the employees who earn less than the average salary.
select emp_id,emp_name,department,salary,manager_id,hire_date
from employees
where salary < (select avg(salary) from employees);

-- 5.Find the most recently hired employee.
select emp_id,emp_name,department,salary,hire_date
from employees
where hire_date = (select max(hire_date) from employees);

-- 6.List the orders whose total_amount is above the average total of Delivered orders only
select order_id,customer_id,order_date,status,total_amount
from orders
where total_amount > (select avg(total_amount) from orders where status = 'Delivered' );

-- A multi-row subquery returns a list of values (one column, many rows)

-- IN -	matches any value in the list
-- products that were ordered
select product_id, product_name from products 
where product_id in (select product_id from order_items);

-- NOT IN (products never ordered)
select product_id, product_name from products 
where product_id not in (select product_id from order_items);

-- ANY (earns more than at least one IT employee)
select * from employees where salary > any(select salary from employees where department = 'IT');

-- ALL (earns more than every IT employee)
select * from employees where salary > all(select salary from employees where department = 'IT');

-- If the list contains a NULL, NOT IN returns no rows at all. Try this:
select emp_name from employees where emp_id not in (select manager_id from employees);

-- use where to filter out nulls
select emp_name from employees where emp_id not in (select manager_id from employees where manager_id is not null);

-- 1.List the customers who have placed at least one order.
select * from customers where customer_id in (select customer_id from orders);

-- 2.List the customers who have never placed an order.
select * from customers where customer_id not in (select customer_id from orders);

-- 3.List the products that appear in Cancelled orders (you need order_items and orders).
select product_id,product_name from products 
where product_id in (select product_id from order_items where order_id in (select order_id from orders where status='Cancelled'));

-- 4.List the customers who live in the same cities as customers who placed Shipped orders.
select customer_id,customer_name,city from customers 
where city in (select city from customers where customer_id in 
(select customer_id from orders where status='Shipped'));

-- 5.List the employees who are managers.
select * from employees
where emp_id in (select manager_id from employees where manager_id is not null);

-- 6.List the employees who are not managers (watch the NULL).
select * from employees
where emp_id not in (select manager_id from employees where manager_id is not null);

-- 7.List the employees who earn more than ANY Sales employee.
select * from employees
where salary > any(select salary from employees where department = 'Sales');

-- 8.List the employees who earn more than ALL HR employees.
select * from employees
where salary > all(select salary from employees where department = 'HR');

-- Subquery in FROM
-- When a subquery sits in the FROM clause, its result acts as a temporary table for the outer query. This is called a derived table.

-- average of per-customer total spending
select avg(total_spent) as avg_spend 
from (select customer_id,sum(total_amount) as total_spent 
from orders group by customer_id) t;

-- join a derived table with a normal table
select c.customer_name,t.total_spent from customers c
join (select customer_id,sum(total_amount) as total_spent from orders group by customer_id) t 
on c.customer_id=t.customer_id where t.total_spent>30000;

-- aggregate of an aggregate (the highest department average)
select max(avg_sal) from (select department,avg(salary) as avg_sal from employees group by department) d;


-- 1.Find the average number of orders per customer (only customers who placed orders).
select avg(order_count) from (select customer_id , count(order_id) as order_count from orders group by customer_id having count(order_id) >= 1)c;

-- 2.Show each customer’s name and number of orders, only for customers with more than 1 order (derived table joined to customers).
select customer_name , number_of_orders 
from customers c join (select customer_id , count(order_id) as number_of_orders from orders group by customer_id having count(order_id) > 1) t 
on c.customer_id = t.customer_id
group by customer_name,number_of_orders;


-- 3.Show each department with its average salary, only departments whose average is above 65000, using a derived table.
select department,avg_sal from (select department,avg(salary) as avg_sal 
from employees group by department) d where avg_sal>65000;

-- 4.Find the department name with the highest average salary.
select department,avg_sal from (select department,avg(salary) as avg_sal from employees group by department) d order by avg_sal desc limit 1;

-- 5.For each product category, find the total quantity sold (join order_items and products inside the derived table), then show only the categories with total quantity above 10.
select category,total_qty from (select p.category,sum(oi.quantity) as total_qty
from order_items oi join products p on oi.product_id=p.product_id 
group by p.category)t where total_qty>10;

-- 6.Show each city with its customer count, then list only the cities that have more than 1 customer.
select city, total_customers
from (select city, count(customer_id) as total_customers from customers group by city having count(customer_id) > 1)
customers;

-- Subquery in SELECT
-- A subquery in the SELECT list adds a calculated column to every row of the outer query.

-- independent (the same value on every row)
select product_name,price,(select avg(price) from products) as avg_price from products;

-- use it in a calculation
select product_name,price,price-(select avg(price) from products) as diff_from_avg from products;

-- correlated (a different value per row)
select c.customer_name,(select count(*) from orders o where o.customer_id=c.customer_id) as order_count from customers c;

-- 1.Show each employee’s name, salary and the company’s average salary as a column.
select emp_name,salary,(select avg(salary) from employees) as company_avg_sal from employees;

-- 2.Show each employee’s name, salary and how much above or below the average they are
select emp_name,salary,salary - (select avg(salary) from employees) as sal_avg_range from employees;

-- 3.Show each customer’s name and their number of orders, including customers with 0.
select c.customer_name,(select count(order_id) from orders o where o.customer_id = c.customer_id) as total_orders from customers c;

-- 4.Show each customer’s name and their total spending (total_amount), showing 0 instead of NULL for customers with no orders.
select c.customer_name,(select coalesce(sum(total_amount),0) from orders o where o.customer_id = c.customer_id) as total_spendings
from customers c;

-- 5.Show each product’s name, price and the highest price in its own category.
select p.product_name,p.price,(select max(p2.price) from products p2 where p2.category=p.category) 
as cat_high_price from products p;

-- 6.Show each order’s order_id, total_amount and the number of items (rows in order_items) in that order.
select o.order_id,o.total_amount,(select count(item_id) from order_items oi where o.order_id = oi.order_id) as
number_of_items from orders o;

-- 7.Show each department (distinct) with its number of employees, using a subquery in SELECT.
select distinct e.department,(select count(*) from employees e2 where e2.department=e.department) as total_employees 
from employees e;

-- Correlated Subquery :A correlated subquery refers to a column of the outer query. It can’t run on its own, because it depends on the outer row.

-- Example 1: employees earning more than their own department’s average
select emp_name,department,salary from employees e
where salary>(select avg(salary) from employees e2 where e2.department=e.department);

-- Example 2: the most recent order of each customer
select order_id,customer_id,order_date from orders o where order_date=(select max(order_date) from orders o2 where o2.customer_id=o.customer_id);


-- 1.List the employees who earn the highest salary in their own department.
select emp_name ,department, salary from employees e 
where salary = (select max(salary) from employees e2 where e2.department = e.department);

-- 2.List the products priced above the average price of their own category.
select product_id,product_name,category, price from products p
where price > (select avg(price) from products p2 where p2.category = p.category);

-- 3.List the orders whose total_amount is above the average order total of the same customer.
select order_id,customer_id,total_amount from orders o
where total_amount > (select avg(total_amount) from orders o2 where o2.customer_id = o.customer_id);

-- 4.List the employees who were hired earliest in their own department.
select emp_id,emp_name,department,hire_date from employees e
where hire_date = (select min(hire_date) from employees e2 where e2.department = e.department);

-- 5.List the employees who earn the same salary as another employee in the same department (the person must not match themselves).
select emp_id,emp_name,department,salary from employees e where salary in (select salary from employees e2 where e2.department=e.department and e2.emp_id<>e.emp_id);

-- 6.List the employees who earn more than their own manager. Think about what result you expect before you run it.
select e.emp_id,e.emp_name,e.salary from employees e where e.salary>(select m.salary from employees m where m.emp_id=e.manager_id);

-- 7.For each customer, list their most expensive order (highest total_amount).
select order_id,customer_id,total_amount from orders o 
where total_amount = (select max(total_amount) from orders o2 where o2.customer_id = o.customer_id);

-- EXISTS vs NOT EXISTS : EXISTS checks whether a subquery returns at least one row. It gives TRUE if a row exists and FALSE if not. NOT EXISTS is the opposite.

-- Example 1: customers who placed at least one order
select customer_id,customer_name from customers c 
where exists (select 1 from orders o where o.customer_id=c.customer_id);

-- Example 2: customers who never placed an order
select customer_id,customer_name from customers c 
where not exists (select 1 from orders o where o.customer_id=c.customer_id);

-- Example 3: employees who are not managers (no NULL problem)
select emp_name from employees e where not exists (select 1 from employees e2 where e2.manager_id=e.emp_id);

-- 1.List the customers who have placed at least one order, using EXISTS.
select customer_id, customer_name from customers c 
where exists (select 1 from orders o where c.customer_id = o.customer_id);

-- 2.List the customers who have never placed an order, using NOT EXISTS.
select customer_id, customer_name from customers c 
where not exists (select 1 from orders o where c.customer_id = o.customer_id);

-- 3.List the products that have been ordered at least once.
select product_id, product_name, category from products p 
where exists (select 1 from order_items o where o.product_id = p.product_id);

-- 4.List the products that were never ordered.
select product_id, product_name, category from products p 
where not exists (select 1 from order_items o where o.product_id = p.product_id);

-- 5.List the customers who have at least one Cancelled order.
select customer_id,customer_name from customers c 
where exists (select 1 from orders o where o.customer_id = c.customer_id and o.status = 'Cancelled');


-- 6.List the customers who have no Cancelled orders (this includes customers with no orders at all).
select customer_id,customer_name from customers c where not exists
 (select 1 from orders o where o.customer_id=c.customer_id and o.status='Cancelled');

-- 7.List the employees who manage at least one person.
select emp_id,emp_name from employees e where exists (select 1 from employees m where m.manager_id=e.emp_id);

-- 8.List the employees who are not managers, using NOT EXISTS
select emp_id,emp_name from employees e where not exists (select 1 from employees m where m.manager_id=e.emp_id);

-- 9.List the customers who have ordered at least one Electronics product (this needs orders, order_items and products).
select customer_id,customer_name from customers c 
where exists (select 1 from orders o join order_items oi on o.order_id=oi.order_id join products p on oi.product_id=p.product_id where o.customer_id=c.customer_id and p.category='Electronics');


-- NESTED subqueries : A nested subquery is a subquery inside another subquery. MySQL runs the innermost one first and passes its result outward, level by level.

-- Example 1: customers who bought a Furniture product
select customer_name from customers 
where customer_id in (select customer_id from orders where order_id in 
(select order_id from order_items where product_id in 
(select product_id from products where category='Furniture')));

-- Example 2: nested with an aggregate
select product_name,price from products 
where price>(select avg(price) from products 
where product_id in (select product_id from order_items));

-- UPDATE.
-- Example 3: UPDATE with a subquery (10% discount on products never ordered)
update products set price=price*0.90 where product_id not in (select product_id from order_items);

-- Example 4: DELETE with a subquery (remove customers with no orders)
-- delete from customers where customer_id not in (select customer_id from orders);

-- 1.List the customers who ordered a Smartphone (start from the product name).
select customer_name from customers 
where customer_id in (select customer_id from orders where order_id in 
(select order_id from order_items where product_id in 
(select product_id from products where product_name='Smartphone')));

-- 2.List the products ordered by customers who live in Mumbai.
select product_id,product_name from products where product_id in (select product_id from order_items where order_id in (select order_id from orders where customer_id in (select customer_id from customers where city='Mumbai')));

-- 3.List the employees who earn more than the average salary of the department where Kavya Reddy works.
select emp_id,emp_name,department,salary from employees where salary>(select avg(salary) from employees where department=(select department from employees where emp_name='Kavya Reddy'));

-- 4.List the customers who ordered at least one product priced above the average product price.
select customer_id,customer_name from customers where customer_id in (select customer_id from orders where order_id in (select order_id from order_items where product_id in (select product_id from products where price>(select avg(price) from products))));

-- 5.Give a 5% raise to all employees who earn less than the company average salary.
-- update employees set salary=salary*1.05 
-- where salary<(select avg_sal from (select avg(salary) as avg_sal from employees) t);

-- 6.Set the status to 'Cancelled' for all orders placed by customers from Delhi.
-- update orders
-- set status = 'Cancelled'
-- where customer_id in (select customer_id from customers where city = 'Delhi');

-- Advanced patterns
-- Nth highest value
select max(salary) from employees where salary<(select max(salary) from employees);

-- Nth highest, using a correlated count (works for any N)
select distinct salary from employees e where 
(select count(distinct salary) from employees e2 where e2.salary>e.salary)=2;

-- Nth highest, using limit offset in a scalar subquery
select emp_name,salary from employees 
where salary=(select distinct salary from employees order by salary desc limit 1 offset 2);

-- Top N per group
select emp_name,department,salary from employees e 
where (select count(*) from employees e2 where e2.department=e.department and e2.salary>e.salary)<2;

-- Aggregate of an aggregate, then compare
select c.customer_name,t.total_spent from customers c join (select customer_id,sum(total_amount) as total_spent from orders group by customer_id) t on c.customer_id=t.customer_id where t.total_spent>(select avg(total_spent) from (select sum(total_amount) as total_spent from orders group by customer_id) x);

-- 1.Find the second highest salary using the max and < method.
select max(salary) from employees where salary<(select max(salary) from employees);

-- 2.Find the employee(s) with the 3rd highest distinct salary using the correlated count method.
select emp_name,salary from employees e where 
(select count(distinct salary) from employees e2 where e2.salary>e.salary)=2;

-- 3.List the top 2 most expensive products in each category (include ties).
select product_id,product_name,category,price from products p where (select count(*) from products p2 where p2.category=p.category and p2.price>p.price)<2;

-- 4.List the customers whose total spending is above the average customer spending (use a derived table, like Pattern 3).
select c.customer_name,t.total_spent from customers c join (select customer_id,sum(total_amount) as total_spent from orders group by customer_id) t on c.customer_id=t.customer_id where t.total_spent>(select avg(total_spent) from (select sum(total_amount) as total_spent from orders group by customer_id) x);

-- 5.Find the category with the highest total revenue (quantity*price).
select p.category,sum(oi.quantity*p.price) as revenue from order_items oi join products p on oi.product_id=p.product_id group by p.category order by revenue desc limit 1;

-- 6.List the customers who ordered at least one Electronics product
select customer_id,customer_name from customers where customer_id in 
(select o.customer_id from orders o join order_items oi on o.order_id=oi.order_id join products p on oi.product_id=p.product_id where p.category='Electronics');

-- 7.Rewrite question 4 using a CTE.
with spend as (select customer_id,sum(total_amount) as total_spent from orders group by customer_id) select c.customer_name,s.total_spent from customers c join spend s on c.customer_id=s.customer_id where s.total_spent>(select avg(total_spent) from spend);

-- 8. Find the products priced above the average price of ordered products (nested), and show how many times each was ordered.
select p.product_id,p.product_name,p.price,(select count(*) from order_items oi where oi.product_id=p.product_id) as times_ordered from products p where p.price>(select avg(price) from products where product_id in (select product_id from order_items));


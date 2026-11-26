-- USE DATASET THAT WAS USED FOR SUBQUERY PRACTICE

-- CTE : A CTE (Common Table Expression) is a named temporary result set that you define at the top of a query with WITH, then use like a table in the main query. It exists only for that one statement.

-- Example 1: simple CTE (customer total spending)
with spend as 
(
    select customer_id,sum(total_amount) as total_spent from orders
    group by customer_id
)
select * from spend;

-- Example 2: CTE joined with a table
with spend as
(select customer_id,sum(total_amount) as total_spent from orders group by customer_id) 
select c.customer_name,s.total_spent from customers c
join spend s on c.customer_id = s.customer_id where s.total_spent > 30000;

-- Example 3: naming the columns
with dept_avg(dept,avg_sal) as (select department,avg(salary) 
from employees group by department) select * from dept_avg where avg_sal>65000;

-- 1.Using a CTE, show each customer’s id and number of orders.
with cust_orders as 
(select c.customer_id,c.customer_name,count(o.order_id) as number_of_orders from customers c 
left join orders o on o.customer_id=c.customer_id 
group by c.customer_id,c.customer_name) 
select * from cust_orders;

-- 2.Using a CTE, list the customers (with names) who have more than 1 order.
with cust_orders as
(
    select c.customer_id, c.customer_name, count(o.order_id) as number_of_orders from customers c
    join orders o on 
    o.customer_id = c.customer_id
    group by customer_id,c.customer_name
    having count(order_id) > 1
)
select * from cust_orders;

-- 3.Using a CTE, find each department’s average salary and show only departments above 65000.
with dept_avg as 
(
    select department,avg(salary) as avg_salary from employees
    group by department
    having avg(salary) > 65000
)
select * from dept_avg;

-- 4.Using a CTE with named columns, find each product category’s average price, and show categories with an average above 5000.
with cat_avg(category,price) as 
(
    select category, avg(price) as avg_price from products
    group by category
    having avg(price) > 5000
)
select * from cat_avg;

-- 5.Using a CTE, find the total quantity sold for each product, then show the product names with quantity above 5 (join with products).
with prd_qtn as
(
    select p.product_name, sum(oi.quantity) as quantity_sold from products p
    join order_items oi 
    on oi.product_id = p.product_id
    group by product_name
    having sum(quantity) > 5
)
select * from prd_qtn;

-- 6.Rewrite the Level 3 subquery question (highest average department salary) using a CTE.
with dept_avg as 
(select department,avg(salary) as avg_sal from employees 
group by department) 
select department,avg_sal from dept_avg order by avg_sal desc limit 1;

-- CTE Level 2: Multiple CTEs and chained CTEs
-- A CTE can use any CTE defined before it in the same WITH list. Each step builds on the previous one, so the query reads like a pipeline.

-- Example 1: two independent CTEs joined
with order_cnt as 
(select customer_id,count(*) as cnt from orders group by customer_id),spend as (select customer_id,sum(total_amount) as total_spent from orders group by customer_id) 
select c.customer_name,oc.cnt,s.total_spent from customers c join order_cnt oc on c.customer_id=oc.customer_id join spend s on c.customer_id=s.customer_id;

-- Example 2: chained (the second CTE uses the first)
with spend as (select customer_id,sum(total_amount) as total_spent from orders group by customer_id),
avg_spend as (select avg(total_spent) as avg_total from spend) 
select c.customer_name,s.total_spent from customers c join spend s on c.customer_id=s.customer_id cross join avg_spend a where s.total_spent>a.avg_total;

-- Example 3: three-step chain (category share of total revenue)
with cat_rev as 
(select p.category,sum(oi.quantity*p.price) as revenue from order_items oi 
join products p on oi.product_id=p.product_id group by p.category),
total as (select sum(revenue) as grand from cat_rev) 
select c.category,c.revenue,round(c.revenue*100/t.grand,2) as pct from cat_rev c cross join total t;

-- 1.Using two CTEs, show each customer’s name, number of orders and total spending.
with cust_info as (select c.customer_id,c.customer_name,count(o.order_id) as number_of_orders 
from customers c join orders o on o.customer_id=c.customer_id 
group by c.customer_id,c.customer_name),total_spending as
(select o.customer_id,sum(oi.quantity*p.price) as spend 
from orders o join order_items oi on o.order_id=oi.order_id join products p on oi.product_id=p.product_id group by o.customer_id) 
select c.customer_name,c.number_of_orders,t.spend from cust_info c join total_spending t on c.customer_id=t.customer_id;

-- 2.Using two chained CTEs, list the employees who earn more than their own department’s average (CTE 1: department averages, then join with employees).
with dept_avg as (select department,avg(salary) as avg_sal from employees group by department),
emp as (select e.emp_id,e.emp_name,e.department,e.salary,d.avg_sal from employees e 
join dept_avg d on e.department=d.department where e.salary>d.avg_sal)
select * from emp;

-- 3.Using two CTEs, list the departments whose average salary is above the company-wide average salary.
with cmp_avg as 
(
    select avg(salary) as avg_sal from employees
),
dept_list as 
(
    select e.department,avg(e.salary) as dpt_avg_sal from employees e
    group by department
    having dpt_avg_sal > (select avg_sal from cmp_avg)
)
select * from dept_list;

-- 4.Using a chain, show each product category’s revenue and its percentage share of total revenue
with cat_rvn as (select p.category,sum(oi.quantity*p.price) as revenue from products p 
join order_items oi on p.product_id=oi.product_id group by p.category),
pct_share as (select sum(revenue) as total_revenue from cat_rvn) 
select c.category,c.revenue,round(c.revenue*100/p.total_revenue,2) as share_pct 
from cat_rvn c cross join pct_share p order by share_pct desc;

-- 5.Using two CTEs, list the customers who ordered at least one Electronics product and spent more than 30000 in total.
with elec as 
(select distinct o.customer_id from orders o join order_items oi on o.order_id=oi.order_id join products p on oi.product_id=p.product_id where p.category='Electronics'),
spend as (select customer_id,sum(total_amount) as total_spent from orders group by customer_id) 
select c.customer_id,c.customer_name,s.total_spent from customers c join elec e 
on c.customer_id=e.customer_id join spend s on c.customer_id=s.customer_id where s.total_spent>30000;

-- 6.Using a chain, find the customer with the highest total spending and show their name and amount (CTE 1: spend per customer, CTE 2: the maximum, then join).
with spend as 
(select c.customer_id,c.customer_name,sum(o.total_amount) as total_spent from customers c 
join orders o on c.customer_id=o.customer_id 
group by c.customer_id,c.customer_name),
mx as 
(select max(total_spent) as max_spent from spend) 
select s.customer_name,s.total_spent from spend s join mx on s.total_spent=mx.max_spent;

use subquery_practice;

-- CTE with INSERT, UPDATE and DELETE
-- Example 1: INSERT with a CTE (build a summary table)
create table customer_summary 
(customer_id int, customer_name varchar(50), total_order int, total_spent decimal(10,2));

insert into customer_summary 
with s as 
(
    select customer_id,count(1) as cnt,sum(total_amount) as spent from orders group by customer_id
)
select c.customer_id,c.customer_name,s.cnt,s.spent from customers c 
join s on c.customer_id = s.customer_id;
select * from customer_summary;

--  Example 2: CREATE TABLE with a CTE
create table dpt_avg_sal as
with d as 
(select department, avg(salary) as avg_sal from employees group by department)
select * from d;

select * from dpt_avg_sal;

-- Example 3: UPDATE with a CTE (join the CTE in the update)
with dept_avg as
(
    select department, avg(salary) as avg_sal from employees group by department
)
update employees e join dept_avg d on e.department = d.department
set e.salary = e.salary * 0.5 
where e.salary<d.avg_sal;

-- Example 4: DELETE with a CTE
-- with never_ordered as (select p.product_id from products p left join order_items oi on p.product_id=oi.product_id where oi.product_id is null) delete from products where product_id in (select product_id from never_ordered);

-- 1.Create a table product_sales (product_id, product_name, total_qty) and fill it using INSERT ... WITH ... SELECT with the total quantity sold per product (only products that were ordered).
create table product_sales
(product_id int, product_name varchar(50), total_qty int);

insert into product_sales
with prd as 
(
    select p.product_id, p.product_name , sum(oi.quantity) as quantity_sold 
    from products p 
    join order_items oi 
    on p.product_id = oi.product_id
    group by p.product_id, p.product_name
)
select * from prd;

select * from product_sales;

-- 2.Create a table high_spenders using CREATE TABLE ... AS WITH ... containing the customers whose total spending is above 30000 (columns: customer_id, customer_name, total_spent).

create table high_spenders 
(customer_id int, customer_name varchar(50),total_spent decimal(10,2));

insert into high_spenders
with hs as 
(
    select c.customer_id,c.customer_name,sum(oi.quantity*p.price) as total_spent from customers c 
    join orders o on c.customer_id=o.customer_id 
    join order_items oi on oi.order_id=o.order_id 
    join products p on p.product_id=oi.product_id 
    group by c.customer_id,c.customer_name 
    having total_spent>30000
)
select * from hs;

select * from high_spenders;

-- 3.Using a CTE, give a 10% raise to employees who earn less than their own department’s average salary.
-- with dept_avg as
-- (
--     select department, avg(salary) as avg_sal from employees group by department
-- )
-- update employees e join dept_avg d on e.department = d.department
-- set e.salary = e.salary * 0.10 
-- where e.salary<d.avg_sal

-- 4. Using a CTE, recalculate every order’s total_amount from order_items and products prices.
with ord_prd as
(
    select oi.order_id,sum(oi.quantity*p.price) as new_total from order_items oi 
    join products p on oi.product_id=p.product_id 
    group by oi.order_id
)
select * from ord_prd;

-- 5.Using a CTE, set the status to 'Cancelled' for all orders of customers who have never spent more than 5000 in a single order.
with ord_update as 
(
    select customer_id from orders group by customer_id having max(total_amount)<=5000
)
select * from ord_update;

-- A recursive CTE is a CTE that refers to itself. It repeats until no new rows are produced. It is used for number and date series, and for hierarchies like an employee-manager chain.
-- Anchor member: the starting rows, which run once.
-- Recursive member: reads the rows produced in the previous step and creates new ones.
-- UNION ALL: combines the anchor and every recursive steps
-- Stop condition: the recursion ends when the recursive member returns no rows.

set session cte_max_recursion_depth = 1000000;

-- 1.Generate the numbers 1 to 20.
with recursive num as 
(
    select 1 as n 
    union all 
    select n + 1 from num
    where n <20
)
select * from num;

-- 2.Generate the even numbers from 2 to 20.
with recursive even_num as 
(
    select 2 as n
    union all
    select n + 2 from even_num
    where n < 20
)
select * from even_num;

-- 3.Generate every date of January 2025 (31 rows).
with recursive jan_date as 
(
    select date '2025-01-01' as jan
    union all
    select jan + interval 1 day from jan_date
    where jan < '2025-01-31'
)
select * from jan_date;

-- 4.Show the org chart with a level for every employee
with recursive org_hrc as 
(
    select emp_id,emp_name, 1 as level from employees where manager_id is null
    union all
    select e.emp_id,e.emp_name,o.level+1 from employees e
    join org_hrc o on e.manager_id = o.emp_id
)

select * from org_hrc;

-- 5.List all employees who report to Lakshmi Devi,
with recursive ld as
(
select emp_id,emp_name,0 as lvl from employees where emp_name='Lakshmi Devi' 
union all 
select e.emp_id,e.emp_name,o.lvl+1 from employees e join ld o on e.manager_id=o.emp_id) 
select emp_id,emp_name,lvl from ld where lvl>0;

-- 6.Show each employee’s path from the CEO
with recursive path_to_ceo as 
(
    select emp_id,emp_name,cast(emp_name as char(200)) as path_to_ceo from employees 
    where manager_id is null
    union all 
    select e.emp_id,e.emp_name,concat(o.path_to_ceo, '->',e.emp_name) as ceo_path from employees e
    join path_to_ceo o on e.manager_id = o.emp_id
)
select * from path_to_ceo;

-- 7.Count the employees at each level of the hierarchy.
with recursive org as 
(
select emp_id,1 as level from employees where manager_id is null 
union all 
select e.emp_id,o.level+1 from employees e 
join org o on e.manager_id=o.emp_id
) 
select level,count(*) as emp_count from org group by level order by level;

-- 8.Show the number of orders for every month of 2024, including months with zero orders. Use a recursive CTE to generate the 12 months, then a left join to orders.
with recursive months as
(select 1 as m 
union all 
select m+1 from months where m<12) 
select m.m,count(o.order_id) as orders_count 
from months m left join orders o on m.m=month(o.order_date) and year(o.order_date)=2024 group by m.m order by m.m;

-- CTE Level 6: Limitations, performance and interview patterns

-- Example: one CTE used twice
with spend as (select customer_id,sum(total_amount) as total_spent from orders group by customer_id),
avg_s as (select avg(total_spent) as a from spend) 
select sum(s.total_spent>x.a) as above_avg,sum(s.total_spent<=x.a) 
as at_or_below_avg from spend s cross join avg_s x;

-- Pattern 1: duplicates
with c as 
(select city,count(*) as cnt from customers 
group by city having count(*)>1) 
select * from c;

-- Pattern 2: running total with a self join
with r as 
(select a.order_id,a.total_amount,sum(b.total_amount) as running_total 
from orders a join orders b on b.order_id<=a.order_id 
group by a.order_id,a.total_amount) 
select * from r order by order_id;

-- Pattern 3: max per group, without window functions
with spend as (select c.customer_id,c.customer_name,c.city,sum(o.total_amount) as total_spent from customers c join orders o on c.customer_id=o.customer_id group by c.customer_id,c.customer_name,c.city),
city_max as (select city,max(total_spent) as mx from spend group by city) 
select s.city,s.customer_name,s.total_spent from spend s join city_max m on s.city=m.city and s.total_spent=m.mx;


-- 1.Using a recursive CTE to generate 2024 months, list the months with no orders.
with recursive months as
(select 1 as m 
union all 
select m+1 from months where m<12) 
select m.m,count(o.order_id) as orders_count 
from months m left join orders o on m.m=month(o.order_date) and year(o.order_date)=2024 
group by m.m
having count(order_id) = 0;


-- 2.Using a CTE, find the cities that have more than 1 customer, and show the customer names in each
with cust_city as
(
    select city,count(1) as total_cust from customers
    group by city
    having total_cust > 1
)
select  c.customer_name,cc.city,cc.total_cust from customers c join cust_city cc on cc.city = c.city;

-- 3.Using a CTE, produce a running total of total_amount by order_id
with rt_total as 
(
    select o.order_id,o.total_amount, sum(oo.total_amount) as run_total
    from orders o join orders oo 
    on oo.order_id <= o.order_id
    group by o.order_id,o.total_amount
)
select * from rt_total order by order_id;

-- 4.Using two CTEs, show the highest-spending customer in each city
with high_spenders as 
(
    select c.customer_id,c.customer_name,sum(o.total_amount) as total_spend,c.city
    from customers c join orders o on 
    o.customer_id = c.customer_id
    group by c.customer_id,c.customer_name,c.city
),
high_spending_city as
(
    select c.city,max(total_spend) as high_spend from high_spenders c
    group by city
)
select c.customer_id,c.customer_name,cc.city,cc.high_spend from high_spenders c join high_spending_city cc
on c.city = cc.city and c.total_spend = cc.high_spend;

-- 5.Using one CTE referenced twice, show how many products are priced above the average price and how many are at or below it.
with prices as 
(select product_id,price from products),
avg_p as (select avg(price) as a from prices) 
select sum(p.price>x.a) as above_avg,sum(p.price<=x.a) as at_or_below_avg from prices p cross join avg_p x;

-- 6.Using a recursive CTE, show each employee’s number of direct and indirect reports. Hint: build all (ancestor, descendant) pairs recursively, then count them in the final query.
with recursive pairs as 
(select manager_id as ancestor,
emp_id as descendant from employees where manager_id is not null 
union all 
select p.ancestor,e.emp_id from pairs p 
join employees e on e.manager_id=p.descendant) 
select e.emp_id,e.emp_name,count(p.descendant) as total_reports from employees e left join pairs p on e.emp_id=p.ancestor group by e.emp_id,e.emp_name order by e.emp_id;
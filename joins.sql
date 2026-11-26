-- JOINS : Joins are used to combine two or more tables.
		   -- even we can use join in single table by self join.

create database sql_joins;

use sql_joins;


drop table if exists orders;
drop table if exists customers;
drop table if exists products;
drop table if exists employees;

create table customers(customer_id int primary key,name varchar(50),city varchar(50),signup_date date);
create table products(product_id int primary key,product_name varchar(50),category varchar(50),price decimal(10,2));
create table orders(order_id int primary key,customer_id int null,product_id int,quantity int,order_date date);
create table employees(employee_id int primary key,name varchar(50),manager_id int null);

insert into customers values
(1,'Asha','Chennai','2025-01-10'),
(2,'Ravi','Mumbai','2025-02-15'),
(3,'Meena','Chennai','2025-03-01'),
(4,'Karan','Delhi','2025-03-20'),
(5,'Priya','Mumbai','2025-04-05'),
(6,'Arjun','Bengaluru','2025-05-12'),
(7,'Sneha','Delhi','2025-06-18'),
(8,'Vikram','Chennai','2025-07-22'),
(9,'Divya','Pune','2025-08-30'),
(10,'Rahul','Kolkata','2025-09-14');

insert into products values
(1,'Laptop','Electronics',55000.00),
(2,'Phone','Electronics',30000.00),
(3,'Headphones','Accessories',2500.00),
(4,'Keyboard','Accessories',1500.00),
(5,'Monitor','Electronics',12000.00),
(6,'Mouse','Accessories',800.00),
(7,'Backpack','Fashion',1800.00),
(8,'Smart Watch','Electronics',9000.00),
(9,'Sneakers','Fashion',3500.00),
(10,'Water Bottle','Home',600.00);

insert into orders values
(101,1,1,2,'2026-01-05'),
(102,1,3,1,'2026-01-12'),
(103,2,2,1,'2026-02-03'),
(104,3,1,3,'2026-02-14'),
(105,3,5,1,'2026-03-01'),
(106,4,3,2,'2026-03-10'),
(107,5,7,1,'2026-03-22'),
(108,6,2,2,'2026-04-02'),
(109,11,4,1,'2026-04-15'),
(110,null,12,1,'2026-04-20');

insert into employees values
(1,'Anil',null),
(2,'Bhavna',null),
(3,'Chitra',1),
(4,'Dinesh',1),
(5,'Esha',2),
(6,'Farhan',3),
(7,'Gita',3),
(8,'Harish',4),
(9,'Indu',5),
(10,'Jai',5);


-- inner joins : Returns only rows that have a match in both tables. Rows with no match on either side are dropped.
select c.customer_id, c.name,o.order_id,o.quantity,o.order_date
from  orders as o 
inner join customers as c
on o.customer_id = c.customer_id;

-- left join : Returns every row from the left table, plus matching rows from the right. Where there is no match, the right side columns are NULL.
select c.customer_id, c.name,o.order_id,o.quantity,o.order_date
from orders as o 
left join customers as c
on o.customer_id = c.customer_id;

-- right join : The mirror of left join. It keeps every row from the right table and fills NULLs on the left when nothing matches.
select c.customer_id, c.name,o.order_id,o.quantity,o.order_date
from orders as o 
right join customers as c
on o.customer_id = c.customer_id;

-- full join : All values from both tables , unmatched rows becomes null
select c.customer_id, c.name,o.order_id,o.quantity,o.order_date
from orders as o 
left join customers as c
on o.customer_id = c.customer_id
union
select c.customer_id, c.name,o.order_id,o.quantity,o.order_date
from orders as o 
right join customers as c
on o.customer_id = c.customer_id;

-- cross join : cartesian product of all rows from both tables
select c.customer_id, p.product_name from customers as c cross join products p;

-- self join : A table joined to itself using two different aliases
select a.name, b.name, a.city, b.city from customers a 
inner join customers b on a.city = b.city and a.customer_id < b.customer_id;

-- left anti join : Returns left-table rows that have no match in the right table. 
-- Written as LEFT JOIN ... WHERE right.key IS NULL or NOT EXISTS.
select c.* from customers c left join orders o on c.customer_id = o.customer_id where o.order_id is null;

-- right anti join : Returns right-table rows that have no match in the left table. Same idea as the left anti join, with the tables swapped.
select o.* from customers c right join orders o on c.customer_id = o.customer_id where c.customer_id is null;

-- full anti join : Returns the unmatched rows from both sides and nothing else. It is the full outer join minus the matched rows.
select c.customer_id,o.order_id from customers c left join orders o on c.customer_id = o.customer_id where o.order_id is null
union
select c.customer_id,o.order_id from customers c right join orders o on c.customer_id = o.customer_id where c.customer_id is null;

-- semi join :Returns left-table rows that have at least one match on the right, without pulling in right-side columns. Written with EXISTS
select * from customers c where exists (select 1 from orders o where o.customer_id = c.customer_id);

-- natural join : give matching from both tables, no need to give keys to join.
select * from customers natural join orders;

-- using : give common key from both tables inside using()
select * from customers join orders using (customer_id);

-- non equi : same product with different price gets displayed.
select a.product_name as costlier, b.product_name as cheaper,a.category from 
products a join products b on a.product_id < b.product_id and a.price > b.price;

-- multi condition: gives customers where order date is greater than signup date
select c.name,o.order_id,o.quantity from customers c 
join orders o on c.customer_id = o.customer_id and c.signup_date < o.order_date;

-- 3 table joins
select c.customer_id,c.name,c.city,o.order_id,o.quantity,p.product_name,
o.quantity * p.price as total
from customers as c
inner join orders as o 
on o.customer_id = c.customer_id
inner join products as p 
on p.product_id = o.product_id;

-- filter on where
select c.customer_id,c.name,o.order_id,o.quantity from customers as c 
inner join orders as o on c.customer_id = o.customer_id
where order_date > '2026-02-03';

-- hierarchical self join
select e.name as employee,m.name as manager from employees as e
join employees as m 
on 
e.manager_id = m.employee_id;

-- hierarchical left join
select e.name as employee,m.name as manager from employees as e
left join employees as m 
on 
e.manager_id = m.employee_id;

-- anti hierarchical join
select e.name as employee,m.name as manager from employees as e
left join employees as m 
on 
e.manager_id = m.employee_id where m.employee_id is null;

-- same manager pairs
select e.name as employee,m.name as manager from employees as e
left join employees as m 
on 
e.manager_id=m.manager_id and e.employee_id<m.employee_id;

-- NULL-safe join (<=>): Treats NULL = NULL as true, which normal = never does. Use it only when two missing values should count as a match.
select a.name,b.name from employees a join employees b on a.manager_id<=>b.manager_id 
and a.employee_id<b.employee_id;


drop table if exists shipments;
drop table if exists order_items;
create table order_items(order_id int,line_no int,product_id int,qty int,primary key(order_id,line_no));
create table shipments(order_id int,line_no int,carrier varchar(30),shipped_date date);

insert into order_items values
(101,1,1,2),(102,1,3,1),(103,1,2,1),(104,1,1,3),(104,2,3,1),
(105,1,5,1),(106,1,3,2),(107,1,7,1),(108,1,2,2),(108,2,4,1);

insert into shipments values
(101,1,'BlueDart','2026-01-07'),(102,1,'Delhivery','2026-01-14'),(103,1,'BlueDart','2026-02-05'),
(104,1,'DTDC','2026-02-16'),(104,2,'DTDC','2026-02-17'),(105,1,'Delhivery','2026-03-03'),
(106,1,'BlueDart','2026-03-12'),(108,1,'DTDC','2026-04-04'),(108,3,'DTDC','2026-04-05'),
(109,1,'BlueDart','2026-04-17');

-- composite key joins
-- composite inner
select oi.order_id, oi.line_no,s.carrier from order_items oi
join shipments s on s.order_id=oi.order_id and s.line_no=oi.line_no;

-- using
select * from order_items join shipments using(order_id,line_no);

-- composite left
select oi.order_id, oi.line_no,s.carrier from order_items oi
left join shipments s on s.order_id=oi.order_id and s.line_no=oi.line_no;

-- tuple semi join 
select * from order_items where (order_id,line_no) in (select order_id,line_no from shipments);

-- classic mistake: joining on only part of the key 
select oi.order_id,oi.line_no,s.carrier from order_items oi join shipments s on s.order_id=oi.order_id;

-- five-table chain,
select c.name,p.product_name,s.carrier from customers c join orders o on o.customer_id=c.customer_id join order_items oi on oi.order_id=o.order_id join products p on p.product_id=oi.product_id join shipments s on s.order_id=oi.order_id and s.line_no=oi.line_no;

select c.name,p.product_name,s.carrier from customers c join orders o on o.customer_id=c.customer_id join order_items oi on oi.order_id=o.order_id join products p on p.product_id=oi.product_id left join shipments s on s.order_id=oi.order_id and s.line_no=oi.line_no;

-- implicit join (comma and same as inner)
select c.name,o.order_id from customers c, orders o where c.customer_id = o.customer_id;

-- natural left join : A natural join that keeps all left-table rows. Unmatched rows get NULLs on the right.
select * from customers natural left join orders;

-- join on derived tables or cte
with t as 
(select customer_id,count(1) as cnt from orders group by customer_id)
select c.name, coalesce(t.cnt,0) as total_orders from customers c
left join t on c.customer_id = t.customer_id;

-- range join with between
select c.name,o.order_id from customers c join orders o on o.customer_id=c.customer_id and o.order_date between c.signup_date and '2026-03-01';

-- recursive cte for full hierarchy
with recursive h as 
(select employee_id,name,manager_id,1 as level from employees where manager_id is null
 union all
 select e.employee_id,e.name,e.manager_id,h.level + 1 from employees e join h on
 e.manager_id = h.employee_id
)
select * from h;

-- straight join : Forces MySQL to join tables in the order you wrote them. It does not change the result, only the execution plan.
select straight_join c.name,o.order_id from customers c join
orders o on c.customer_id = o.customer_id;

-- Fan out trap (joining two one to many tables multiples rows)
select c.name,count(1) from customers c join 
orders o on c.customer_id = o.customer_id
join 
employees e on e.manager_id is null group by c.name;

-- lateral : A subquery on the right side that can reference columns from the table on its left. It is used for top-N-per-group queries such as the latest order per customer.
select c.name,x.order_id,x.order_date from customers c
left join lateral(select o.order_id,o.order_date from orders o where o.customer_id=c.customer_id 
order by o.order_date desc limit 1) x on true;

-- aggregation with join (6 cities, none dropped)
select c.city,count(o.order_id) as orders,coalesce(sum(o.quantity*p.price),0) as revenue from customers c left join orders o on c.customer_id=o.customer_id left join products p on o.product_id=p.product_id group by c.city;

-- NOT IN trap: returns 0 rows because order 110 has a NULL customer_id
select * from customers where customer_id not in(select customer_id from orders);

-- the safe version returns 4 rows
select * from customers c where not exists(select 1 from orders o where o.customer_id=c.customer_id);

-- update join (3 rows: orders 102, 106, 109)
update orders o join products p on o.product_id=p.product_id set o.quantity=o.quantity+1
where p.category='Accessories';

-- delete join (2 rows: orders 109, 110), run last
delete o from orders o left join customers c on o.customer_id=c.customer_id 
where c.customer_id is null;

-- practice :
-- customers who bought a phone
select c.customer_id,c.name,o.order_id,p.product_name
from customers c 
inner join orders o on c.customer_id = o.customer_id
inner join products p on o.product_id = p.product_id
where p.product_name = 'Phone';

-- Revenue per customer
select c.customer_id,c.name as customer_name,c.city,
count(o.order_id) as total_orders,
coalesce(sum(o.quantity*p.price),0) as revenue
from customers c
left join orders o on o.customer_id=c.customer_id
left join products p on p.product_id=o.product_id
group by c.customer_id,c.name,c.city
order by revenue desc;

-- Products that never appear in order_items
select p.product_id,p.product_name from products p
left join order_items oi 
on p.product_id = oi.product_id where oi.product_id is null;

-- Customers who bought from more than one category
select c.customer_id,c.name,
group_concat(distinct p.category order by p.category) as category_list from customers c
join orders o on c.customer_id=o.customer_id join order_items oi on oi.order_id=o.order_id join products p on p.product_id=oi.product_id group by c.customer_id,c.name having count(distinct p.category)>1;

-- Order ids that have at least one unshipped items
select distinct oi.order_id from order_items oi
left join shipments s on s.order_id=oi.order_id and s.line_no=oi.line_no where s.order_id is null;

-- single top spending customer
select c.name, o.quantity*p.price as revenue 
from customers c 
inner join orders o
on c.customer_id = o.customer_id
inner join products p
on p.product_id = o.product_id
order by revenue desc
limit 1;

-- Customers who ordered but have nothing shipped
select c.name from customers c join orders o on o.customer_id=c.customer_id 
join order_items oi on oi.order_id=o.order_id 
left join shipments s on s.order_id=oi.order_id and s.line_no=oi.line_no 
group by c.customer_id,c.name having count(s.order_id)=0;

-- Each employee with their manager’s manager
select e.name as employee,g.name as grand_manager from employees e 
join employees m on e.manager_id=m.employee_id 
join employees g on m.manager_id=g.employee_id;

-- Each employee with their number of direct reports, including zero 
select m.name,count(e.employee_id) as reports from employees m 
left join employees e on e.manager_id=m.employee_id 
group by m.employee_id,m.name;

-- Cities where no customer has ever ordered
select c.city from customers c left join orders o on o.customer_id=c.customer_id 
group by c.city having count(o.order_id)=0;

-- Distinct products bought per customer, including zero
select c.name,count(distinct oi.product_id) as products from customers c 
left join orders o on o.customer_id=c.customer_id 
left join order_items oi on oi.order_id=o.order_id 
group by c.customer_id,c.name;



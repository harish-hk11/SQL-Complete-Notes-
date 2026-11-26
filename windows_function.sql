-- USE DATASET THAT WAS USED FOR SUBQUERY PRACTICE

-- Window Functions Level 1: What is a window function and the over() clause
-- A window function performs a calculation across a set of rows related to the current row, but it does not collapse the rows. Every row stays in the result, and the calculated value is added as an extra column

-- Example 1: group by vs window
select avg(salary) as avg_sal from employees;

-- window
select emp_name,salary,avg(salary) over() company_avg from employees;

-- Example 2: difference from the average, with no subquery
select emp_name,salary,salary - avg(salary) over() avg_to_salary_diff from employees;

-- Example 3: percent of total
select emp_name,salary,round(salary*100/sum(salary) over(),2) as pct_payroll from employees;

-- Example 4: a first look at row numbering
-- row_number() gives each row a number in the order inside over()
select row_number() over(order by emp_id) as rn, emp_name from employees;

-- Example 5: filtering on a window result (the CTE way)
with t as
(select emp_name,salary,avg(salary) over() as company_avg from employees)
select * from t where salary > company_avg;

-- 1.Show every employee’s name, salary and the company’s average salary, without a subquery.
select emp_name,salary,avg(salary) over() company_avg from employees;

-- 2.Show every employee’s name, salary and how much above or below the company average they are.
select emp_name,salary, salary - avg(salary) over() as salary_diff from employees;

-- 3.Show every product’s name, price, and the total of all product prices.
select product_name,price,sum(price) over() as total_price from products;

-- 4.Show every product’s name, price and its percent share of the total of all prices (rounded to 2 decimals).
select product_name, price, round(price * 100/sum(price) over() ,2)  as pct_diff from products;

-- 5.Show every order’s order_id, total_amount and the total number of orders as a column.
select order_id, total_amount, count(order_id) over() as total_number_of_orders from orders;

-- 6.Show every customer’s name and the total number of customers as a column.
select customer_name, count(customer_id) over() as total_number_of_customers from customers;

-- 7.Number the employees from 1 to 10 by salary, highest first, using row_number().
select row_number() over(order by salary desc) as id,emp_name,salary from employees;

-- 8.List the employees who earn above the company average using a window function inside a CTE.
with c as 
(
    select emp_name,salary,avg(salary) over() as cmp_avg from employees
)
select * from c where salary > cmp_avg;

-- Window Functions Level 2: partition by and order by inside over()
--partition by : splits the rows into groups (partitions)

-- Example 1: department average on every row
select emp_name,department,salary,avg(salary) over(partition by department) as dept_avg from employees;

-- Example 2: difference from the department average
select emp_name,department,salary,salary-avg(salary) over(partition by department) as diff from employees;

-- Example 3: count of rows in each partition
select emp_name,department,count(*) over(partition by department) as dept_size from employees;

-- Example 4: percent share inside the partition
select emp_name,department,salary,round(salary*100/sum(salary) over(partition by department),2) as pct_of_dept from employees;

-- order by inside over()
-- Example 5: running total of salary
select emp_id,emp_name,salary,sum(salary) over(order by emp_id) as running_total from employees;

-- Example 6: running total restarting for each department
select department,emp_name,hire_date,salary,sum(salary) over(partition by department order by hire_date) as dept_running from employees;

-- Filtering on a partition result
with t as (select emp_name,department,salary,max(salary) over(partition by department) as dept_max from employees) select emp_name,department,salary from t where salary=dept_max;

-- 1.Show each employee’s name, department, salary and their department’s average salary.
select emp_name,department,salary, avg(salary) over(partition by department) as dpt_avg from employees;

-- 2.Show each employee’s name, salary and how much above or below their department’s average they are.
select emp_name,department,salary,salary - avg(salary) over(partition by department) as sal_diff from employees;

-- 3.Show each product’s name, category, price and the highest price in its category.
select product_name,category,price,max(price) over(partition by category) as cat_diff from products;

-- 4.Show each order’s order_id, customer_id, total_amount and that customer’s total spending as a column
select order_id,customer_id,total_amount,
sum(total_amount) over(partition by customer_id) as total_spending from orders;

-- 5.Show each order’s order_id, customer_id, total_amount and the order’s percent share of that customer’s total spending (rounded to 2 decimals).
select order_id,customer_id,total_amount,
round(total_amount*100/sum(total_amount) over(partition by customer_id),2) as pct_spending from orders;

-- 6.Show each employee’s name, department and the number of employees in their department.
select emp_name,department,count(emp_id) over(partition by department) as dept_strength from employees;

-- 7.Show a running total of total_amount for each customer, ordered by order_date
select customer_id,order_id,order_date,total_amount,sum(total_amount) over(partition by customer_id order by order_date) as running_total from orders;

-- 8.Show a running total of salary within each department, ordered by hire_date.
select emp_id,emp_name,salary,department,sum(salary) over(partition by department order by hire_date) as running_total
from employees;

-- 9.Using a CTE, list the employees who earn more than their own department’s average.
with d as 
(
    select emp_name,department,salary,avg(salary) over(partition by department) as dpt_avg from employees
)
select * from d where salary > dpt_avg;

-- 10.Using a CTE, list each customer’s most expensive order (highest total_amount).
with d as 
(
    select customer_id,total_amount,max(total_amount) over(partition by customer_id) as high_spending from orders
)
select * from d where total_amount = high_spending;


-- Window Functions Level 3: Ranking functions
-- Ranking functions give each row a position inside its window, based on the order by in over().
-- row_number() : Always unique, ties get different numbers (arbitrary unless you add a tie-breaker)
-- rank() : Ties share a rank, then gaps appear
-- dense_rank() : Ties share a rank, no gaps

-- Example 1: the three side by side (company-wide)
select emp_name,salary,row_number() over(order by salary desc,emp_id) as rn,rank() over(order by salary desc) as rnk,dense_rank() over(order by salary desc) as drnk from employees;

-- Example 2: rank inside each group
select department,emp_name,salary,dense_rank() over(partition by department order by salary desc) as dept_rank from employees;

-- Example 3: top N per group (with a CTE)
with r as (select department,emp_name,salary,dense_rank() over(partition by department order by salary desc) as rnk from employees) select department,emp_name,salary from r where rnk<=2;

-- Example 4: Nth highest value
with r as (select emp_name,salary,dense_rank() over(order by salary desc) as rnk from employees) select emp_name,salary from r where rnk=3;

-- 1.Show every employee’s name and salary with row_number, rank and dense_rank side by side (highest salary first, emp_id as the tie-breaker for row_number).
select row_number() over() as id, emp_name,rank() over(order by salary desc) as r,
dense_rank() over(order by salary desc) as dr from employees;

-- 2.Rank the employees inside each department by salary, highest first, using dense_rank.
select emp_name,department,salary,dense_rank() over(partition by department order by salary desc) as dpt_rnk from employees;

-- 3.List the top 2 highest-paid employees in each department, including ties.
with emp as 
(select emp_name,department,dense_rank() over(partition by department order by salary desc) as dpt_rnk
from employees)
select * from emp where dpt_rnk <= 2;

-- 4.List the employees with the 3rd highest distinct salary.
with emp as 
(select emp_name,department,dense_rank() over(order by salary desc) as sal_rnk
from employees)
select * from emp where sal_rnk = 3;

-- 5.List the most expensive product in each category.
with prd as 
(
    select category,product_name,dense_rank() over(partition by category order by price desc) as prd_rnk 
    from products
)
select category, product_name from prd where prd_rnk = 1;

-- 6.List the top 2 most expensive products in each category.
with prd as 
(
    select category,product_name,dense_rank() over(partition by category order by price desc) as prd_rnk 
    from products
)
select category, product_name from prd where prd_rnk <= 2;

-- 7.Number each customer’s orders in date order (1 for the first order), and then show only each customer’s first order using a CTE.
with ord as 
(
    select customer_id,order_id,dense_rank() over(partition by customer_id order by order_date) as ord_rank
    from orders
)
select * from ord where ord_rank = 1;

-- 8.List each customer’s second highest order by total_amount (only customers with at least 2 orders).
with cust as
(
    select customer_id,total_amount,dense_rank() over(partition by customer_id order by total_amount desc) as ord_rank
    from orders
)
select customer_id,total_amount from cust where ord_rank = 2;

-- 9.Rank the customers by total spending, highest first, showing the name, total and rank (customers with orders only).
with cust_spending as 
(select c.customer_id,c.customer_name,sum(o.total_amount) as total_spent from customers c 
join orders o on o.customer_id=c.customer_id group by c.customer_id,c.customer_name)
select customer_name,total_spent,dense_rank() over(order by total_spent desc) as spend_rank from cust_spending;

-- 10.For each city, list the customer with the highest total spending using row_number (customers with orders only).
with cust_spend as 
(select c.customer_id,c.customer_name,c.city,sum(o.total_amount) as total_spent from customers c 
join orders o on o.customer_id=c.customer_id group by c.customer_id,c.customer_name,c.city),
cust_rank as (select *,row_number() over(partition by city order by total_spent desc) as rn from cust_spend)
select city,customer_name,total_spent from cust_rank where rn=1;

-- Window Functions Level 4: Aggregate windows and frame clauses
-- A frame is the set of rows, inside the partition, that the function looks at for the current row.
-- rows vs range
-- Order by salary, where Suresh and Anjali both earn same:
select emp_name,salary,sum(salary) over(order by salary) as range_sum,sum(salary) over(order by salary rows between unbounded preceding and current row) as rows_sum from employees;

-- Example 1: running total per customer
-- unbounded preceeding : from the first row of the partition
-- current row : the current row
select customer_id,order_id,order_date,total_amount,sum(total_amount) 
over(partition by customer_id order by order_date,order_id rows between unbounded preceding and current row) as running_total from orders;

-- Example 2: moving average of the last 3 orders
-- 2 preceeding : 2 rows before current row 
select order_id,total_amount,avg(total_amount)
over(order by order_id rows between 2 preceding and current row) as moving_avg from orders;

-- Example 3: centered window (previous, current and next row)
-- n following : n rows after the current row
select order_id,total_amount,avg(total_amount) over(order by order_id rows between 1 preceding and 1 following) as centered_avg from orders;

-- Example 4: the whole partition
-- unbounded following : to the last row of the partition
select emp_name,department,salary,max(salary) 
over(partition by department order by salary rows between unbounded preceding and unbounded following) as dept_max from employees;

-- Example 5: running count, min and max
select order_id,total_amount,count(*) 
over(order by order_id) as running_count,min(total_amount) over(order by order_id) as running_min from orders;

-- 1.Show a running total of total_amount over all orders, ordered by order_id, using rows.
select order_id,total_amount,sum(total_amount) over(order by order_id rows between unbounded preceding and current row) as running_total from orders;

-- 2.Running total per customer
select customer_id,order_id,order_date,total_amount,sum(total_amount) over(partition by customer_id order by order_date,order_id rows between unbounded preceding and current row) as running_total from orders;

-- 3. 3-order moving average
select order_id,total_amount,avg(total_amount) over(order by order_id rows between 2 preceding and current row) as moving_avg from orders;

-- 4.Centered 3-row average
select order_id,total_amount,avg(total_amount) over(order by order_id rows between 1 preceding and 1 following) as centered_avg from orders;

-- 5.range vs rows running total of salary
select emp_name,salary,sum(salary) over(order by salary) as range_sum,
sum(salary) over(order by salary rows between unbounded preceding and current row) as rows_sum from employees;

-- 6.Running count of orders per customer
select customer_id,order_id,order_date,
count(*) over(partition by customer_id order by order_date,order_id) as order_no from orders;

-- 7.Running average price within each category
select category,product_name,price,avg(price)
over(partition by category order by price rows between unbounded preceding and current row) as running_avg from products;

-- 8.Department maximum with an explicit full frame
select emp_name,department,salary,max(salary) over(partition by department order by salary rows between unbounded preceding and unbounded following) as dept_max from employees;

-- 9.Monthly totals with a running total across 2024
with m as (select month(order_date) as mth,
sum(total_amount) as month_total from orders where year(order_date)=2024 group by month(order_date)) 
select mth,month_total,sum(month_total) over(order by mth) as running_total from m;


-- Window Functions Level 5: lag(1 st row null) and lead(last row null)
-- lag(column, n, default) returns the value from n rows before the current row
-- lead(column, n, default) returns the value from n rows after the current row.

-- Example 1: previous order amount
select order_id,total_amount,lag(total_amount) over(order by order_id) as prev_amount from orders;

-- Example 2: change from a customer’s previous order
select customer_id,order_id,order_date,total_amount,
lag(total_amount) over(partition by customer_id order by order_date,order_id) as prev_amount,
total_amount-lag(total_amount) over(partition by customer_id order by order_date,order_id) as change_amt from orders;

-- Example 3: default value instead of NULL
select order_id,total_amount,lag(total_amount,1,0) over(order by order_id) as prev_amount from orders;

-- Example 4: lead for days until the customer’s next order
select customer_id,order_id,order_date,
datediff(lead(order_date) over(partition by customer_id order by order_date,order_id),order_date) as days_to_next 
from orders;

-- Example 5: looking back more than one row
select order_id,total_amount,lag(total_amount,2) over(order by order_id) as two_back from orders;

-- Example 6: month-over-month growth (CTE first, then lag)\
with m as (select month(order_date) as mth,sum(total_amount) as month_total from orders where year(order_date)=2024 group by month(order_date)) select mth,month_total,lag(month_total) over(order by mth) as prev_month,round((month_total-lag(month_total) over(order by mth))*100/lag(month_total) over(order by mth),2) as growth_pct from m;


-- 1.Show each order’s order_id, total_amount and the previous order’s amount (ordered by order_id).
select order_id,total_amount,lag(total_amount) over(order by order_id) as previous_ord_amount
from orders;

-- 2.Show the same, with 0 instead of NULL for the first order.
select order_id,total_amount,lag(total_amount,1,0) over(order by order_id) as previous_ord_amount
from orders;

-- 3.Show each order’s total_amount and the next order’s amount.
select order_id,total_amount,lead(total_amount) over(order by order_id) as previous_ord_amount
from orders;

-- 4.For each customer, show every order with the difference from their previous order’s amount.
select customer_id,order_id,total_amount,total_amount-lag(total_amount) over(partition by customer_id order by order_date,order_id) as change_amt from orders;

-- 5.For each customer, show the number of days between consecutive orders.
select customer_id,order_id,order_date,
datediff(lead(order_date) over(partition by customer_id order by order_date,order_id),order_date) as days_to_next 
from orders;

-- 6.List the orders where the amount is higher than the same customer’s previous order (use a CTE).
with amount as 
(select customer_id,order_id,total_amount,
lag(total_amount) over(partition by customer_id order by order_date,order_id) as prev_amount from orders)
select customer_id,order_id,total_amount,prev_amount from amount where total_amount>prev_amount;

-- 7.Show each employee’s salary and the salary of the next-higher earner company-wide (ordered by salary), plus the gap between them.
select emp_name,salary,
lead(salary) over(order by salary,emp_id) as next_salary,
lead(salary) over(order by salary,emp_id)-salary as gap from employees;

-- 8.Month-over-month growth for 2024
with m as 
(select month(order_date) as mth,sum(total_amount) as month_total from orders where year(order_date)=2024 group by month(order_date)) 
select mth,month_total,lag(month_total) over(order by mth) as prev_month,round((month_total-lag(month_total) over(order by mth))*100/lag(month_total) over(order by mth),2) as growth_pct from m;

-- 9.Customers whose latest order is larger than their previous one
with lat_order as 
(select customer_id,order_id,total_amount,lag(total_amount) over(partition by customer_id order by order_date,order_id) as prev_amount,
lead(order_id) over(partition by customer_id order by order_date,order_id) as next_order from orders) 
select customer_id,order_id,total_amount,prev_amount from lat_order where next_order is null and total_amount>prev_amount;

-- Window Functions Level 6: first_value, last_value, nth_value
-- Function	Returns
-- first_value(col)	the value from the first row of the frame
-- last_value(col)	the value from the last row of the frame
-- nth_value(col, n)	the value from the nth row of the frame (NULL if the frame has fewer than n rows)

-- Example 1: cheapest product name in each category
select category,product_name,price,first_value(product_name) 
over(partition by category order by price) as cheapest from products;

-- Example 2: the last_value trap
select category,product_name,price,last_value(product_name) over(partition by category order by price rows between unbounded preceding and unbounded following) as priciest from products;

-- Example 3: nth_value (second cheapest in each category)
select category,product_name,price,nth_value(product_name,2) over(partition by category order by price rows between unbounded preceding and unbounded following) as second_cheapest from products;

--Example 4: first order amount per customer
select customer_id,order_id,total_amount,first_value(total_amount) over(partition by customer_id order by order_date,order_id) as first_order_amt from orders;

-- Example 5: gap to the top earner in the department
select department,emp_name,salary,first_value(salary) over(partition by department order by salary desc)-salary as gap_to_top from employees;

-- 1.For each product, show the cheapest product’s name in its category.
select category,product_name,price,first_value(product_name) over(partition by category order by price) as cheap_prd
from products;

-- 2.For each product, show the most expensive product’s name in its category using last_value with the correct frame.

select category,product_name,price,last_value(product_name) over(partition by category order by price 
rows between unbounded preceding and unbounded following) as cheap_prd
from products;

-- 3.Repeat question 2 using first_value with a descending order.
select category,product_name,price,first_value(product_name) over(partition by category order by price desc) as cheap_prd
from products;

-- 4.For each product, show the second cheapest product’s name in its category.
select category,product_name,price,nth_value(product_name,2) over(partition by category order by price rows between unbounded preceding and unbounded following) as scd_cheap from products;

-- 5.For each employee, show the name of the earliest-hired employee in their department.
select emp_name,hire_date,first_value(emp_name) over(partition by department order by hire_date) as first_hired
from employees;

-- 6.For each employee, show the gap between their salary and the highest salary in their department.
select emp_name,hire_date,first_value(emp_name) over(partition by department order by salary desc) as high_salary,
salary - first_value(salary) over(partition by department order by salary desc) as salary_gap
from employees;

-- 7.For each order, show the customer’s first order amount and the difference from the current order.
select order_id,customer_id,total_amount,
first_value(total_amount) over(partition by customer_id order by order_date,order_id) as first_order_amt,total_amount-first_value(total_amount) over(partition by customer_id order by order_date,order_id) as diff_from_first 
from orders;

-- 8.For each order, show the amount of the customer’s latest order.
select order_id,total_amount,
first_value(total_amount) over(partition by customer_id order by order_date desc) as lat_orders from orders;

-- 9.For each employee, show the 3rd highest salary in the company as a column on every row.
select emp_name,salary,
nth_value(salary,3) over(order by salary desc rows between unbounded preceding and unbounded following) as third_highest from employees;

-- 10.For each product, show its price as a percentage of the cheapest product in its category (rounded to 2 decimals).
select product_name,category,price,
round(price*100/first_value(price) over(partition by category order by price),2) as pct_of_cheapest
from products;

-- Window Functions Level 7: ntile, percent_rank, cume_dist
-- ntile(n)	splits the rows into n buckets of (nearly) equal size and gives the bucket number 1 to n
-- percent_rank()	(rank - 1) / (total rows - 1), a value from 0 to 1. The first row is always 0.
-- cume_dist()	rows with value <= current / total rows, a value above 0 up to 1. The last row is always 1.

-- Example 1: quartiles of salary (ntile
select emp_name,salary,ntile(4) over(order by salary desc) as quartile from employees;

-- Example 2: percent_rank and cume_dist side by side
select emp_name,salary,
round(percent_rank() over(order by salary),4) as pct_rank,
round(cume_dist() over(order by salary),4) as cume from employees;

-- Example 3: top 20% of earners (filter through a CTE)
with t as 
(select emp_name,salary,
cume_dist() over(order by salary desc) as cd from employees) 
select emp_name,salary from t where cd<=0.2;

-- Example 4: tiers of products by price
select product_name,price,ntile(3) over(order by price desc) as tier from products;

-- Example 5: customer spending quartiles (aggregate first, then ntile)
with s as 
(select c.customer_name,
sum(o.total_amount) as total_spent from customers c join orders o on c.customer_id=o.customer_id group by c.customer_id,c.customer_name) 
select customer_name,total_spent,ntile(4) over(order by total_spent desc) as spend_quartile from s;

-- Example 6: ntile inside a partition
select department,emp_name,salary,ntile(2) over(partition by department order by salary desc) as half from employees;

-- 1.Divide the employees into 4 salary quartiles, highest first.
select emp_id,emp_name,salary,ntile(4) over(order by salary desc) as salary_tier from employees;

-- 2.Divide the products into 3 price tiers, with the most expensive in tier 1.
select product_name,price,ntile(3) over(order by price desc) as prd_tire from products;

-- 3.Show each employee’s percent_rank by salary (rounded to 4 decimals).
select emp_name,salary,round(percent_rank() over (order by salary desc),4) as pct from employees;

-- 4.Show each employee’s cume_dist by salary, and explain why the two same salaries get the same value.
-- tie always gets same pct 
select emp_name,salary,
cume_dist() over(order by salary desc) as cume from employees;

-- 5.List the top 20% of employees by salary using cume_dist.
with e as 
(select emp_name,salary,
cume_dist() over(order by salary desc) as cume from employees)
select * from e where cume <= 0.2;

-- 6.List the products in the top price tier (tier 1 of 3).
with t as 
(select product_name,price,ntile(3) over(order by price desc) as tier from products) 
select product_name,price from t where tier=1;

-- 7.Split the customers (with orders) into 4 spending quartiles and show only quartile 1.
with s as 
(select c.customer_id,c.customer_name,sum(o.total_amount) as total_spent from customers c join orders o on c.customer_id=o.customer_id group by c.customer_id,c.customer_name),t as 
(select customer_name,total_spent,ntile(4) over(order by total_spent desc) as q from s) 
select customer_name,total_spent from t where q=1;

-- 8.Two price halves inside each category
select category,product_name,price,ntile(2) over(partition by category order by price desc) as half from products;

-- 9.Orders above the 90th percentile
with t as 
(select order_id,total_amount,percent_rank() over(order by total_amount) as pr from orders) 
select order_id,total_amount,round(pr,4) as pct_rank from t where pr>0.9;


-- Window Functions Level 8: Interview patterns
-- Pattern 1: Nth highest, overall and per group
with r as 
(select department,emp_name,salary,dense_rank() over(partition by department order by salary desc) as rnk from employees) select department,emp_name,salary from r where rnk=2;

-- Pattern 2: one row per group (latest, first, most expensive)
with t as 
(select customer_id,order_id,order_date,total_amount,row_number() over(partition by customer_id order by order_date desc,order_id desc) as rn from orders) 
select customer_id,order_id,order_date,total_amount from t where rn=1;

-- Pattern 3: finding duplicates and keeping one
with t as 
(select customer_id,customer_name,city,row_number() over(partition by city order by customer_id) as rn from customers) select * from t where rn>1;

-- Pattern 4: running total, the clean way
select order_id,total_amount,sum(total_amount) over(order by order_id rows between unbounded preceding and current row) as running_total from orders;

-- Pattern 5: gaps and islands (consecutive groups)
with t as 
(select order_id,order_id-row_number() over(order by order_id) as grp from orders where status='Delivered') 
select min(order_id) as start_id,max(order_id) as end_id,count(*) as len from t group by grp;

-- Pattern 6: compare to the previous row, then filter
with t as 
(select customer_id,order_id,total_amount,lag(total_amount) over(partition by customer_id order by order_date,order_id) as prev_amount from orders) 
select * from t where total_amount>prev_amount;
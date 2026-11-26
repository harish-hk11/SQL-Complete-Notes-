                                                     SQL 
                                                Day 1 Overview 


Data : raw facts

    ex : name, city, employee_id, adhaar_id, address 

Without Data ? 
    No Database, No ml , no ai 

Information : data with meaning

    ex : im harish from ooty.

Database : organized collection of data 

    ex : customer_db, sales_db

Database Management System : A Software to run our db 

    ex : MySqL, Sql Server, Oracle, Cassandra, Redshift etc...

Relational Dbms :  Tables are related to each other

    ex : customer table - customer_id
         order table - order_id , customer_id 

-----------------------------------------------------------------------------------

Entities : Table 

    ex : customers, employees 

Attributes : Columns

    ex : customer_id, employee_id 

Table : Rows x Columns 

Rows or Record : single information per id 

    ex : Harish ooty Tamilnadu

Columns or Field : 

    ex: name , city , state 

Cell : individual value 

    ex : 170 
-----------------------------------------------------------------------------------

Data Type :

    int - integer ex : 1 , 2 , -3
    float - ex : 1.0, 2.2
    varchar - ex : email
    text ex : notes 
    bool : true/false or 1/0
    date : ex : order_date 
-----------------------------------------------------------------------------------

Primary Key : Unique, Only one per table, no nulls, 

    ex : employee_id , aadhar_id , etc...

Foreign Key : Relate two tables 

    ex : customer_id(pk in customer_table) -> customer_id(fk in orders_table)
         aadhar_id(pk in aadhar table) -> aadhar card (fk in pan table)

Unique : No Duplicates, Can have many unique columns

    ex : email, phone, etc...

-----------------------------------------------------------------------------------

Relationships 

1 : 1 --> employee -> passport 

1 : M --> product -> many orders

M : 1 --> many orders -> product

M : M ---> students -> courses

-----------------------------------------------------------------------------------


Sql : Language used for communicating with database
      ** (Database Language) 

raw data:
harish   ooty  niligris  tamilnadu

information
Im harish from ooty -> place of living

2,4,6,8,10 -> raw data

2 * 1 = 2,
2**2 = 4 
2+4+6+8+10/5 = 30/5 = 6 

-----------------------------------------------------------------------------------

why data ?
without data we cant take any decisions.

why database?
all data needs to be stored in a single place

why dbms ?
we need a software to run a db

why sql?
language needed to communicate with db

table?
to store information in a rows and column format for easy and meaningfull data

keys
to define rules and related tables

sql --> english

sql is case insensitive -> SQL and sql both are same.

table name/column naming style -> snake case(preferred one)

    customers_raw , customers_clean

sql structured -> table format
    query -> select
    language -> communicate with db 

constraints -> rule for a column or table

    primary key, foreign key , unique, check - month (12) , not null -> no nulls in the column, 
    
    default 'India'

without foreign key ?
cant relate two tables

without primary key ?
duplicate rows are inserted

-----------------------------------------------------------------------------------

        -- database creation 
        create database cricket;

        --  to use the db
        use cricket;

DDL - Data Definition Language

        - create  alter drop truncate 

        -- DDL
        -- create table without keys (allows duplicate entry of data)

        create table players
        (id int, name varchar(30),country varchar(10));


        - Dhoni id is given twice still it gets inserted 

        insert  into players (id,name,country) values
        (1,'Dhoni','India'),(1,'Dhoni','India'),(2,'Dravid','India'), (3,'Warner','Australia');

        select id, name,country from players;

        - Created table with keys 

        create table cricket_player
        (id int  primary key, name varchar(30),country varchar(10));

        - Dhoni id is changed as Pk dont allow duplicate entry

        insert  into cricket_player (id,name,country) values
        (1,'Dhoni','India'),(4,'Dhoni','India'),(2,'Dravid','India'), (3,'Warner','Australia');


        Alter to Rename or Modify column or table names.

        -- alter table old_table_name   rename to new_table 
        alter table players rename to  cricket_players;

        -- alter column name
        alter table cricket_players rename column country to  nationality ;

        -- alter add column
        alter table player add column runs int ;

        -- drop a column
        alter table player drop column runs;

       -- Truncate :  table structure remains , data gets erased 
        truncate table player;

        - Drop : Drops entire table.
        
        drop table player;  

DQL
        - select 

        select 2 + 2 ;

        -- individual column
        select id from players;

        -- required column  (always preferred) 
        select id, name , country from players;

        -- all column
        select * from players;

DML - 
        - insert update delete

        column name must be given correctly or data insertion will be wrong

        insert into players (id,country,name) 
        values(4,'Virat','India'),(5,'India','Prasanth S');


        -- update : To change the existing data, when where clause not given all data gets changed
        -- where clause is must
           
           update players
           set country = 'India';


        -- update with where clause : only given id gets changed
            
            update player
            set name = 'MS Dhoni'
            where id = 1;

    
        -- delete : without where all gets deleted
            
           delete from players;

        -- delete with where only required id gets deleted
            
            delete from player
            where id = 4;



        -- auto_increment : gets id generated in sequence

        create table hello
        (id int auto_increment primary key , name varchar(30));

        insert into hello(name) values ('Harish'),('Prashanth'),('Kishore'),('Pradeesh'),('Raj Prakash');

        select id, name from hello;

--------------------------------------------------------------------------------------------------------------
create database sql_practice;

use sql_practice;

create table employees (
    employee_id int primary key,
    employee_name varchar(50),
    department varchar(30),
    city varchar(30),
    age int,
    salary decimal(10,2),
    experience int,
    joining_date date,
    email varchar(100)
);

insert into employees
(employee_id, employee_name, department, city, age, salary, experience, joining_date, email)
values
(1, 'arun', 'it', 'chennai', 25, 55000, 2, '2023-06-15', 'arun@gmail.com'),
(2, 'priya', 'hr', 'bangalore', 28, 48000, 4, '2021-03-20', null),
(3, 'rahul', 'it', 'chennai', 32, 85000, 8, '2018-07-10', 'rahul@gmail.com'),
(4, 'sneha', 'finance', 'coimbatore', 26, 62000, null, '2022-01-12', 'sneha@gmail.com'),
(5, 'karthik', 'it', 'bangalore', 24, 50000, 1, null, 'karthik@gmail.com'),
(6, 'divya', 'marketing', 'chennai', 30, 68000, 6, '2019-09-25', null),
(7, 'vijay', 'finance', 'mumbai', 35, 92000, 10, '2016-05-14', 'vijay@gmail.com'),
(8, 'meena', 'hr', 'coimbatore', null, 52000, 5, '2020-11-05', 'meena@gmail.com'),
(9, 'suresh', 'it', 'hyderabad', 27, null, 4, '2021-08-19', 'suresh@gmail.com'),
(10, 'anjali', 'marketing', 'bangalore', 31, 75000, null, '2018-12-03', 'anjali@gmail.com'),
(11, 'manoj', 'sales', 'chennai', 23, 42000, 1, null, null),
(12, 'kavya', 'finance', null, 27, 65000, 4, '2021-04-22', 'kavya@gmail.com'),
(13, 'rohit', 'sales', 'mumbai', 33, 78000, 9, '2017-10-16', null),
(14, 'pooja', 'it', 'coimbatore', 26, 58000, 3, '2022-08-08', 'pooja@gmail.com'),
(15, 'ajay', 'marketing', 'hyderabad', null, 61000, 5, '2020-02-27', 'ajay@gmail.com'),
(16, 'neha', 'hr', 'chennai', 34, null, 9, '2017-06-30', null),
(17, 'vishal', 'sales', null, 25, 46000, 2, '2023-01-17', 'vishal@gmail.com'),
(18, 'deepa', 'finance', 'hyderabad', 30, 81000, null, '2019-05-21', 'deepa@gmail.com'),
(19, 'ganesh', 'it', 'mumbai', 36, 98000, 12, null, 'ganesh@gmail.com'),
(20, 'keerthi', 'marketing', 'coimbatore', 24, 47000, 2, '2023-09-04', null);


select employee_id, employee_name, department, city, age, salary, experience, joining_date, email from employees;


-- select single column
select employee_id from employees;

-- select multiple columns
select employee_id,employee_name  from employees;

-- alias : nick name 
select employee_id as id , employee_name as name from employees;

-- calculated column
select employee_id, employee_name, department, city, age, salary, experience, joining_date, email , salary * 100 as hike from employees;

-- distinct : unique values
select  distinct city from employees;

select distinct department from employees;

-- where : filtering the data 

select  employee_id, employee_name, department, city, age, salary, experience, joining_date, email , salary  from employees
where city = 'chennai';

select  employee_id, employee_name, department, city, age, salary, experience, joining_date, email , salary  from employees
where department  = 'it';

-- operators
select  employee_id, employee_name, department, city, age, salary, experience, joining_date, email , salary  from employees
where experience < 3;

select  employee_id, employee_name, department, city, age, salary, experience, joining_date, email , salary  from employees
where experience > 3;

select  employee_id, employee_name, department, city, age, salary, experience, joining_date, email , salary  from employees
where experience =  3;

select  employee_id, employee_name, department, city, age, salary, experience, joining_date, email , salary  from employees
where experience >= 3;

select  employee_id, employee_name, department, city, age, salary, experience, joining_date, email , salary  from employees
where experience <= 3;

select  employee_id, employee_name, department, city, age, salary, experience, joining_date, email , salary  from employees
where experience  <> 2;

-- arthimetic

select 2 + 2 as addition;

select 2 - 2 as sub;

select 2 * 2  as mul ;

select 2/2 as division;

select 2  %  2  as modulo;

select floor(2/2)  as fd;

select pow(2,2) as power;

-- floor : down the number
select floor(10.8) as num;

-- ceil : up the number
select ceil(10.8) as num;

-- round : nearest 
select round(10.8) as num;
select round(10.2) as num;

-- logical opeartors
-- and
select employee_id , employee_name, city, department, salary from employees where city = 'chennai' and salary > 86000;

-- or
select employee_id , employee_name, city, department, salary from employees where city = 'chennai' or salary > 86000;

-- not 
 select employee_id , employee_name, city, department, salary from employees where not city = 'chennai';

-- Special operators
-- between
select employee_id , employee_name, city, department, salary from employees where salary between 25000 and 50000;

-- in
select employee_id , employee_name, city, department, salary from employees where city = 'chennai' or city = 'bangalore' or city = 'coimbatore';

select employee_id , employee_name, city, department, salary from employees where city in ('chennai','bangalore','coimbatore');

-- not in
select employee_id , employee_name, city, department, salary from employees where city not in ('chennai','bangalore','coimbatore');

-- like : pattern
select employee_id , employee_name, city, department, salary from employees where city like 'c%';

-- not like 
select employee_id , employee_name, city, department, salary from employees where city not like 'c%';

-- is null
select employee_id , employee_name, city, department, salary ,email from employees where email is null;

-- is not null
select employee_id , employee_name, city, department, salary ,email from employees where email is not null;


-- sorting
-- asc
select employee_id , employee_name, city, department, salary ,email from employees order by employee_name;

-- desc
select employee_id , employee_name, city, department, salary ,email from employees order by employee_name desc;

select employee_id , employee_name, city, department, salary ,email from employees order by employee_id, employee_name desc;

select employee_id , employee_name, city, department, salary ,email from employees where salary is not null 
order by employee_id, employee_name desc;

-- limit : to reduce rows 
select employee_id , employee_name, city, department, salary ,email from employees  limit 5 ;

-- offset : to get values after limit
select employee_id , employee_name, city, department, salary ,email from employees  limit 5 offset 6  ;

-- top 5 salary 
select employee_id , employee_name, city, department, salary ,email from employees order by salary desc limit 5;

-- bottom 5 salary
select employee_id , employee_name, city, department, salary ,email from employees where salary is not null order by salary  limit 5;

-- case
select employee_id , employee_name, city, department, salary ,
case  when salary is null then 'Yet To Be Paid'
		 when salary > 70000 then 'Highly Paid'
		 when salary > 60000 then 'Medium'
         else 'Low'
         end as salary_status
from employees;

select employee_id , employee_name, city, department, salary ,
case when salary is not null then 'Yet to be Paid' else 'Paid' end as salary_credited from employees;


-- aggregation
-- count 
select count(*) as total_rows from employees;
select count(1) as total_rows from employees;

-- sum
select sum(salary) as total_payouts from employees;

-- avg
select round(avg(salary),2) as total_payouts from employees;

-- min
select min(salary) as minimum_salary from employees;

-- max
select max(salary) as maximum_salary from employees;



Chennai, Coimbatore, Calicut, Cuddalore


Like C% - Chennai, Coimbatore, Calicut, Cuddalore
Like _h% - Chennai
Like Coim% - Coimbatore
Like %t - Calicut

_ no of characters
% nth length of characters

------------------------------------------------------------------------------------------------

group by : grouping them based on required fields

    ex : city, department

having : filter records after group by 

-- group by 

select city , count(1) as total_emp from employees group by city;

select department, count(*) as total_emp from employees group by department; 

-- having 

select city , count(1) as total_emp from employees group by city having count(1) > 3;

select department, count(*) as total_emp from employees group by department having count(1) > 3;

select department, sum(salary) as total_salary from employees group by department having sum(salary) > 100000;


---------------------------------------------------------------------------------------------------------------

CREATE TABLE customers (
  customer_id INT PRIMARY KEY,
  firstname   VARCHAR(50),
  lastname    VARCHAR(50),
  city        VARCHAR(50),
  join_date   DATE,
  score       INT
);

INSERT INTO customers (customer_id, firstname, lastname, city, join_date, score) VALUES
(1, '      Trent',    ' ARNOLD',  'MADRID',         '2026-06-05', 400),
(2, '       rico',    'Lewis',    'Manchester     ', '2026-06-06', 600),
(3, 'ERLING',         '    haaland', 'Manchester',  '2026-06-07', 450),
(4, '   cristiano',   'Ronaldo',  NULL,             '2026-06-08', 600),
(5, '      lionel',   'messi',    'Miami',          '2026-06-09', 500),
(6, 'Neymar ',        'Junior',   'Santos',         '2026-06-10', NULL);

CREATE TABLE products (
  product_id   INT PRIMARY KEY,
  product_name VARCHAR(50),
  category     VARCHAR(30),
  price        INT,
  stock        INT
);

CREATE TABLE orders (
  order_id    INT PRIMARY KEY,
  customer_id INT,
  product_id  INT,
  quantity    INT,
  order_date  DATE,
  ship_date   DATE,
  status      VARCHAR(20),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  FOREIGN KEY (product_id)  REFERENCES products(product_id)
);

INSERT INTO products (product_id, product_name, category, price, stock) VALUES
(1, 'Football Boots', 'Sports',  8000, 25),
(2, 'Jersey',         'Apparel', 3500, 60),
(3, 'Football',       'Sports',  2000, NULL),
(4, 'Sunglasses',     NULL,      1500, 40),
(5, 'Gloves',         'Sports',  1200, 15);

INSERT INTO orders (order_id, customer_id, product_id, quantity, order_date, ship_date, status) VALUES
(101, 1, 1, 1, '2026-06-11', '2026-06-13', 'Delivered'),
(102, 1, 2, 2, '2026-06-15', '2026-06-18', 'Delivered'),
(103, 2, 3, 3, '2026-06-12', NULL,         'Pending'),
(104, 3, 2, 1, '2026-06-20', '2026-06-22', 'Delivered'),
(105, 3, 5, 2, '2026-07-02', NULL,         'Pending'),
(106, 4, 4, 1, '2026-07-05', '2026-07-09', 'Delivered'),
(107, 5, 1, 2, '2026-07-10', '2026-07-12', 'Delivered'),
(108, 5, 3, 1, '2026-07-15', NULL,         'Cancelled'),
(109, 2, 2, 1, '2026-08-01', '2026-08-04', 'Delivered'),
(110, NULL, 5, 1, '2026-08-10', '2026-08-12', 'Delivered');

-- inner join : only matching records from the tables joined

select 
c.customer_id, o.order_id, o.product_id 
from
orders as o
inner join 
customers c 
on
c.customer_id = o.customer_id;

-- left join : all values from left and matching values from the joined table remaining as null

select 
c.customer_id, o.*
from
orders as o
left join 
customers c 
on
c.customer_id = o.customer_id;


-- right join : all values from right and matching values from the joined table remaining as null

select 
c.customer_id, o.*
from
orders as o
right join 
customers c 
on
c.customer_id = o.customer_id;


-- full join : use union left and right : matching and unmatching all records are displayed.

select 
c.customer_id, o.*
from
orders as o
left join 
customers c 
on
c.customer_id = o.customer_id
union
select 
c.customer_id, o.*
from
orders as o
right join 
customers c 
on
c.customer_id = o.customer_id;


-- union : removes duplicates , same number of columns should be given in the query

select customer_id from customers
union
select customer_id from orders;

-- union all : all records , same number of columns should be given in the query

select customer_id from customers
union all
select customer_id from orders;


select * from customers;

-- string function
-- upper() : ALL UPPERCASE
select firstname, upper(firstname) as upper_case from customers;

-- lower() : all lowercase
select firstname, lower(firstname) as lower_case from customers;

-- length() : length of the column
select firstname,length(firstname) as firstname_len from customers;

-- char_length : length of character
select char_length('text') as character_len;

-- trim() : removes spaces
select firstname,trim(firstname) as clean_fn from customers;

select firstname,length(firstname) as firstname_len_raw , trim(firstname) as trim_fn , length(trim(firstname)) as firstname_clean_len from customers;

-- concat() : combine all columns 
select firstname,lastname,trim(concat(firstname,' ',ltrim(lastname))) as fullname from customers;

select * from customers;

-- replace : to replace something
select lastname,replace(lastname,' ','') as replaced_word from customers;

select replace('Harish kumar','kumar','R');

-- substring() : extracting part
select city,substring(city,1,3) as word_extract from customers;

select substring('icecream',1,3);

select firstname , concat(upper(substring(trim(firstname),1,1)) , lower(substring(trim(firstname),2))) as clean_firstname from customers;

-- upper(substring(trim(firstname),1,1))   - harish -> H 
-- lower(substring(trim(firstname),2)) - harish -> arish
-- concat(H,arish) -> Harish

-- Null function

select * from customers;

-- is null : finding column having nulls
select * from customers where score is null;

-- is not null  : finding column having no nulls
select * from customers where score is not null;

-- if null : use the value if null in the column
select avg(score) from customers;
select avg(ifnull(score,0)) from customers;

-- coalesce : replace nulls
select firstname,city, coalesce(city,'Unknown')  from customers;

-- nullif : if column and the given value is same then mark as null
select score,nullif(score , 600) from customers;


-- data function

select * from orders;

-- current date
select curdate() as current_date;

-- current time
select curtime() as current_time;

-- now
select now() as timestamp;

-- date
select date(now()) as today_date;

-- year
select order_date,year(order_date) as order_year from orders;

-- month
select order_date,month(order_date) as month_orders from orders;

-- day
select order_date,day(order_date) as day_order from orders;

-- dayname
select order_date,dayname(order_date) as order_dn from orders;

-- monthname
select order_date,monthname(order_date) as month_name from orders;

-- date_add
select order_date, date_add(order_date, interval 3 day)  avg_delivery_date from orders;

-- date_sub
select order_date, date_sub(order_date, interval 3 day)   login_date from orders;

-- date format
select order_date, date_format(order_date, '%d - %m - %Y')   login_date from orders;

-- str to date
select str_to_date('09-09-2026','%d - %m - %Y');

-- custom format
select date_format(str_to_date('09-09-2026','%d - %m - %Y'),'%d - %m - %Y');

-----------------------------------------------------------------------------------------------------


-- Subquery or CTE

create database subquery_cte;
use subquery_cte;

CREATE TABLE departments
(
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50)
);

CREATE TABLE employees
(
    employee_id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10,2),
    department_id INT,
    joining_date DATE,
    FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);

INSERT INTO departments
(department_id,department_name)
VALUES
(1, 'IT'),
(2, 'HR'),
(3, 'Finance'),
(4, 'Sales'),
(5, 'Operations');

INSERT INTO employees
(employee_id,name,salary,department_id,joining_date)
VALUES
(1,  'Arun',    50000, 1, '2021-01-15'),
(2,  'Ravi',    70000, 1, '2021-03-20'),
(3,  'Kumar',   90000, 1, '2020-06-10'),
(4,  'Bala',    45000, 2, '2022-02-14'),
(5,  'Vijay',   60000, 2, '2021-07-19'),
(6,  'Suresh',  75000, 2, '2020-11-05'),
(7,  'Priya',   55000, 3, '2022-01-10'),
(8,  'Divya',   80000, 3, '2021-05-25'),
(9,  'Meena',   95000, 3, '2019-09-18'),
(10, 'Karthik', 40000, 4, '2023-01-12'),
(11, 'Ajay',    65000, 4, '2022-08-16'),
(12, 'Manoj',   85000, 4, '2020-04-22'),
(13, 'Deepak',  48000, 5, '2023-03-15'),
(14, 'Naveen',  72000, 5, '2021-10-11'),
(15, 'Gokul',   88000, 5, '2020-12-01');

--  subquery : query inside another query
-- outer query depends on inner query
-- employees earning more than average salary - most important

-- scalar subquery : one value
 select * from employees
 where salary > (
 select avg(salary) as average_salary from employees);
 
-- single row : one  row
 select * from employees
 where salary = (select max(salary) as max_salary from employees);
 
 -- mutli row : returns multiple rows
 select * from employees where department_id  in (select department_id from departments);
 
 -- in
  select * from employees where department_id  in (select department_id from departments where department_id in (1,3));
 
 -- not in :
  select * from employees where department_id  not in (select department_id from departments where department_id in (1,3));
  
  -- exists : value exists in both tables
  select * from employees e where exists(select * from departments d where e.department_id = d.department_id);
 
 -- not exists
  select * from employees e where not exists(select * from departments d where e.department_id = d.department_id);
  
  -- correlated subquery : inner query depends on outer query
  select * from employees e where salary < (select avg(e1.salary) from employees e1 where e1.department_id = e.department_id);
  
-- non correlated subquery : inner query dont depend on outer query
select * from employees where salary > (select avg(salary) as average_salary from employees);

-- using select 
select name ,salary,(select avg(salary)  from employees) as average_salary from employees;

-- cte : temporary result set , doesn't create tables
with cte_emp as 
(
select employee_id,name,salary,department_id,joining_date from employees group by employee_id having sum(salary) > 80000
)
select * from cte_emp where salary < (select avg(salary) from cte_emp);

with clean_data as 
( select * ,upper(name) as name_upper from employees)
select name,name_upper  from clean_data;

-- recursive cte 
-- anchor : holding 
-- recursive : sequence 

with recursive num as 
(
	select 1 as num1
    union all
    select num1 + 1
    from num where num1 < 10
)
select * from num;

--------------------------------------------------------------------------------------------------------

create database sql_window_functions;

use sql_window_functions;

CREATE TABLE 
sales (id INT, emp VARCHAR(20), dept VARCHAR(20), amount INT, sale_date DATE);

INSERT INTO sales (id, emp, dept, amount, sale_date) VALUES
(1,  'Alice',  'Electronics', 5000, '2026-01-05'),
(2,  'Bob',    'Electronics', 3000, '2026-01-07'),
(3,  'Carol',  'Electronics', 5000, '2026-01-07'),
(4,  'Dave',   'Electronics', 1500, '2026-01-12'),
(5,  'Eve',    'Clothing',    2000, '2026-01-06'),
(6,  'Frank',  'Clothing',    4500, '2026-01-08'),
(7,  'Grace',  'Clothing',    4500, '2026-01-10'),
(8,  'Heidi',  'Clothing',    1200, '2026-01-15'),
(9,  'Ivan',   'Furniture',   7000, '2026-01-09'),
(10, 'Judy',   'Furniture',   6500, '2026-01-11'),
(11, 'Kyle',   'Furniture',   3000, '2026-01-14'),
(12, 'Laura',  'Furniture',   3000, '2026-01-14');


-- group by 

select dept, sum(amount) as total_amount from sales group by dept;

-- windows functions : calculation across set of rows

select  sum(amount) over() as total_amount from sales;

select  dept,sum(amount) over(partition by dept) as total_amount from sales;

-- ranking functions

-- row_number: assign numbers to all rows 

select  dept, amount,row_number() over( order by amount desc) as rw_num from sales;

select  dept, amount,row_number() over(partition by  dept order by amount desc) as rw_num from sales;

-- rank : assigns ranks , skip a sequence when tie found

select  dept, amount,rank() over( order by amount desc) as rw_num from sales;

select  dept, amount,rank() over(partition by  dept order by amount desc) as rw_num from sales;

-- dense_rank : assigns ranks , doesn't skip a sequence when tie found

select  dept, amount,dense_rank() over( order by amount desc) as rw_num from sales;
select  dept, amount,dense_rank() over(partition by  dept order by amount desc) as rw_num from sales;

select  dept, amount,row_number() over( order by amount desc) as rw_num,
rank() over( order by amount desc) as rank_num,
dense_rank() over( order by amount desc) as dr_num 
from sales;

-- aggregation

select 
	dept, sum(amount) over(partition by dept) as dept_sum,
	min(amount) over(partition by dept) as dept_min,
	max(amount) over(partition by dept) as dept_max,
	count(*) over(partition by dept) as dept_count,
	avg(amount) over(partition by dept) as dept_avg,amount
from sales;

-- ntile : seperate rows into buckets

select dept,amount,sale_date, ntile(3) over( order by amount desc) as bucket from sales;

-- lag and lead
-- lag : previous value 

select emp,dept, sale_date,amount,lag(amount) over(order by sale_date) as previous_amt from sales;

-- lead : next value

select emp,dept, sale_date,amount,lead(amount) over(order by sale_date) as next_amt from sales;


select
 emp,dept, sale_date,amount,
lag(amount) over(order by sale_date) as previous_amt,
lead(amount) over(order by sale_date) as next_amt
from sales;

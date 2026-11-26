-- SQL SETS : A set operator treats each result as a set of rows and removes duplicates by default

-- RULES :
	-- 1. Same Columns count in both queries.
    -- 2. Datatype must be matched by position.
    -- 3. Column Names are from first query
    -- 4. Rows are compared on the selected columns.
    

create database sets_practice;
use sets_practice;


create table online_customers 
(id int,name varchar(20),city varchar(20));

create table store_customers 
(id int,name varchar(20),city varchar(20));

insert into online_customers values
(1,'Asha','Chennai'),
(2,'Ravi','Coimbatore'),
(3,'Meena','Madurai'),
(4,'Kiran','Chennai');

insert into store_customers values
(3,'Meena','Madurai'),
(4,'Kiran','Chennai'),
(5,'John','Salem'),
(5,'John','Salem'),
(6,'Divya',null);


-- UNION : removes duplicates .. ex : when we merge two data if ids are repeated it will get removed
			-- id : 3 and 4 are not extracted from the 2nd table as we use union.
            
select id,name,city from online_customers
union 
select id,name,city from store_customers;

-- UNION ALL : all rows from both tables , keeps duplicates and also faster in execution 
			-- id : 3 and 4 and 5 are extracted from the 2nd table as we use union all.
            
select id,name,city from online_customers
union all
select id,name,city from store_customers;

-- INTERSECT : rows that are present in both tables (same as inner join) 
			-- id 3 and 4 are in both tables
            
select id,name from online_customers
intersect
select id,name from store_customers;

-- EXCEPT : rows in first table that are not in second table(same as left join and 2nd table id must be null)
			-- ex : id 1 and 2
            
select id,name from online_customers
except
select id,name from store_customers;

-- Advance SETS
-- 1. Symmetric Difference : In one table but not both

(select id,name from online_customers except select id,name from store_customers)
union 
(select id,name from store_customers except select id,name from online_customers);

-- 2. Source Table for each row
select id, name, 'Online' as source from online_customers
union all
select id,name,'Store' from store_customers;

-- 3. Order and Limit
select id, name from online_customers
union 
select id,name from store_customers
order by name
limit 3 ;

-- 4. Intersect runs before union and except as put them in bracket
(select id from online_customers
union
select id from store_customers)
intersect
select id from online_customers;

-- 5. Nulls are treated equally in sets not like join or where
select city from online_customers
union 
select city from store_customers;

-- 6. Aggregate over a union : get rows count from both tables 
select source, count(1) as rows_count from 
(
select id, name, 'Online' as source from online_customers
union all
select id,name,'Store' from store_customers) a
group by source;

-- 7. INTERSECT ALL/ EXCEPT ALL : Keeps all duplicate counts
select id,name from store_customers
except all
select id,name from online_customers;

select id,name from store_customers
intersect all
select id,name from online_customers;

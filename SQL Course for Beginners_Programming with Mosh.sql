-- CREATING THE DATABASE
	-- Open SQL Script file -> Create databases
		-- INSERT INTO
		-- CREATE TABLE
		-- PRIMARY KEY
        
-- When someone change his address
-- Instead of changing data in table orders (for all orders that customer have) 
-- We change data in table Customers
-- Table Customers has relation with table Orders via customer_id

-- SELECT CLAUSE
use sql_store;
select *
from customers -- optional CLAUSE
where customer_id=1 -- optional CLAUSE
order by first_name; -- optional CLAUSE

select 1,2;

-- Return all the products
	-- name
	-- unit price
	-- new price (unit price*1.1)
select name, unit_price as 'Unit price', unit_price*1.1 as 'New price' 
from products;

-- Get orders placed this year
select order_id
from orders
where order_date >= "2019-01-01";

-- AND, NOT, OR
select *
from customers
where not (birth_date>"1990-01-01" or points>1000);

-- From the order_items table get the items
	-- for order #6
	-- where the total proce is greater than 30
select *
from order_items
where order_id=6 AND unit_price*quantity>30;

-- THE IN OPERATOR
select *
from customers
where state in ("va","fl","ga");

-- Return products with
	-- quantity in stock equal to 49, 38,72
select *
from products
where quantity_in_stock in (49,38,72);

-- THE BETWEEN OPERATOR
select*
from customers
where points between 1000 and 3000;

-- Return customers born
	-- between 1/1/1990 and 1/1/2000
select*
from customers
where birth_date between "1990-01-01" and "2000-01-01";

-- THE LIKE OPERATOR
select*
from customers
where last_name like 'b%'; -- starts with b, 

-- %= any number of characters
select*
from customers
where last_name like '%b%'; -- any number of characters before and after b

-- _=single character
select*
from customers
where last_name like '_____y'; -- 5 characters before y, 

-- Get the customers whose
	-- addressed contain TRAIl or AVENUE
	-- phone numbers end with 9
select*
from customers
where address like ('%TRAIL%' or address like '%AVENUE%') and phone like '%9'; -- Note that OR is primarly calculated

-- THE REGEXP OPERATOR (Regular expression)
	-- ^ g=beginning
	-- $ end
	-- | logical or
	-- [abcd] list
	-- [a-f] range 

select*
from customers
-- where last_name LIKE'%field%'
where last_name regexp 'field';

select*
from customers
where last_name regexp '^field'; -- string starts with 'field'

select*
from customers
where last_name regexp 'field$'; -- string ends with 'field'

select*
from customers
where last_name regexp 'field|mac|rose'; -- contain 'field' OR contain 'mac' OR contain 'rose'

select*
from customers
where last_name regexp '[gim]e';  -- contain ge OR ie OR me

select*
from customers
where last_name regexp 'e[fmq]'; -- character e followd by f OR m OR Q

select*
from customers
where last_name regexp '[a-i]e' ; -- from a to i

select*
from customers
where last_name regexp 'field' or 'mac' or 'rose';


-- EXCERCISE
	-- Get the customers whose:
		-- first names are ELKA or AMBUR
		-- last names end with EY or ON
		-- last names start with MY or contains SE
		-- last anmes conatin B followed by R or U

select*
from customers
where first_name regexp "ELKA|AMBUR";

select*
from customers
where last_name regexp "EY$|ON$";

select*
from customers
where last_name regexp "^MY|se";

select*
from customers
where last_name regexp "b[r|u]";

-- IS NULL OPERATOR
select*
from customers
where phone is null;

-- Get the orders that are not shipped
select*
from orders
where shipped_date is null;

-- ORDER BY CLAUSE
select first_name, last_name, 10 as points -- you can sort customers based on their birth date even though it is not selected
from customers
order by points, birth_date;

select first_name, last_name -- avoid order by column number, it is unpredictable
from customers
order by 1,2;

-- EXCERCISE: from table order items select order_id number 2 and sort them based on total price in dsc order
select *
from order_items
where order_id=2
order by quantity*unit_price desc;

-- LIMIT CLAUSE
select*
from customers
limit 300;

select*
from customers
limit 6,3; -- skip first 6 and show next 3 rows

-- Get the top three loyal customers
select*
from customers
where 1=1
order by points desc
limit 3;


-- INNER JOINS
select order_id, first_name, last_name, c.customer_id
from orders o
inner join customers c -- you dont have to type 'INNER'
	on o.customer_id=c.customer_id;
  
-- EXCERCISE 
	-- Table order_items, join table with products table 
	-- Note that even if the unit_price is stated in both tables it is not the same, one is current price of product and second is a price at the time of order
select order_id, oi.product_id, p.unit_price*quantity AS price
from order_items oi
join products p 
	on p.product_id=oi.product_id ;
    
-- JOINING ACCROS DATABASES
	-- Join order_items table in database sql_store with products table in database sql inventory 
use sql_store;

select*
from order_items oi
join sql_inventory.products p
	on oi.product_id=p.product_id;
    
-- SELF JOINS
	-- Table of employes has column with superior manager number stated, hovewer manager is also an employee hovewer has no superior manager
use sql_hr;
select
e.employee_id,
e.first_name,
m.first_name as manager
from employees e
join employees m
		on e.reports_to=m.employee_id;
        
-- JOINING MULTIPLE TABELS 
	-- In table ORDERS we have column Status (1,2,3) hovewer using external table we want status to be displayed by words
use sql_store;
select o.order_id, o.order_date, c.first_name, c.last_name, os.name as status
from orders o
join customers c
	on o.customer_id=c.customer_id
join order_statuses os
    on o.status=os.order_status_id;
    
-- EXCERCISE
	-- Table Paymemts join with Table Clients join with table Payment_Methods
use sql_store;
select p.invoice_id, p.date, p.amount,c.last_name, pm.name
from customers c
join sql_invoicing.payments p
	on c.customer_id=p.client_id
join sql_invoicing.payment_methods pm
	on p.payment_method=pm.payment_method_id
join sql_invoicing.clients cl
	on cl.client_id=c.client_id;
    
    
 -- CORRECT CODE   
use sql_invoicing;
select p.date, p.invoice_id, p.amount, c.name, pm.name
from payments p
join clients c
	on p.client_id=c.client_id
join payment_methods pm
	on p.payment_method=pm.payment_method_id;
    
-- COMPOUND JOINED CONDITIONS 
	-- Table order_items have 2 columns set as PRIMARY KEY product_id and order_id
	-- join table order_items with table order_item_notes
use sql_store;
select *
from order_items oi
join order_item_notes oin
	on oi.order_id=oin.order_id
    and oi.product_id=oin.product_id;
    
-- IMPLICIT JOIN SYNTAX
	-- Sugest not use, because when you forget to use WHERE CLAUSE you will get crosscheck
	-- Let's see difference between explicit and implicit, they provide same output
		-- explicit join syntax:
select *
from orders o
join customers c
	on o.customer_id=c.customer_id;
		-- implicit join syntax:
select *
from orders o, customers c
where o.customer_id=c.customer_id;

-- OUTER JOIN 
	-- INNER JOIN=JOIN
	-- OUTER LEFT JOIN= LEFT JOIN
	-- OUTER RIGHT JOIN= RIGHT JOIN

-- Inner join
	-- We only see customers who have order, when we want to see all customers whether they have order or not we use OUTER JOIN
use sql_store;
select c.customer_id, c.first_name, o.order_id
from customers c
join orders o
on c.customer_id=o.customer_id
order by c.customer_id;

-- Outer join LEFT
use sql_store;
select c.customer_id, c.first_name, o.order_id
from customers c
left outer join orders o
on c.customer_id=o.customer_id /* all the records from the LEFT table (customer table) are returned even if this condiiton is not TRUE*/
order by c.customer_id;

-- Outer join RIGHT 
use sql_store;
select c.customer_id, c.first_name, o.order_id
from customers c
right join orders o
on c.customer_id=o.customer_id; /* all the redords from the RIGHT table (orders table) are returned even if this condiiton is not TRUE*/

-- Output is the same as when using INNER JOIN, when we still want to see all the records we have to swap the tables
use sql_store;
select c.customer_id, c.first_name, o.order_id
from orders o
right join customers c
	on c.customer_id=o.customer_id ;

-- EXCERCISE 
	-- How many times each product is ordered?
	-- We want 3 columns product_id (products table), name (products table), quantity (order items table)
	-- Use OUTER JOIN so we can see also products that have not been ordered
use sql_store;
select p.product_id, p.name, oi.quantity
from products p
LEFT JOIN order_items oi
	ON p.product_id=oi.product_id;
    
-- OUTER JOINS BETWEEN MULTIPLE TABLES
use sql_store;
select c.customer_id, c.first_name, o.order_id, sh.name as shipper
from customers c
LEFT JOIN orders o
	ON c.customer_id=o.customer_id
LEFT JOIN shippers sh
	ON o.shipper_id=sh.shipper_id /* this condition is NOT TRUE for some of he orders, therefore we use LEFT JOIN*/
order by c.customer_id;
-- this code above can be done using RIGHT JOIN by swaping tables, hovewer BEST PRACTICE is to AVOID RIGHT JOIN for better clearance of code

-- EXCERCISE 
	-- Return table with columnsorder date, order id , first name, shipper (all orders with no shipper yet included), status
use sql_store;
select o.order_id, o.order_date, c.first_name as customer, s.name as shipper, os.name as status
from orders o
left join shippers s /* we want all orders, not only the ones shiped, wheter they have shiper or not*/
	on o.shipper_id=s.shipper_id /*note that all tables are joined woth table ORDERS*/
join customers c /* left join not needed*/
	on o.customer_id=c.customer_id
join order_statuses os
	on o.status=os.order_status_id; /* note that colums name do not match*/
    
-- SELF OUTER JOINS 
 -- We have employees table and each employee has atribute "reports_to_manager" which is also an employee
 -- Get all the employees and their manager
use sql_hr;
select e.employee_id, e.first_name, m.first_name as manager
from employees e
left join employees m /* left join bc we want all employees, also the ones that have atribute manager null*/ 
on e.reports_to=m.employee_id ;

-- THE USING CLAUSE 
	-- Applicable only when PRIMARY KEY has same name in both tables!
use sql_store;
select o.order_id, c.first_name, s.name as shipper
from orders o
join customers c
	-- on o.customer_id=c.customer_id ... same as USING
	USING (customer_id)
left join shippers s
	USING (shipper_id);
    
	-- Table with 2 PRIMARY KEYS
		-- table "order_items" has 2 primary keys "order_id" and "product_id"
use sql_store;
select *
from order_items oi
left join order_item_notes oin
	-- on oi.order_id=oin.order_id AND oi.product_id=oin.product_id .... same as USING
	USING (order_id, product_id);
    
-- EXCERCISE
-- Return Date, Client, Amount, Name (Paymemt Method)
 use sql_invoicing;
 select p.date, cl.name, p.amount, pm.name as payment_method
 from payments p
 left join clients cl using (client_id)
 join payment_methods pm
	on (p.payment_method=pm.payment_method_id); -- we can NOT use USING CLAUSE as primary keys do not match in names
    
-- NATURAL JOINS
 -- Not recommended because of unexpected results
use sql_store;
select o.order_id, c.first_name
from orders o
natural join customers c; -- we do not have control over join

-- CROSS JOIN 
 -- usufull, when you have table of colours and table of sizes, and you want to know all the combinations
 -- EXPLICIT SYNTAX
use sql_store;
select c.first_name as customer, 
	   p.name as product
from customers c
cross join products p 
order by c.first_name;

 -- IMPLICIT SYNTAX
use sql_store;
select c.first_name as customer, p.name as product
from customers c,  products p 
order by c.first_name;

-- EXCERCISE 
	-- Do a cross join between shippers and producrs using implicit and explicit syntax
use sql_store;
select *
from shippers s
cross join products p 
order by s.name;

use sql_store;
select s.name as shipper, p.name as product
from shippers s, products p
order by s.name;

-- UNIONS 
	-- Combine records from 2 queries from one table
	-- SAME TABLE (label 'active' for orders in CY, label 'archived' for orders in PY)
select 
	order_id, 
	order_date, 
    'active' as status
from orders
where order_date>='2019-01-01' -- hard coded date, code is not usable in future
UNION /* combine records from multiple queries*/
select 
	order_id, 
    order_date, 
    'archived' as status
from orders
where order_date<'2019-01-01'; 

-- UNIONS
	-- Combine records from 2 queries from 2 different tables
	-- DIFFERENT TABLES
    -- !you have to choose same number of columns from each table for sql to combine them
select first_name as "name of customer/shipper" -- name of the column is determined by first select
from customers c
union
select name
from shippers s;

-- EXCERCISE
	-- customer_id, first_name, points, type 
    -- Type is calculated column
		-- <2000 BRONZE
		-- 2000-3000 SILVER
		-- >3000 GOLD
use sql_store;
select c.customer_id, c.first_name, c.points, "BRONZE" as type
from customers c
where c.points<2000
	UNION
select c.customer_id, c.first_name, c.points, "SILVER" as type
from customers c
where c.points between 2000 and 3000
	UNION
select c.customer_id, c.first_name, c.points, "GOLD" as type
from customers c
where c.points>3000
order by first_name;
-- chat GPT chyba: v dotaze s UNION nemôžeš používať alias tabuľky (c) v ORDER BY klauzule, pretože aliasy tabuliek (napr. c) nie sú dostupné na globálnej úrovni výsledku UNION

-- COLUMN ATRIBUTES 
/* Data type 
		INT(11) ... only expect integer number (withiut decimal points)
		VARCHAR(50)=variabel character ... maximum lenght is 50
		CHAR(50) = character... sql will always store 50 characters by adding empty characters
	PK=primary key
	NN= not nul ... if checked, sql does not exept null values f.e. for customer_ID whoch is obligatory to fill in
	AI= auto increment, everytime you enter new record you let sql insert value in this columun, which can be used for customer_id
	Default
		NULL ... if you don fill in, sql will use what you've set, in this case NULL
		'0'... if you don fill in, sql will use what you've set, in this case '0' 
*/

-- INSERTING A SINGLE ROW        
insert into customers
values (default, 
		'John', 
        'Smith',
        '1990-01-01',
        NULL, 
        'adress',
        'city',
        'ca',
        default);

-- We can optionaly supply the list of columns
	-- It can be listed in any order (however columns in insert must match values)
insert into customers (first_name, last_name, birth_date, address, city, state) 
values ('John', 
		'Smith',
        '1990-01-01',
        'address',
        'city','ca');

-- INSERTING MULTIPLE ROWS
insert into shippers (name)
values ('shipper1'),
		('shipper2'),
        ('shipper3');

-- EXCERCISE 
	-- Write statment to add 3 rows in product table
insert into products 
values (default,'Product1', 2, 5.7), 
		(default,'Product2', 2, 5.7), 
        (default,'Product3', 2, 5.7);
        
-- INSERTING HIERARCHICAL ROWS
	-- order_items table is CHILD, orders table is PARENT =>  one order can have more order items
insert into orders (customer_id, order_date, status)
values (1, '2019-01-01',1);
insert into order_items
values 
	(last_insert_id(),1,1,2.95),
	(last_insert_id(),2,1,3.95);
    
-- CREATING A COPY OF A TABLE
create table orders_archived as
select * -- SELECT used as a subquery in CREATE TABLE statement
from orders;

-- DELETE DATA FROM TABLE
	-- We have deleted data from table orders_archived by clicking RIGHT on table => TRUNCATE TABLE

-- INSERTING DATA
-- now we copy data only before 2019-01-01
insert into orders_archived
select * -- SELECT used as a subquery in INSERT INTO statement
from orders where order_date <'2019-01-01';

-- EXCERCISE
	-- Invoices table (Invoice_id, number, client_id, invoice_total, payment_total)
    -- We want to create a copy of this records and put them in new table called INVOICES ARCHIVED
    -- Insted of clien_id column we want to have client_name column => join with CLIENT TABLE and use that query as a subquery in create table statement
    -- Copy only invoices that do have payment (payment_date)
use sql_invoicing;
create table invoices_archived as
select i.invoice_id, i.number, c.name as client, i.invoice_total,i.payment_total, i.invoice_date, i.due_date, i.payment_date
from invoices i
join clients c
	using (client_id)
where payment_date is not null;

-- UPDATING A SINGLE ROW
update invoices
set payment_total=default, payment_date= NULL
where invoice_id=1;

update invoices
set payment_total=invoice_total *0.5, 
payment_date= due_date
where invoice_id=3;

-- UPDATING MULTIPLE ROWS
	-- Update all invoice for specific cleint, i.e. client #3
update invoices
set payment_total=invoice_total *0.5, 
payment_date= due_date
where client_id=3;

-- SAFE MODE
	-- My SQL Workbecnh -> Preferences -> SQL Editor-> Safe Uodates (Reject UPDATE and DELETE)

update invoices
set 
payment_total=invoice_total *0.5, 
payment_date= due_date
where client_id IN(3,4);

-- EXCERCISE
	-- Write a SQL statement to give any customers born before 1990 
	-- 50 extra points
use sql_store;
update customers
set points=points+50
where birth_date<'1990-01-01';

-- USING SUBQUERIES IN UPDATE STATEMENT
	-- Let's say we only have a name of the client
	-- We need to first find client_id and than use it to update all the invoices
update invoices
set 
payment_total=invoice_total *0.5, 
payment_date= due_date
where client_id =
	(select client_id
	from clients
	where name='Myworks');

	-- Update payments where state is CA and NY
update invoices
set 
payment_total=invoice_total *0.5, 
payment_date= due_date
where client_id IN -- IN
	(select client_id
	from clients
	where state IN ('CA','NY')); -- IN
    
	-- Update all the invoices where payment date is NULL    
update invoices
set 
payment_total=invoice_total *0.5, 
payment_date= due_date
where client_id IN
	(select client_id
	from clients
	where payment_date is null);
    
-- EXERCISE
	-- Orders table
    -- Customers who have more than 3000 points
    -- Update comemnt column to gold customer
use sql_store;
update orders
set 
comments= 'gold customer'
where customer_id IN
(select customer_id from customers
where points>3000);

-- DELETING ROWS
use sql_invoicing;
delete from invoices
where client_id=(
	select * 
	from clients
	where name='Myworks')
    
-- RESTORING THE DATABASE
-- File-> OPEN SQL Script-> Open-> Execute the code-> Refresh SCHEMAS







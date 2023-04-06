-- Displaying tables contents for reference

select * from locations;
select * from employees;
select * from countries;
select * from regions;
select * from jobs;
select * from job_history;
select * from departments;

--                                                      EXERCISE - 2

-- 1.	Write a SQL query to remove the details of an employee whose first name ends in ‘even’

delete from employees where lower(first_name) like '%even';

-- 2.	Write a query in SQL to show the three minimum values of the salary from the table.

select * from employees order by salary limit 3;

-- 3.	Write a SQL query to copy the details of this table into a new table with table name as Employee table and to delete the records in employees table

create table MyEmployees(
    employee_id INT  NOT NULL,
	first_name VARCHAR(20),
	last_name VARCHAR(25) NOT NULL,
	email VARCHAR(25) NOT NULL,
	phone_number VARCHAR(20),
	hire_date DATE NOT NULL,
	job_id VARCHAR(10) NOT NULL,
	salary DECIMAL(8, 2) NOT NULL,
	commission_pct DECIMAL(2, 2),
	manager_id INT ,
	department_id INT  ,
	PRIMARY KEY (employee_id));
    
select * into MyEmployees from employees; 
delete * from employees;

create table MyEmployees like employees;
create table table_name as select * from ----
insert into MyEmployees select * from employees;

-- 4.	Write a SQL query to remove the column Age from the table

alter table employees drop column age;

-- 5.	Obtain the list of employees (their full name, email, hire_year) where they have joined the firm before 2000

select concat(first_name, ' ',last_name) as full_name, email, year(hire_date) as hire_year from employees where year(hire_date)<2000;

-- 6.	Fetch the employee_id and job_id of those employees whose start year lies in the range of 1990 and 1999

select employee_id, job_id from employees where year(hire_date) between 1990 and 1999;

-- 7.	Find the first occurrence of the letter 'A' in each employees Email ID. Return the employee_id, email id and the letter position

select employee_id, email, charindex('A', email) as letter_position from employees where letter_position > 0;

-- 8.	Fetch the list of employees(Employee_id, full name, email) whose full name holds characters less than 12

select employee_id, concat(first_name,' ',last_name) as full_name, email from employees where length(concat(first_name,last_name)) < 12;

-- 9.	Create a unique string by hyphenating the first name, last name , and email of the employees to obtain a new field named UNQ_ID  Return the employee_id, and their corresponding UNQ_ID;

select employee_id, concat_ws('-',first_name, last_name, email) as unq_id from employees;

-- 10.	Write a SQL query to update the size of email column to 30

alter table employees modify email varchar(30);

-- 11.	Write a SQL query to change the location of Diana to London

update locations set city = 'London' where location_id in 
(select location_id from departments where department_id in
(select department_id from employees where first_name='Diana'));

-- 12.	Fetch all employees with their first name , email , phone (without extension part) and extension (just the extension). Info : this mean you need to separate phone into 2 parts. eg: 123.123.1234.12345 => 123.123.1234 and 12345 . first half in phone column and second half in extension column

select first_name, array_to_string(array_slice(split(phone_number,'.'), 0, -1), '.') as first_part, array_to_string(array_slice(split(phone_number,'.'), -1, array_size(split(phone_number,'.'))), '.') as last_part from employees;

-- 13.	Write a SQL query to find the employee with second and third maximum salary with and without using top/limit keyword

select emp1.first_name,emp1.salary from employees emp1
where 1 =(select count(distinct emp2.salary) from employees emp2 where emp2.salary>emp1.salary)
union 
select emp1.first_name,emp1.salary from employees emp1
where 2 =(select count(distinct emp2.salary) from employees emp2 where emp2.salary>emp1.salary);


select top 2 salary from (select distinct top 3 salary from employees order by salary desc) order by salary;

select distinct salary from employees order by salary desc limit 2 offset 1;

select * from(select first_name, salary, dense_rank() over(order by salary desc)r from employees);

-- 14.  Fetch all details of top 3 highly paid employees who are in department Shipping and IT

select first_name, department_id, salary from employees
where department_id in (select department_id from departments where department_name in('Shipping', 'IT')) 
order by salary desc limit 3;

SELECT e.first_name, e.department_id, e.salary, d.department_name
FROM employees e, departments d WHERE e.department_id = d.department_id and d.department_name in('Shipping', 'IT') and e.salary IN
    (SELECT max(salary)
     FROM employees
     GROUP BY department_id);

-- 15.  Display employee id and the positions(jobs) held by that employee (including the current position)

select employee_id,job_id from job_history
union
select employee_id,job_id from employees 
order by employee_id;

-- 16.	Display Employee first name and date joined as WeekDay, Month Day, Year Eg : 
--      Emp ID      Date Joined
--         1	Monday, June 21st, 1999


select first_name, concat(dayname(hire_date),',' ,monthname(hire_date),' ', day(hire_date), ',' ,year(hire_date)) as date_joined from employees;

-- 17.	The company holds a new job opening for Data Engineer (DT_ENGG) with a minimum salary of 12,000 and maximum salary of 30,000 .  
--      The job position might be removed based on market trends (so, save the changes) . 
--     -   Later, update the maximum salary to 40,000 . 
--     -   Save the entries as well.
--     -   Now, revert back the changes to the initial state, where the salary was 30,000


select round(avg(salary), 4) as average_salary from employees where hire_date > '1996-01-08' and hire_date < '2000-01-01';

-- 18.	Find the average salary of all the employees who got hired after 8th January 1996 but before 1st January 2000 and round the result to 3 decimals

insert into jobs values('DT_ENGG', 'Data Engineer', 12000, 30000);
start transaction;
commit;
update jobs set max_salary = 50000 where job_id = 'DT_ENGG';
select * from jobs;
rollback;
select * from jobs;
delete from jobs where job_id='DT_ENGG';

-- 19.	 Display  Australia, Asia, Antarctica, Europe along with the regions in the region table (Note: Do not insert data into the table)
--       A. Display all the regions
--       B. Display all the unique regions

select region_name from regions
union all
select 'Australia'
union all
select 'Antarctica'
union all
select 'Asia'
union all
select 'Europe';

select region_name from regions
union 
select 'Australia'
union 
select 'Antarctica'
union 
select 'Asia'
union 
select 'Europe';

-- 20.	Write a SQL query to remove the employees table from the database

drop table employees;

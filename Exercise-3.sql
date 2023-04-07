
-- Displaying tables contents for reference

select * from locations;
select * from employees;
select * from countries;
select * from regions;
select * from jobs;
select * from job_history;
select * from departments;

--                                                      EXERCISE - 3

--1.  Write a SQL query to find the total salary of employees who is in Tokyo excluding whose first name is Nancy

SELECT SUM(employees.salary) as total_salary
FROM employees
    JOIN departments ON employees.department_id = departments.department_id
    JOIN locations ON departments.location_id = locations.location_id
WHERE locations.city = 'Tokyo' AND employees.first_name <> 'Nancy';

--2.  Fetch all details of employees who has salary more than the avg salary by each department.

SELECT e.*, d.department_name
FROM employees e
    JOIN departments d ON e.department_id = d.department_id
WHERE e.salary > (SELECT AVG(salary) FROM employees WHERE department_id = e.department_id)
ORDER BY d.department_name;


--3.	Write a SQL query to find the number of employees and its location whose salary is greater than or equal to 7000 and less than 10000

SELECT COUNT(*) as num_employees, l.city
FROM employees e
    JOIN departments d ON e.department_id = e.department_id
    JOIN locations l ON d.location_id = l.location_id
WHERE e.salary >= 7000 AND e.salary < 10000
GROUP BY l.city;

--4.	Fetch max salary, min salary and avg salary by job and department. 
-- Info:  grouped by department id and job id ordered by department id and max salary

SELECT d.department_id, j.job_id, MAX(e.salary) as max_salary, MIN(e.salary) as min_salary, AVG(e.salary) as avg_salary
FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    JOIN jobs j ON e.job_id = j.job_id
GROUP BY d.department_id, j.job_id
ORDER BY d.department_id, max_salary DESC;

--5.	Write a SQL query to find the total salary of employees whose country_id is ‘US’ excluding whose first name is Nancy 

SELECT SUM(salary) as total_salary
FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    JOIN locations l ON d.location_id = l.location_id
    JOIN countries c ON l.country_id = c.country_id
WHERE c.country_id = 'US' AND e.first_name <> 'Nancy'; 

--6.	Fetch max salary, min salary and avg salary by job id and department id but only for folks who worked in more than one role(job) in a department.

SELECT job_id, department_id, MAX(salary) AS max_salary, MIN(salary) AS min_salary, AVG(salary) AS avg_salary
FROM employees
WHERE department_id IN (
    SELECT department_id
    FROM employees
    GROUP BY department_id
    HAVING COUNT(DISTINCT job_id) > 1
)
GROUP BY job_id, department_id;


--7.	Display the employee count in each department and also in the same result.  
--Info: * the total employee count categorized as "Total" •	the null department count categorized as "-" *

SELECT COALESCE(d.department_name, '-') AS department_name, COUNT(e.employee_id) AS employee_count
FROM employees e
    LEFT JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;


--8.	Display the jobs held and the employee count. 
--Hint: every employee is part of at least 1 job 
--Hint: use the previous questions answer
--Sample
--JobsHeld EmpCount
--1	        100
--2	         4

SELECT job_id AS JobsHeld, COUNT(*) AS EmpCount 
FROM employees 
GROUP BY job_id; 

--9.	 Display average salary by department and country.

SELECT d.department_name, c.country_name, AVG(e.salary) AS avg_salary
FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    JOIN locations l ON d.location_id = l.location_id
    JOIN countries c ON l.country_id = c.country_id
GROUP BY d.department_name, c.country_name;

--10.	Display manager names and the number of employees reporting to them by countries (each employee works for only one department, and each department belongs to a country)

SELECT 
  CONCAT(m.first_name, ' ', m.last_name) AS manager_name,
  c.country_name,
  COUNT(e.employee_id) AS employee_count
FROM 
  employees e
  JOIN departments d ON e.department_id = d.department_id
  JOIN locations l ON d.location_id = l.location_id
  JOIN countries c ON l.country_id = c.country_id
  JOIN employees m ON m.employee_id = d.manager_id
GROUP BY 
  manager_name, c.country_name;

--11.	 Group salaries of employees in 4 buckets eg: 0-10000, 10000-20000,.. (Like the previous question) but now group by department and categorize it like below.
--Eg : 
--DEPT ID 0-10000 10000-20000
--50          2               10
--60          6                5

SELECT d.department_id,
  COUNT(CASE WHEN e.salary >= 0 AND e.salary <= 10000 THEN 1 END) AS _0to10000,
  COUNT(CASE WHEN e.salary > 10000 AND e.salary <= 20000 THEN 1 END) AS _10000to20000,
  COUNT(CASE WHEN e.salary > 20000 AND e.salary <= 30000 THEN 1 END) AS _20000to30000,
  COUNT(CASE WHEN e.salary > 30000 THEN 1 END) AS above_30000
FROM 
  employees e
  JOIN departments d ON e.department_id = d.department_id
GROUP BY 
  d.department_id;

--12.	 Display employee count by country and the avg salary 
--Eg : 
--Emp Count       Country        Avg Salary
--10               Germany         34242.8

SELECT 
  COUNT(e.employee_id) AS Emp_Count,
  c.country_name AS Country,
  AVG(e.salary) AS Avg_Salary
FROM 
  employees e
  JOIN departments d ON e.department_id = d.department_id
  JOIN locations l ON d.location_id = l.location_id
  JOIN countries c ON l.country_id = c.country_id
GROUP BY 
  c.country_name;

--13.	 Display region and the number of employees by department
--Eg : 
--Dept ID   America   Europe  Asia
--10            22               -            -
--40             -                 34         -
--(Please put "-" instead of leaving it NULL or Empty)

SELECT 
  d.department_id AS Dept_ID,
  IFNULL(COUNT(CASE WHEN r.region_name = 'Americas' THEN 1 END), 0) AS America,
  IFNULL(COUNT(CASE WHEN r.region_name = 'Europe' THEN 1 END), 0) AS Europe,
  IFNULL(COUNT(CASE WHEN r.region_name = 'Asia' THEN 1 END), 0) AS Asia
FROM 
  employees e
  JOIN departments d ON e.department_id = d.department_id
  JOIN locations l ON d.location_id = l.location_id
  JOIN countries c ON l.country_id = c.country_id
  JOIN regions r ON c.region_id = r.region_id
GROUP BY 
  d.department_id;

--14.  Select the list of all employees who work either for one or more departments or have not yet joined / allocated to any department

SELECT e.*
FROM 
  employees e
LEFT JOIN departments d ON e.department_id = d.department_id;

--15.	write a SQL query to find the employees and their respective managers. Return the first name, last name of the employees and their managers

SELECT 
  e.first_name AS employee_first_name, 
  e.last_name AS employee_last_name, 
  m.first_name AS manager_first_name, 
  m.last_name AS manager_last_name
FROM 
  employees e 
  JOIN employees m ON e.manager_id = m.employee_id;
  
--16.	write a SQL query to display the department name, city, and state province for each department.

SELECT 
  d.department_name, 
  l.city, 
  l.state_province
FROM 
  departments d 
  INNER JOIN locations l ON d.location_id = l.location_id;

--17.	write a SQL query to list the employees (first_name , last_name, department_name) who belong to a department or don't

SELECT e.first_name, e.last_name, IFNULL(d.department_name, 'No Department') as department_name
FROM employees e
    LEFT JOIN departments d ON e.department_id = d.department_id
ORDER BY department_name, e.last_name;

--18.	The HR decides to make an analysis of the employees working in every department. Help him to determine the salary given in average per department and the total number of employees working in a department.  List the above along with the department id, department name

SELECT d.department_id, d.department_name, AVG(e.salary) AS avg_salary, COUNT(e.employee_id) AS total_employees
FROM departments d
    LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
ORDER BY d.department_id;

--19.	Write a SQL query to combine each row of the employees with each row of the jobs to obtain a consolidated results. (i.e.) Obtain every possible combination of rows from the employees and the jobs relation.

SELECT * FROM employees CROSS JOIN jobs;

--20.	 Write a query to display first_name, last_name, and email of employees who are from Europe and Asia

SELECT e.first_name, e.last_name, e.email
FROM employees e
  JOIN departments d ON e.department_id = d.department_id
  JOIN locations l ON d.location_id = l.location_id
  JOIN countries c ON l.country_id = c.country_id
  JOIN regions r ON c.region_id = r.region_id
WHERE r.region_name IN ('Europe', 'Asia');

--21.	 Write a query to display full name with alias as FULL_NAME (Eg: first_name = 'John' and last_name='Henry' - full_name = "John Henry") who are from oxford city and their second last character of their last name is 'e' and are not from finance and shipping department.

SELECT CONCAT(first_name, ' ', last_name) AS full_name, email
FROM employees
WHERE SUBSTRING(last_name, -2, 1) = 'e' 
AND department_id NOT IN (SELECT department_id FROM departments WHERE department_name IN ('Finance', 'Shipping'));
  
--22.	 Display the first name and phone number of employees who have less than 50 months of experience

SELECT first_name, phone_number
FROM employees
WHERE DATEDIFF(MONTH, GETDATE(), hire_date) < 50;

--23.	 Display Employee id, first_name, last name, hire_date and salary for employees who has the highest salary for each hiring year. (For eg: John and Deepika joined on year 2023,  and john has a salary of 5000, and Deepika has a salary of 6500. Output should show Deepika’s details only).

SELECT e1.employee_id, e1.first_name, e1.last_name, e1.hire_date, e1.salary
FROM employees e1
WHERE e1.salary = (
  SELECT MAX(salary)
  FROM employees e2
  WHERE YEAR(e1.hire_date) = YEAR(e2.hire_date)) 
ORDER BY e1.hire_date;



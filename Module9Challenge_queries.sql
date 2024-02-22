-- Module 9 Challenge SQL Queries
-- ------------------------------------------------------------------------------------------------------------------------

-- Import Data: From csv files into tuples

CREATE TABLE departments (
	dept_num varchar(5) UNIQUE NOT NULL,
	dept_name varchar(50) NOT NULL,
	PRIMARY KEY (dept_num)
);
COPY departments (dept_num, dept_name)
FROM 'C:\Users\Mitchell\Desktop\Data Analysis Bootcamp\Module 9 Challenge - SQL\Starter_Code\data\departments.csv'
DELIMITER ','
CSV HEADER;
-- select * from departments;

CREATE TABLE titles (
	title_id varchar(10) UNIQUE NOT NULL,
	title varchar(30) NOT NULL,
	PRIMARY KEY (title_id)
);
COPY titles (title_id, title)
FROM 'C:\Users\Mitchell\Desktop\Data Analysis Bootcamp\Module 9 Challenge - SQL\Starter_Code\data\titles.csv'
DELIMITER ','
CSV HEADER;
-- select * from titles;

CREATE TABLE employees (
	employee_num varchar(10) UNIQUE NOT NULL,
	employee_title_id varchar(10) NOT NULL references titles(title_id),
	birth_date date NOT NULL,
	first_name varchar(30) NOT NULL,
	last_name varchar(30) NOT NULL,
	sex char NOT NULL,
	hire_date date NOT NULL,
	PRIMARY KEY (employee_num)
);
COPY employees (employee_num, employee_title_id, birth_date, first_name, last_name, sex, hire_date)
FROM 'C:\Users\Mitchell\Desktop\Data Analysis Bootcamp\Module 9 Challenge - SQL\Starter_Code\data\employees.csv'
DELIMITER ','
CSV HEADER;
-- select * from employees;

CREATE TABLE dept_employees (
	id serial UNIQUE NOT NULL,
	employee_num varchar(10) NOT NULL references employees(employee_num),
	dept_num varchar(5) NOT NULL references departments(dept_num),
	PRIMARY KEY (id)
);
COPY dept_employees (employee_num, dept_num)
FROM 'C:\Users\Mitchell\Desktop\Data Analysis Bootcamp\Module 9 Challenge - SQL\Starter_Code\data\dept_emp.csv'
DELIMITER ','
CSV HEADER;
-- select * from dept_employees;

CREATE TABLE dept_managers (
	id serial UNIQUE NOT NULL,
	dept_num varchar(5) NOT NULL references departments(dept_num),
	employee_num varchar(10) NOT NULL references employees(employee_num),
	PRIMARY KEY (id)
);
COPY dept_managers (dept_num, employee_num)
FROM 'C:\Users\Mitchell\Desktop\Data Analysis Bootcamp\Module 9 Challenge - SQL\Starter_Code\data\dept_manager.csv'
DELIMITER ','
CSV HEADER;
-- select * from dept_managers;

CREATE TABLE salaries (
	employee_num varchar(10) UNIQUE NOT NULL references employees(employee_num),
	salary bigint NOT NULL,
	PRIMARY KEY (employee_num)
);
COPY salaries (employee_num, salary)
FROM 'C:\Users\Mitchell\Desktop\Data Analysis Bootcamp\Module 9 Challenge - SQL\Starter_Code\data\salaries.csv'
DELIMITER ','
CSV HEADER;
-- select * from salaries;

-- DROP TABLE salaries;
-- DROP TABLE dept_managers;
-- DROP TABLE dept_employees;
-- DROP TABLE employees;
-- DROP TABLE titles;
-- DROP TABLE departments;

-- ------------------------------------------------------------------------------------------------------------------------

-- Data Analysis

-- 1. List the employee number, last name, first name, sex, and salary of each employee.
SELECT e.employee_num, e.last_name, e.first_name, e.sex, s.salary
FROM employees e
JOIN salaries s
ON e.employee_num = s.employee_num;

-- 2. List the first name, last name, and hire date for the employees who were hired in 1986.
SELECT first_name, last_name, hire_date 
FROM employees
WHERE hire_date BETWEEN '1/1/1986' AND '12/31/1986'
ORDER BY hire_date;

-- 3. List the manager of each department along with their department number, department name, employee number, last name, and first name.
SELECT d.dept_num, d.dept_name, d_m.employee_num, e.last_name, e.first_name
FROM departments d
JOIN dept_managers d_m
ON d.dept_num = d_m.dept_num
JOIN employees e
ON d_m.employee_num = e.employee_num;

-- 4. List the department number for each employee along with that employee’s employee number, last name, first name, and department name.
SELECT d.dept_num, d_e.employee_num, e.last_name, e.first_name, d.dept_name
FROM dept_employees d_e
JOIN employees e
ON d_e.employee_num = e.employee_num
JOIN departments d
ON d_e.dept_num = d.dept_num;

-- 5. List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
SELECT e.first_name, e.last_name, e.sex
FROM employees e
WHERE first_name = 'Hercules'
AND last_name LIKE 'B%'

-- 6. List each employee in the Sales department, including their employee number, last name, and first name.
SELECT d.dept_name, e.employee_num, e.last_name, e.first_name
FROM dept_employees d_e
JOIN employees e
ON d_e.employee_num = e.employee_num
JOIN departments d
ON d_e.dept_num = d.dept_num
WHERE d.dept_name = 'Sales';

-- 7. List each employee in the Sales and Development departments, including their employee number, last name, 
--    first name, and department name.
SELECT d_e.employee_num, e.last_name, e.first_name, d.dept_name
FROM dept_employees d_e
JOIN employees e
ON d_e.employee_num = e.employee_num
JOIN departments d
ON d_e.dept_num = d.dept_num
WHERE d.dept_name = 'Sales' 
OR d.dept_name = 'Development';

-- 8. List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).
SELECT last_name,
COUNT(last_name) AS "frequency_counts"
FROM employees
GROUP BY last_name
ORDER BY
COUNT(last_name) DESC;

-- ------------------------------------------------------------------------------------------------------------------------

-- end

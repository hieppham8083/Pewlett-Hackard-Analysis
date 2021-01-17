----- DELIVERABLE 1 -----
CREATE TABLE departments(
	dept_no VARCHAR(4) NOT NULL,
	dept_name VARCHAR(40) NOT NULL,
	PRIMARY KEY (dept_no),
	UNIQUE (dept_name)
);
CREATE TABLE employees(
	emp_no INT NOT NULL,
	birth_date DATE NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	gender VARCHAR NOT NULL,
	hire_date DATE NOT NULL,
	PRIMARY KEY (emp_no)
);
CREATE TABLE dept_manager(
    dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);
CREATE TABLE salaries(
	emp_no INT NOT NULL,
	salary INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no)
);
CREATE TABLE dept_emp(
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);
CREATE TABLE titles(
	emp_no INT NOT NULL,
	title VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);
SELECT * FROM departments;
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

-- Verify successful data import
SELECT * FROM titles;
SELECT * FROM employees;
SELECT * FROM dept_emp;

SELECT employees.emp_no,
	employees.first_name,
	employees.last_name,
	titles.title,
	titles.from_date,
	titles.to_date	
INTO retirement_titles
FROM employees
INNER JOIN titles ON 
employees.emp_no = titles.emp_no
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY employees.emp_no;
SELECT * FROM retirement_titles;

SELECT DISTINCT ON (rt.emp_no) rt.emp_no,
	rt.first_name,
	rt.last_name,
	rt.title
INTO unique_titles
FROM retirement_titles as rt
ORDER BY rt.emp_no, rt.to_date DESC;
SELECT * FROM unique_titles;

SELECT COUNT(ut.emp_no), ut.title
INTO retiring_titles
FROM unique_titles as ut
GROUP BY ut.title
ORDER BY COUNT (ut.emp_no) DESC;
SELECT * FROM retiring_titles;

----- DELIVERABLE 2 -----
SELECT DISTINCT ON (employees.emp_no) employees.emp_no,
    employees.first_name,
    employees.last_name,
    employees.birth_date,
    dept_emp.from_date,
    dept_emp.to_date,
    titles.title
INTO mentorship_eligibility
FROM employees 
INNER JOIN dept_emp ON 
employees.emp_no = dept_emp.emp_no
INNER JOIN titles ON 
employees.emp_no = titles.emp_no
WHERE (employees.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND (dept_emp.to_date = '9999-01-01')
ORDER BY employees.emp_no;
SELECT * FROM mentorship_eligibility;


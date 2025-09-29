--PART A
CREATE TABLE employees (
	emp_id SERIAL PRIMARY KEY,
	first_name VARCHAR,
	last_name VARCHAR,
	department VARCHAR,
	salary INT,
	hire_date DATE,
	status VARCHAR Default 'Active'
);

CREATE TABLE departments(
	dept_id SERIAL PRIMARY KEY,
	dept_name VARCHAR,
	budget INT,
	manager_id INT
);

CREATE TABLE projects(
	project_name VARCHAR,
	dept_id INT,
	start_date DATE,
	end_date DATE,
	budget INT
);

--PART B
INSERT INTO employees (first_name, last_name, department) VALUES ('Dexter', 'Morgan', 'Miami Metro Police Department');
INSERT INTO employees (first_name, last_name, department, salary, status) VALUES ('Masuka', 'Vince', 'Miami Metro Police Department', DEFAULT, DEFAULT);
INSERT INTO departments (dept_name, budget, manager_id)
VALUES 
    ('IT', 100, 78),
    ('HR', 200, 44),
    ('Finance', 50, 56);
INSERT INTO employees (first_name, last_name, department, salary, hire_date) VALUES ('a', 'b', 'c', 50000 * 1.1, CURRENT_DATE);
CREATE TEMPORARY TABLE SELECT * FROM employees WHERE department = 'IT';
--PART C
UPDATE employees SET salary = salary*1.10;
UPDATE employess SET status = 'Senior' WHERE salary > 60000 AND hire_date < '2020-01-01';
UPDATE employees SET department = CASE 
	WHEN salary > 80000 THEN 'Management',
	WHEN salary > 50000 AND salary <80000 THEN 'Senior',
	ELSE 'Junior';
UPDATE employees SET department = DEFAULT WHERE status = 'Inactive';
UPDATE department d 
SET budget = (
	SELECT AVG(employees.salary)*1.2
	WHERE employees.department = d.dept_name
);
UPDATE employees SET salary = salary*1.15 and status = 'Promoted' WHERE department = 'Sales';
--PART D
DELETE FROM employees WHERE status = 'Terminated';
DELETE FROM employees WHERE salary < 40000 AND hire_date > '2023-01-01' AND department IS NULL;
DELETE FROM departments WHERE dept_id NOT IN (SELECT DISTINCT department FROM employees	WHERE department IS	NOT	NULL);
DELETE FROM projects WHERE end_date < '2023-01-01' RETURNING *;
--PART E
INSERT INTO employess (first_name, last_name, department, salary) VALUES ('aa', 'bb', NULL, NULL);
UPDATE employees SET department = 'Unassigned' WHERE department = NULL;
DELETE FROM employees WHERE salary IS NULL OR department IS NULL;
--PART F
INSERT INTO employees (first_name, last_name, department, salary, hire_date) VALUES 'Ваня', 'Иванов', 'IT', 60000, CURRENT_DATE) RETURNING emp_id, first_name || ' ' || second_name AS full_name;
UPDATE employees SET salary = salary + 5000 WHERE department = 'IT' RETURNING emp_id, salary - 5000 AS old_salary, salary AS new_salary;
DELETE FROM employees WHERE hire_date < '2020-01-01' RETURNING *;
--PART G
INSERT INTO employees (first_name, last_name, department, salary, hire_date)
SELECT 'Ivan', 'Petrov', 'IT', 60000, '2025-09-29'
WHERE NOT EXISTS (
    SELECT 1
    FROM employees
    WHERE first_name = 'Ivan' AND last_name = 'Petrov'
);
UPDATE employees e
SET salary = salary * (
	CASE
		WHEN d.budget > 100000 THEN 1.10
		ELSE 1.05
)
FROM departments d
WHERE e.department = d.dept_name;
INSERT INTO employees (first_name, last_name, department, salary, hire_date)
VALUES 
    ('aaa', 'aaa', 'IT', 100, '2025-09-09'),
    ('sss', 'sss', 'HR', 200, '2025-09-09'),
    ('ddd', 'ddd', 'Finance', 50, '2025-09-09'),
	('fff', 'fff', 'Miami Metro', 7777, '2025-09-09'),
	('ggg', 'ggg', 'Hot Pot', 1000000000, '2025-09-09');
UPDATE employees SET salary = salary * 1.10 WHERE hire_date = '2025-09-09';
CREATE TABLE employee_archive AS SELECT * FROM employees WHERE 1 = 0;
INSERT INTO employee_archive SELECT * WHERE status = 'Inactive';
DELETE FROM employees WHERE status = 'Inactive';
UPDATE projects p SET end_date = end_date + INTERVAL '30 days'
	WHERE p.budget> 50000
	AND p.dept_id IN(
		SELECT d.dept_id
		FROM departments d
		JOIN employees e ON e.department = d.dept_name
		GROUP BY d.dept_id
		HAVING COUNT (*) >3
	);
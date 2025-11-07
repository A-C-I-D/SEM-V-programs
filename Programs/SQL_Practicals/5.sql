CREATE DATABASE Company5DB;
USE Company5DB;
DROP TABLE IF EXISTS Manages;
DROP TABLE IF EXISTS Works;
DROP TABLE IF EXISTS Company;
DROP TABLE IF EXISTS Employee;

CREATE TABLE Employee (
    emp_id VARCHAR(10) PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    street VARCHAR(200) NOT NULL,
    city VARCHAR(50) NOT NULL
);

CREATE TABLE Company (
    company_name VARCHAR(100) PRIMARY KEY,
    city VARCHAR(50) NOT NULL
);

CREATE TABLE Works (
    emp_id VARCHAR(10),
    company_name VARCHAR(100),
    salary DECIMAL(12,2) NOT NULL,
    PRIMARY KEY (emp_id, company_name),
    FOREIGN KEY (emp_id) REFERENCES Employee(emp_id),
    FOREIGN KEY (company_name) REFERENCES Company(company_name)
);

CREATE TABLE Manages (
    emp_id VARCHAR(10),
    manager_id VARCHAR(10),
    PRIMARY KEY (emp_id, manager_id),
    FOREIGN KEY (emp_id) REFERENCES Employee(emp_id),
    FOREIGN KEY (manager_id) REFERENCES Employee(emp_id)
);

INSERT INTO Employee VALUES
('E001', 'Rahul Mehta', 'FC Road', 'Pune'),
('E002', 'Priya Singh', 'MG Road', 'Pune'),
('E003', 'Amit Patel', 'Koregaon Park', 'Pune'),
('E004', 'Sneha Verma', 'Kalyani Nagar', 'Pune'),
('E005', 'Vikram Shah', 'Aundh', 'Pune');

INSERT INTO Company VALUES
('InfoSys', 'Pune'),
('TechM', 'Pune'),
('Wipro', 'Pune'),
('TCS', 'Pune');

INSERT INTO Works VALUES
('E001', 'InfoSys', 12000.00),
('E002', 'TechM', 15000.00),
('E003', 'InfoSys', 9000.00),
('E004', 'TechM', 11000.00),
('E005', 'Wipro', 13000.00),
('E001', 'TCS', 14000.00),
('E004', 'TCS', 13000.00);

INSERT INTO Manages VALUES
('E002', 'E001'),
('E003', 'E001'),
('E004', 'E005');

-- Question 1
SELECT e.employee_name
FROM Employee e
JOIN Works w ON e.emp_id = w.emp_id
WHERE w.company_name = 'TCS';

-- Question 2
SELECT e.employee_name, w.company_name
FROM Employee e
JOIN Works w ON e.emp_id = w.emp_id
ORDER BY w.company_name ASC, e.employee_name DESC;

-- Question 3
UPDATE Employee e
JOIN Works w ON e.emp_id = w.emp_id
SET e.city = 'Bengaluru'
WHERE w.company_name = 'InfoSys';

-- Question 4
SELECT e.employee_name, e.street, e.city
FROM Employee e
JOIN Works w ON e.emp_id = w.emp_id
WHERE w.company_name = 'TechM' AND w.salary > 10000;

-- Question 5
ALTER TABLE Company
ADD COLUMN Asset DECIMAL(15,2);
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
    employee_name VARCHAR(100) PRIMARY KEY,
    company_name VARCHAR(100) NOT NULL,
    salary DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (employee_name) REFERENCES Employee(employee_name),
    FOREIGN KEY (company_name) REFERENCES Company(company_name)
);

CREATE TABLE Manages (
    employee_name VARCHAR(100),
    manager_name VARCHAR(100),
    PRIMARY KEY (employee_name, manager_name),
    FOREIGN KEY (employee_name) REFERENCES Employee(employee_name),
    FOREIGN KEY (manager_name) REFERENCES Employee(employee_name)
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
('Rahul Mehta', 'InfoSys', 12000.00),
('Priya Singh', 'TechM', 15000.00),
('Amit Patel', 'InfoSys', 9000.00),
('Sneha Verma', 'TechM', 11000.00),
('Vikram Shah', 'Wipro', 13000.00),
('Rahul Mehta', 'TCS', 14000.00),
('Sneha Verma', 'TCS', 13000.00);

INSERT INTO Manages VALUES
('Priya Singh', 'Rahul Mehta'),
('Amit Patel', 'Rahul Mehta'),
('Sneha Verma', 'Vikram Shah');

-- Question 1
UPDATE Employee e
JOIN Works w ON e.employee_name = w.employee_name
SET e.city = 'Bengaluru'
WHERE w.company_name = 'InfoSys';

-- Question 2
SELECT e.employee_name
FROM Employee e
JOIN Works w ON e.employee_name = w.employee_name
WHERE w.salary > (
    SELECT AVG(salary)
    FROM Works w2
    WHERE w2.company_name = w.company_name
);

-- Question 3
SELECT e.employee_name, e.street, e.city
FROM Employee e
JOIN Works w ON e.employee_name = w.employee_name
WHERE w.company_name = 'TechM' AND w.salary > 10000;

-- Question 4
RENAME TABLE Manages TO Management; 

-- Question 5
CREATE INDEX idx_employee_name ON Employee(employee_name);
CREATE UNIQUE INDEX idx_employee_id ON Employee(emp_id);

-- Question 6
SHOW INDEX FROM Employee;
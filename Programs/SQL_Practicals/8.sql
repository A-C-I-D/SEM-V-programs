DROP VIEW View1;
DROP VIEW View2;
DROP TABLE Orders;
DROP TABLE Companies;

CREATE TABLE Companies (
    comp_id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    cost DECIMAL(12,2) NOT NULL,
    year INT NOT NULL
);

CREATE TABLE Orders (
    comp_id VARCHAR(10),
    domain VARCHAR(50) NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (comp_id) REFERENCES Companies(comp_id)
);

INSERT INTO Companies VALUES
('C001', 'TechSolutions India', 50000.00, 2025),
('C002', 'DataSoft Systems', 75000.00, 2024),
('C003', 'InnovatePune', 60000.00, 2025),
('C004', 'WebTech Services', 45000.00, 2023);

INSERT INTO Orders VALUES
('C001', 'Software Development', 100),
('C002', 'Data Analytics', 50),
('C003', 'Cloud Services', 75),
('C004', 'Web Development', 120);

-- Question 1
SELECT c.name, c.cost, o.domain, o.quantity
FROM Companies c
INNER JOIN Orders o ON c.comp_id = o.comp_id;

-- Question 2
SELECT c.name, c.cost, o.domain, o.quantity
FROM Companies c
LEFT OUTER JOIN Orders o ON c.comp_id = o.comp_id;

-- Question 3
SELECT c.name, c.cost, o.domain, o.quantity
FROM Companies c
RIGHT OUTER JOIN Orders o ON c.comp_id = o.comp_id;

-- Question 4
SELECT c.name, c.cost, o.domain, o.quantity
FROM Companies c
LEFT OUTER JOIN Orders o ON c.comp_id = o.comp_id
UNION
SELECT c.name, c.cost, o.domain, o.quantity
FROM Companies c
RIGHT OUTER JOIN Orders o ON c.comp_id = o.comp_id;

-- Question 5
CREATE VIEW View1 AS
SELECT c.name AS company_name, o.quantity
FROM Companies c
JOIN Orders o ON c.comp_id = o.comp_id;

-- Question 6
CREATE VIEW View2 AS
SELECT name, cost
FROM Companies;

-- DML operations
INSERT INTO View2 VALUES ('NewTech Solutions', 55000.00);
UPDATE View2 SET cost = 80000.00 WHERE name = 'NewTech Solutions';
DELETE FROM View2 WHERE name = 'NewTech Solutions';

-- Question 7
SELECT * FROM View1;
SELECT * FROM View2;
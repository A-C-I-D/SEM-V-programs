CREATE TABLE Cust_Master (
    Cust_no VARCHAR(10) PRIMARY KEY,
    Cust_name VARCHAR(100) NOT NULL,
    Cust_addr VARCHAR(200) NOT NULL
);

CREATE TABLE Order_Details (
    Order_no VARCHAR(10) PRIMARY KEY,
    Cust_no VARCHAR(10) NOT NULL,
    Order_date DATE NOT NULL,
    Qty_Ordered INT NOT NULL,
    FOREIGN KEY (Cust_no) REFERENCES Cust_Master(Cust_no)
);

CREATE TABLE Product (
    Product_no VARCHAR(10) PRIMARY KEY,
    Product_name VARCHAR(100) NOT NULL,
    Order_no VARCHAR(10) NOT NULL,
    FOREIGN KEY (Order_no) REFERENCES Order_Details(Order_no)
);

INSERT INTO Cust_Master VALUES
('C1001', 'Amar Kumar', 'Pune'),
('C1002', 'Pradeep Shah', 'Bangalore'),
('C1003', 'Neha Singh', 'Andheri, Mumbai'),
('C1004', 'Vikram Joshi', 'Bangalore'),
('C1005', 'Sarita Patil', 'Mangalore'),
('C1006', 'Rohan Mehta', 'Mumbai'),
('C1007', 'Ravi Desai', 'Bangalore'),
('C1008', 'Anita Reddy', 'Mangalore');

INSERT INTO Order_Details VALUES
('O1001', 'C1001', '2025-01-15', 5),
('O1002', 'C1002', '2025-01-16', 3),
('O1003', 'C1005', '2025-01-16', 2),
('O1004', 'C1007', '2025-01-17', 1),
('O1005', 'C1008', '2025-01-17', 4);

INSERT INTO Product VALUES
('P1001', 'Laptop', 'O1001'),
('P1002', 'Mobile', 'O1002'),
('P1003', 'Tablet', 'O1003'),
('P1004', 'Printer', 'O1004'),
('P1005', 'Scanner', 'O1005');

-- Question 1
SELECT Cust_name
FROM Cust_Master
WHERE Cust_name LIKE '_a%';

-- Question 2
SELECT *
FROM Order_Details
WHERE Cust_no IN ('C1002', 'C1005', 'C1007', 'C1008');

-- Question 3
SELECT Cust_name
FROM Cust_Master
WHERE Cust_addr LIKE '%Bangalore%' OR Cust_addr LIKE '%Mangalore%';

-- Question 4
SELECT cm.Cust_name, p.Product_name
FROM Cust_Master cm
JOIN Order_Details od ON cm.Cust_no = od.Cust_no
JOIN Product p ON od.Order_no = p.Order_no;

-- Question 5
CREATE VIEW View1 AS
SELECT cm.Cust_name, p.Product_name
FROM Cust_Master cm
JOIN Order_Details od ON cm.Cust_no = od.Cust_no
JOIN Product p ON od.Order_no = p.Order_no;

-- Question 6
SELECT cm.Cust_name, p.Product_name, od.Qty_Ordered
FROM Cust_Master cm
JOIN Order_Details od ON cm.Cust_no = od.Cust_no
JOIN Product p ON od.Order_no = p.Order_no;

-- Question 7
-- Inner Join
SELECT * FROM Cust_Master cm
INNER JOIN Order_Details od ON cm.Cust_no = od.Cust_no;

-- Left Join
SELECT * FROM Cust_Master cm
LEFT JOIN Order_Details od ON cm.Cust_no = od.Cust_no;

-- Right Join
SELECT * FROM Cust_Master cm
RIGHT JOIN Order_Details od ON cm.Cust_no = od.Cust_no;

-- Full Outer Join
SELECT * FROM Cust_Master cm
LEFT JOIN Order_Details od ON cm.Cust_no = od.Cust_no
UNION
SELECT * FROM Cust_Master cm
RIGHT JOIN Order_Details od ON cm.Cust_no = od.Cust_no;
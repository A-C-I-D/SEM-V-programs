CREATE DATABASE StationaryDB;
USE StationaryDB; 
 
DROP TABLE PURCHASE;
DROP TABLE ITEMS;
DROP TABLE CUSTOMERS;
DROP VIEW Stationary_Items_View;


CREATE TABLE CUSTOMERS (
    CNo VARCHAR(10) PRIMARY KEY,
    Cname VARCHAR(100) NOT NULL,
    Ccity VARCHAR(50) NOT NULL,
    CMobile VARCHAR(15) NOT NULL
);

CREATE TABLE ITEMS (
    INo VARCHAR(10) PRIMARY KEY,
    Iname VARCHAR(100) NOT NULL,
    Itype VARCHAR(50) NOT NULL,
    Iprice DECIMAL(10,2) NOT NULL,
    Icount INT NOT NULL
);

CREATE TABLE PURCHASE (
    PNo VARCHAR(10) PRIMARY KEY,
    Pdate DATE NOT NULL,
    Pquantity INT NOT NULL,
    Cno VARCHAR(10) NOT NULL,
    INo VARCHAR(10) NOT NULL,
    FOREIGN KEY (Cno) REFERENCES CUSTOMERS(CNo),
    FOREIGN KEY (INo) REFERENCES ITEMS(INo)
);

INSERT INTO CUSTOMERS VALUES
  ('C101', 'Maya Deshmukh', 'Pune', '9876543210'),
  ('C102', 'Rahul Patil', 'Mumbai', '9876543211'),
  ('C103', 'Priya Shah', 'Pune', '9876543212'),
  ('C104', 'Amit Verma', 'Nagpur', '9876543213'),
  ('C105', 'Sneha Kumar', 'Pune', '9876543214'),
  ('C106', 'Gopal Kumar', 'Pune', '9876543215');

INSERT INTO ITEMS VALUES
  ('I101', 'Premium Notebook', 'Stationary', 450.00, 100),
  ('I102', 'Executive Pen Set', 'Stationary', 850.00, 50),
  ('I103', 'Art Supplies Kit', 'Stationary', 650.00, 75),
  ('I104', 'Office Chair', 'Furniture', 4500.00, 20),
  ('I105', 'Filing Cabinet', 'Furniture', 3500.00, 15);

INSERT INTO PURCHASE VALUES
  ('P101', DATE '2025-11-01', 5, 'C101', 'I101'),
  ('P102', DATE '2025-11-02', 2, 'C102', 'I102'),
  ('P103', DATE '2025-11-03', 3, 'C101', 'I103'),
  ('P104', DATE '2025-11-04', 1, 'C103', 'I104'),
  ('P105', DATE '2025-11-05', 4, 'C101', 'I102');

-- Question 1
SELECT Iname, Iprice
FROM ITEMS
WHERE Itype = 'Stationary' 
AND Iprice BETWEEN 400 AND 1000;

-- Question 2
UPDATE CUSTOMERS 
SET CMobile = '9998887776'
WHERE Cname LIKE 'Gopal%';

-- Question 3
SELECT Iname, Iprice
FROM ITEMS
WHERE Iprice = (SELECT MAX(Iprice) FROM ITEMS);

-- Question 4
SELECT p.PNo, p.Pdate, c.Cname, i.Iname, p.Pquantity
FROM PURCHASE p
JOIN CUSTOMERS c ON p.Cno = c.CNo
JOIN ITEMS i ON p.INo = i.INo
ORDER BY p.Pdate DESC;

-- Question 5
SELECT Ccity, COUNT(*) as customer_count
FROM CUSTOMERS
GROUP BY Ccity;

-- Question 6
SELECT c.Cname, i.Iname, p.Pquantity
FROM CUSTOMERS c
JOIN PURCHASE p ON c.CNo = p.Cno
JOIN ITEMS i ON p.INo = i.INo
WHERE c.Cname LIKE 'Maya%';

-- Question 7
CREATE OR REPLACE VIEW Stationary_Items_View AS
SELECT Iname, Iprice, Icount
FROM ITEMS
WHERE Itype = 'Stationary';

SELECT * FROM Stationary_Items_View
ORDER BY Iprice DESC;
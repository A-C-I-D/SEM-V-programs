CREATE TABLE Account (
    Acc_no VARCHAR(15) PRIMARY KEY,
    branch_name VARCHAR(50) NOT NULL,
    balance DECIMAL(12,2) NOT NULL
);

CREATE TABLE Branch (
    branch_name VARCHAR(50) PRIMARY KEY,
    branch_city VARCHAR(50) NOT NULL,
    assets DECIMAL(15,2) NOT NULL
);

CREATE TABLE Customer (
    cust_name VARCHAR(100) PRIMARY KEY,
    cust_street VARCHAR(100) NOT NULL,
    cust_city VARCHAR(50) NOT NULL
);

CREATE TABLE Depositor (
    cust_name VARCHAR(100),
    acc_no VARCHAR(15),
    PRIMARY KEY (cust_name, acc_no),
    FOREIGN KEY (cust_name) REFERENCES Customer(cust_name),
    FOREIGN KEY (acc_no) REFERENCES Account(acc_no)
);

CREATE TABLE Loan (
    loan_no VARCHAR(15) PRIMARY KEY,
    branch_name VARCHAR(50) NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (branch_name) REFERENCES Branch(branch_name)
);

CREATE TABLE Borrower (
    cust_name VARCHAR(100),
    loan_no VARCHAR(15),
    PRIMARY KEY (cust_name, loan_no),
    FOREIGN KEY (cust_name) REFERENCES Customer(cust_name),
    FOREIGN KEY (loan_no) REFERENCES Loan(loan_no)
);

INSERT INTO Branch VALUES
('Pune_Station', 'Pune', 20000000.00),
('Shivaji Nagar', 'Pune', 15000000.00),
('Kothrud', 'Pune', 10000000.00);

INSERT INTO Customer VALUES
('Amit Kumar', 'FC Road', 'Pune'),
('Priya Sharma', 'JM Road', 'Pune'),
('Rahul Verma', 'MG Road', 'Pune'),
('Sneha Patel', 'SB Road', 'Pune');

INSERT INTO Account VALUES
('ACC001', 'Pune_Station', 50000.00),
('ACC002', 'Shivaji Nagar', 75000.00),
('ACC003', 'Kothrud', 60000.00);

INSERT INTO Loan VALUES
('L001', 'Pune_Station', 100000.00),
('L002', 'Pune_Station', 150000.00),
('L003', 'Shivaji Nagar', 200000.00);

INSERT INTO Depositor VALUES
('Amit Kumar', 'ACC001'),
('Priya Sharma', 'ACC002'),
('Sneha Patel', 'ACC003');

INSERT INTO Borrower VALUES
('Rahul Verma', 'L001'),
('Priya Sharma', 'L002'),
('Sneha Patel', 'L003');

-- Question 1
CREATE VIEW View1 AS
SELECT c.cust_name
FROM Customer c
JOIN Borrower b ON c.cust_name = b.cust_name
JOIN Loan l ON b.loan_no = l.loan_no
WHERE l.branch_name = 'Pune_Station'
ORDER BY c.cust_name;

SELECT * FROM View1;

-- Question 2
CREATE VIEW View2 AS
SELECT branch_name, branch_city
FROM Branch;

SELECT * FROM View2;

-- DML operations 
INSERT INTO View2 VALUES ('Deccan', 'Pune');
UPDATE View2 SET branch_city = 'Mumbai' WHERE branch_name = 'Deccan';
DELETE FROM View2 WHERE branch_name = 'Deccan';

SELECT * FROM View2;

-- Question 3
CREATE VIEW View3 AS
SELECT b.cust_name AS borrower_name, d.acc_no
FROM Borrower b
JOIN Depositor d ON b.cust_name = d.cust_name;

SELECT * FROM View3;

-- DML operations
INSERT INTO View3 VALUES ('Amit Kumar', 'ACC001');
UPDATE View3 SET acc_no = 'ACC002' WHERE borrower_name = 'Amit Kumar';
DELETE FROM View3 WHERE borrower_name = 'Amit Kumar';

SELECT * FROM View3;

-- Question 4
SELECT c.cust_name
FROM Customer c
LEFT JOIN Depositor d ON c.cust_name = d.cust_name
UNION
SELECT c.cust_name
FROM Customer c
RIGHT JOIN Borrower b ON c.cust_name = b.cust_name;

-- Question 5
CREATE INDEX idx_customer_name ON Customer(cust_name);
CREATE UNIQUE INDEX idx_account_no ON Account(Acc_no);

-- Question 6
SHOW INDEX FROM Customer;
SHOW INDEX FROM Account;
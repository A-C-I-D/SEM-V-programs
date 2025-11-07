CREATE DATABASE Bank2DB;
USE Bank2DB;
DROP TABLE IF EXISTS Borrower;
DROP TABLE IF EXISTS Loan;
DROP TABLE IF EXISTS Depositor;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Branch;
DROP TABLE IF EXISTS Account;

CREATE TABLE Branch (
    branch_name VARCHAR(50) PRIMARY KEY,
    branch_city VARCHAR(50) NOT NULL,
    assets DECIMAL(15,2) NOT NULL
);

CREATE TABLE Account (
    acc_no VARCHAR(15) PRIMARY KEY,
    branch_name VARCHAR(50) NOT NULL,
    balance DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (branch_name) REFERENCES Branch(branch_name)
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
('Shivaji Nagar', 'Pune', 10000000.00),
('FC Road', 'Pune', 15000000.00),
('Kothrud', 'Pune', 8000000.00),
('Viman Nagar', 'Pune', 12000000.00);

INSERT INTO Customer VALUES
('Raj Sharma', 'MG Road', 'Pune'),
('Priya Patel', 'Laxmi Road', 'Pune'),
('Amit Kumar', 'JM Road', 'Pune'),
('Neha Deshmukh', 'DP Road', 'Pune'),
('Sunil Verma', 'SB Road', 'Pune');

INSERT INTO Account VALUES
('ACC001', 'Shivaji Nagar', 50000.00),
('ACC002', 'FC Road', 75000.00),
('ACC003', 'Kothrud', 25000.00),
('ACC004', 'Viman Nagar', 100000.00);

INSERT INTO Depositor VALUES
('Raj Sharma', 'ACC001'),
('Priya Patel', 'ACC002'),
('Amit Kumar', 'ACC003'),
('Neha Deshmukh', 'ACC004');

INSERT INTO Loan VALUES
('L001', 'Shivaji Nagar', 15000.00),
('L002', 'FC Road', 10000.00),
('L003', 'Kothrud', 20000.00),
('L004', 'Viman Nagar', 8000.00);

INSERT INTO Borrower VALUES
('Raj Sharma', 'L001'),
('Sunil Verma', 'L002'),
('Priya Patel', 'L003'),
('Amit Kumar', 'L004');

-- Question 1
SELECT DISTINCT c.cust_name
FROM Customer c
JOIN Depositor d ON c.cust_name = d.cust_name
JOIN Borrower b ON c.cust_name = b.cust_name;

-- Question 2
SELECT DISTINCT c.cust_name
FROM Customer c
LEFT JOIN Depositor d ON c.cust_name = d.cust_name
LEFT JOIN Borrower b ON c.cust_name = b.cust_name
WHERE d.acc_no IS NOT NULL OR b.loan_no IS NOT NULL;

-- Question 3
SELECT c.cust_name
FROM Customer c
JOIN Depositor d ON c.cust_name = d.cust_name
WHERE c.cust_name NOT IN (
    SELECT cust_name
    FROM Borrower
);

-- Question 4
SELECT a.branch_name, COUNT(DISTINCT d.cust_name) as num_depositors
FROM Account a
JOIN Depositor d ON a.acc_no = d.acc_no
GROUP BY a.branch_name;
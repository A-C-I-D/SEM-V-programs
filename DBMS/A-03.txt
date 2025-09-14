create database bank1;
use bank1;

CREATE TABLE account(
	account_number BIGINT PRIMARY KEY,
	branch_name varchar(10),
	balance int(10) 
);

CREATE TABLE branch(
	branch_name varchar(10) PRIMARY KEY,
	branch_city varchar(10) DEFAULT 'PUNE',
	assets BIGINT
);

CREATE TABLE customer(
	cust_name varchar(20) PRIMARY KEY,
	cust_street varchar(15),
	cust_city varchar(10)
);

CREATE TABLE loan(
	loan_no BIGINT PRIMARY KEY,
	branch_name varchar(10),
	amount int(8)
);

CREATE TABLE depositor(
	cust_name varchar(20),
	account_number BIGINT,
	FOREIGN KEY (cust_name) REFERENCES customer(cust_name),
	FOREIGN KEY (account_number) REFERENCES account(account_number)
);

CREATE TABLE borrower(
	cust_name varchar(20),
	loan_no BIGINT,
	FOREIGN KEY (cust_name) REFERENCES customer(cust_name),
	FOREIGN KEY (loan_no) REFERENCES loan(loan_no)
);

ALTER TABLE account
	ADD FOREIGN KEY (branch_name)
	REFERENCES branch(branch_name);
	
ALTER TABLE loan
	ADD FOREIGN KEY (branch_name)
	REFERENCES branch(branch_name);
	
desc account;
desc branch;
desc customer;
desc loan;
desc depositor;
desc borrower;

INSERT INTO branch
	VALUES("SUNCITY", "PUNE", 100000000);
	
INSERT INTO account
	VALUES(345243200001, "SUNCITY", 90031),
	(345243200002, "SUNCITY", 589224),
	(345243200003, "SUNCITY", 7998),
	(345243200004, "SUNCITY", 125448),
	(345243200005, "SUNCITY", 21542);

INSERT INTO customer
	VALUES("Ved", "Suncity", "Pune"),
	("Atrava", "Wadia", "Pune"),
	("Aditya", "KasbaPeth", "Pune"),
	("Manavi", "Gulhmore", "Pune"),
	("Harsh", "Koregoan", "Pune");
	
INSERT INTO loan
	VALUES(10992001, "SUNCITY", 15000),
	(10992002, "SUNCITY", 70000),
	(10992003, "SUNCITY", 643000);
	
INSERT INTO depositor
	VALUES("Ved", 345243200001),
	("Atrava", 345243200002),
	("Aditya", 345243200003),
	("Manavi", 345243200004),
	("Harsh", 345243200005);
	
INSERT INTO borrower
	VALUES("Ved", 10992001),
	("Manavi", 10992002),
	("Atrava", 10992003);
	
SELECT * FROM branch;
SELECT * FROM account;
SELECT * FROM customer;
SELECT * FROM loan;
SELECT * FROM depositor;
SELECT * FROM borrower;

INSERT INTO branch
	VALUES("AKRUDI", "PUNE", 50000000);

INSERT INTO account
	VALUES(345242300001, "AKRUDI", 979031),
	(345242300002, "AKRUDI", 58924),
	(345242300003, "AKRUDI", 688),
	(345242300004, "AKRUDI", 1848),
	(345242300005, "AKRUDI", 97542);

INSERT INTO customer
	VALUES("Tejas", "Akurdi", "Pune"),
	("Chitanaya", "ShinwarPeth", "Pune"),
	("Vaibhav", "Yerawada", "Pune"),
	("Rushi", "Nanded", "Pune"),
	("Sartak", "FC", "Pune");
	
INSERT INTO loan
	VALUES(10994001, "AKRUDI", 7500),
	(10994002, "AKRUDI", 980000),
	(10994003, "AKRUDI", 4500);
	
INSERT INTO depositor
	VALUES("Tejas", 345242300001),
	("Chitanaya", 345242300002),
	("Vaibhav", 345242300003),
	("Rushi", 345242300004),
	("Sartak", 345242300005);
	
INSERT INTO borrower
	VALUES("Chitanaya", 10994001),
	("Vaibhav", 10994002),
	("Tejas", 10994003);

INSERT INTO branch
	VALUES("BANDRA", "MUMBAI", 200000000),
	("ANDHERI", "MUMBAI", 150000000);

INSERT INTO customer
	VALUES("Priya", "Marine Drive", "Mumbai"),
	("Rohit", "Bandra West", "Mumbai"),
	("Pooja", "Andheri East", "Mumbai"),
	("Prasad", "Worli", "Mumbai"),
	("Sneha", "Powai", "Mumbai"),
	("Rajesh", "Thane", "Mumbai");

INSERT INTO account
	VALUES(345245600001, "BANDRA", 45000),
	(345245600002, "BANDRA", 78000),
	(345245600003, "ANDHERI", 12500),
	(345245600004, "ANDHERI", 95000),
	(345245600005, "BANDRA", 156000),
	(345245600006, "ANDHERI", 8500);

INSERT INTO loan
	VALUES(10995001, "BANDRA", 1400),
	(10995002, "BANDRA", 25000),
	(10995003, "ANDHERI", 1350),
	(10995004, "ANDHERI", 45000),
	(10995005, "AKRUDI", 13500);

INSERT INTO depositor
	VALUES("Priya", 345245600001),
	("Rohit", 345245600002),
	("Pooja", 345245600003),
	("Prasad", 345245600004),
	("Sneha", 345245600005),
	("Rajesh", 345245600006);

INSERT INTO borrower
	VALUES("Priya", 10995001),
	("Rohit", 10995002),
	("Pooja", 10995003),
	("Prasad", 10995004),
	("Rushi", 10995005);

-- 1.Create a View1 to display List all customers in alphabetical order who have loan from Suncity branch
CREATE VIEW View1 AS
	SELECT loan.loan_no, borrower.cust_name
	FROM loan, borrower
	WHERE loan.branch_name = 'SUNCITY' AND loan.loan_no = borrower.loan_no
	ORDER BY borrower.cust_name ASC;
	
SELECT * FROM View1;

-- 2. Create View2 on branch table by selecting any two columns and perform insert, update, delete operations
CREATE VIEW View2 AS
	SELECT branch_name, branch_city
	FROM branch;
	
SELECT * FROM View2;

INSERT INTO View2
	VALUES("AMBEGOAN", "PUNE"); 

SELECT * FROM View2;

UPDATE View2
	SET branch_city = 'BOMBAY'
	WHERE branch_city = 'MUMBAI';

SELECT * FROM View2;

DELETE FROM View2
	WHERE branch_city = 'BOMBAY';
	
-- 3. Create View3 on borrower and depositor table by selecting any one column from each table perform insert update delete operations.
CREATE VIEW View3 AS
	SELECT borrower.loan_no, depositor.account_number
	FROM borrower, depositor
	WHERE borrower.cust_name = depositor.cust_name;

SELECT * FROM View3;
	
INSERT INTO View3
	VALUES(10991001, 345243100001);
	
UPDATE View3
	SET loan_no = 10991001
	WHERE loan_no = 10992001;

DELETE FROM View2
	WHERE account_number = 345243200001;
	
SELECT * FROM View3;

-- 4. Create Union of left and right joint for all customers who have an account or loan or both at bank
    SELECT borrower.cust_name
    FROM borrower
    LEFT JOIN depositor
    ON borrower.cust_name = depositor.cust_name
    UNION
    SELECT depositor.cust_name 
    FROM depositor
    LEFT JOIN borrower
    ON borrower.cust_name = depositor.cust_name;
    
-- 5 Display content of View1, View2, View3
SELECT * FROM View1;

SELECT * FROM View2;

SELECT * FROM View3;

-- 6. Create Simple & Unique index.
CREATE INDEX account 
	ON account(account_number);

CREATE UNIQUE INDEX loan
	on loan(loan_no);

-- 7. Display Index information
SHOW INDEX FROM account;

SHOW INDEX FROM loan;

-- 8. Truncate table customer.
 DROP TABLE borrower;
 
 DROP TABLE depositor;
 
TRUNCATE TABLE customer;

---------------
CREATE DATABASE company;
use company;

CREATE TABLE Companies (
	comp_id varchar(4),
	name varchar(4),
	cost int(4),
	year int(4)
);

INSERT INTO Companies
	VALUES ("C001", "ONGC", 2000, 2010),
	("C002", "HPCL", 2500, 2012),
	("C004", "IOCL", 1000, 2014),
	("C005", "BHEL", 3000, 2015);

CREATE TABLE Orders (
	comp_id varchar(4),
	domain varchar(7),
	quantity int(3)
);

INSERT INTO Orders
	VALUES ("C001", "Oil", 109),
	("C002", "Gas", 121),
	("C005", "Telecom", 115);
	
-- 1. Find names, costs, domains & quantities for companies using inner join.	
SELECT Companies.name, Companies.cost, Orders.domain, Orders.quantity
FROM Companies
INNER JOIN Orders
ON Companies.comp_id = Orders.comp_id;

-- 2. Find names, costs, domains & quantities for companies using left outer join.	
SELECT Companies.name, Companies.cost, Orders.domain, Orders.quantity
FROM Companies
LEFT OUTER JOIN Orders
ON Companies.comp_id = Orders.comp_id;

-- 3. Find names, costs, domains & quantities for companies using right outer join.	
SELECT Companies.name, Companies.cost, Orders.domain, Orders.quantity
FROM Companies
RIGHT OUTER JOIN Orders
ON Companies.comp_id = Orders.comp_id;

-- 4. Find names, costs, domains & quantities for companies using union operator.	
SELECT Companies.name, Companies.cost, Orders.domain, Orders.quantity
FROM Companies
RIGHT JOIN Orders
ON Companies.comp_id = Orders.comp_id
UNION 
SELECT Companies.name, Companies.cost, Orders.domain, Orders.quantity
FROM Companies
LEFT JOIN Orders
ON Companies.comp_id = Orders.comp_id;

-- 5. Create View View1 by selecting both tables to show company name & quantities.
CREATE VIEW View1 AS
	SELECT Companies.name, Orders.quantity
	FROM Companies, Orders
	WHERE Companies.comp_id = Orders.comp_id;

-- 6. Create View2 on Company table by selecting any two column & perform insert, update, delete operation.
CREATE VIEW View2 AS
	SELECT comp_id, name
	FROM Companies;

INSERT INTO View2
	Values("C003", "SHEL"),
	("C004", "MNGL");
	
UPDATE View2
	SET name = "SPLC"
	WHERE name = "SHEL";

DELETE FROM View2
	WHERE comp_id = "C006";

-- 7. Display content of View1, View2.
SELECT * FROM View1;

SELECT * FROM View2;

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

-- 1. Find the names of all branches in loan relation.
SELECT branch_name 
	FROM loan;

-- 2. Find all loan numbers for loans made at Akurdi Branch with loan amount > 12000.
SELECT loan_no 
	FROM loan
	WHERE amount > 12000 AND branch_name = "AKRUDI";

-- 3. Find all customers who have a loan from bank. Find their names, loan_no and loan amount.
SELECT loan.loan_no, loan.amount, borrower.cust_name 
	FROM loan, borrower
	WHERE loan.loan_no = borrower.loan_no;

-- 4. List all customers in alphabetical order who have loan from Akurdi branch.
SELECT borrower.cust_name
	FROM borrower, loan
	WHERE loan.branch_name = "AKRUDI" AND loan.loan_no = borrower.loan_no
	ORDER BY cust_name ASC;

-- 5. Find all customers who have an account or loan or both at bank.
SELECT cust_name FROM depositor
UNION
SELECT cust_name FROM borrower;

-- 6. Find all customers who have both account and loan at bank.
SELECT depositor.cust_name
	FROM depositor, borrower
	WHERE depositor.cust_name = borrower.cust_name;

-- 7. Find all customers who have account but no loan at the bank.
SELECT cust_name
	FROM depositor
	WHERE cust_name NOT IN (SELECT cust_name FROM borrower);

-- 8. Find the average account balance at each branch.
SELECT branch_name, AVG(balance)
	FROM account
	GROUP BY branch_name;

-- 9. Find no. of depositors at each branch.
SELECT COUNT(depositor.account_number) AS num_depositors, account.branch_name
	FROM depositor, account
	WHERE depositor.account_number = account.account_number
	GROUP BY account.branch_name;

-- 10. Find name of Customer and city where customer name starts with Letter P.
SELECT cust_name, cust_city
	FROM customer
	WHERE cust_name LIKE "P%";

-- 11. Display distinct cities of branch.
SELECT DISTINCT branch_city
	FROM branch;

-- 12. Find the branches where average account balance > 12000.
SELECT branch_name, AVG(balance) AS avg_balance
	FROM account
	GROUP BY branch_name
	HAVING AVG(balance) > 12000;

-- 13. Find number of tuples in customer relation.
SELECT COUNT(*) AS total_customers
	FROM customer;

-- 14. Calculate total loan amount given by bank.
SELECT SUM(amount) AS total_loan_amount
	FROM loan;

-- 15. Delete all loans with loan amount between 1300 and 1500.
DELETE borrower FROM borrower
JOIN loan ON borrower.loan_no = loan.loan_no
WHERE loan.amount BETWEEN 1300 AND 1500;

DELETE FROM loan
WHERE amount BETWEEN 1300 AND 1500;

-- 16. Delete all tuples at every branch located in Mumbai.
DELETE depositor FROM depositor
JOIN account ON depositor.account_number = account.account_number
JOIN branch ON account.branch_name = branch.branch_name
WHERE branch.branch_city = 'MUMBAI';

DELETE borrower FROM borrower
JOIN loan ON borrower.loan_no = loan.loan_no
JOIN branch ON loan.branch_name = branch.branch_name
WHERE branch.branch_city = 'MUMBAI';

DELETE FROM account
WHERE branch_name IN (SELECT branch_name FROM branch WHERE branch_city = 'MUMBAI');

DELETE FROM loan
WHERE branch_name IN (SELECT branch_name FROM branch WHERE branch_city = 'MUMBAI');

DELETE FROM branch
WHERE branch_city = 'MUMBAI';

SELECT * FROM branch;
SELECT * FROM account;
SELECT * FROM customer;
SELECT * FROM loan;
SELECT * FROM depositor;
SELECT * FROM borrower;
DROP TABLE CUSTOMERS;
DROP TRIGGER trg_customers_salary_audit;
SET SERVEROUTPUT ON;

CREATE TABLE CUSTOMERS (
    customer_id NUMBER PRIMARY KEY,
    customer_name VARCHAR2(100),
    salary NUMBER(10,2)
);

CREATE OR REPLACE TRIGGER trg_customers_salary_audit
BEFORE INSERT OR UPDATE OR DELETE ON CUSTOMERS
FOR EACH ROW
DECLARE
    v_salary_diff NUMBER;
BEGIN
    IF INSERTING THEN
        DBMS_OUTPUT.PUT_LINE('INSERT Operation');
        DBMS_OUTPUT.PUT_LINE('New Salary: ' || :NEW.salary);

    ELSIF UPDATING THEN
        v_salary_diff := :NEW.salary - :OLD.salary;
        DBMS_OUTPUT.PUT_LINE('UPDATE Operation');
        DBMS_OUTPUT.PUT_LINE('Old Salary: ' || :OLD.salary);
        DBMS_OUTPUT.PUT_LINE('New Salary: ' || :NEW.salary);
        DBMS_OUTPUT.PUT_LINE('Salary Difference: ' || v_salary_diff);
        
    ELSIF DELETING THEN
        DBMS_OUTPUT.PUT_LINE('DELETE Operation');
        DBMS_OUTPUT.PUT_LINE('Deleted Salary: ' || :OLD.salary);
    END IF;
END;
/

INSERT INTO CUSTOMERS VALUES (1, 'Rahul Sharma', 60000);
INSERT INTO CUSTOMERS VALUES (2, 'Priya Patel', 75000);
INSERT INTO CUSTOMERS VALUES (3, 'Amit Kumar', 55000);
INSERT INTO CUSTOMERS VALUES (4, 'Sneha Singh', 80000);
INSERT INTO CUSTOMERS VALUES (5, 'Vikram Joshi', 72000);    

SELECT * FROM CUSTOMERS;

UPDATE CUSTOMERS
SET salary = 65000
WHERE customer_id = 1;

UPDATE CUSTOMERS
SET salary = 78000
WHERE customer_id = 2;

UPDATE CUSTOMERS
SET salary = 60000
WHERE customer_id = 5;

SELECT * FROM CUSTOMERS;

DELETE FROM CUSTOMERS
WHERE customer_id = 4;
DELETE FROM CUSTOMERS
WHERE customer_id = 3;

SELECT * FROM CUSTOMERS;
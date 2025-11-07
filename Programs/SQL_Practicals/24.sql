DROP TABLE Emp;
DROP TABLE Tracking;
SET SERVEROUTPUT ON;

CREATE TABLE Emp (
    Emp_no NUMBER PRIMARY KEY,
    Emp_name VARCHAR2(100),
    Emp_salary NUMBER(10,2)
);

CREATE TABLE Tracking (
    Emp_no NUMBER,
    Emp_salary NUMBER(10,2),
    operation_type VARCHAR2(20)
);

CREATE OR REPLACE TRIGGER trg_emp_salary_check
BEFORE INSERT OR UPDATE ON Emp
FOR EACH ROW
DECLARE
    min_salary CONSTANT NUMBER := 50000;
    v_operation_type VARCHAR2(20);
BEGIN
    IF INSERTING THEN
        v_operation_type := 'INSERT';
    ELSE
        v_operation_type := 'UPDATE';
    END IF;

    IF :NEW.Emp_salary < min_salary THEN
        INSERT INTO Tracking (Emp_no, Emp_salary, operation_type)
        VALUES (:NEW.Emp_no, :NEW.Emp_salary, v_operation_type);
        DBMS_OUTPUT.PUT_LINE('Salary below minimum threshold. Logged in Tracking table.');
    END IF;
END;
/

INSERT INTO Emp VALUES (1, 'Rahul Verma', 60000);
INSERT INTO Emp VALUES (2, 'Anita Desai', 40000);
INSERT INTO Emp VALUES (3, 'Sunil Kumar', 75000);
INSERT INTO Emp VALUES (4, 'Priya Singh', 30000);
INSERT INTO Emp VALUES (5, 'Vikram Patel', 55000);

UPDATE Emp SET Emp_salary = 65000 WHERE Emp_no = 1;
UPDATE Emp SET Emp_salary = 48000 WHERE Emp_no = 3;
UPDATE Emp SET Emp_salary = 29000 WHERE Emp_no = 5;

SELECT * FROM Emp;
SELECT * FROM Tracking;
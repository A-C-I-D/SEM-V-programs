DROP TABLE increment_salary;
DROP TABLE emp;

CREATE TABLE emp (
    emp_no NUMBER PRIMARY KEY,
    salary NUMBER(10,2)
);

CREATE TABLE increment_salary (
    emp_no NUMBER,
    salary NUMBER(10,2),
    increment_date DATE,
    FOREIGN KEY (emp_no) REFERENCES emp(emp_no)
);

INSERT INTO emp VALUES (1001, 45000);
INSERT INTO emp VALUES (1002, 55000);
INSERT INTO emp VALUES (1003, 35000);
INSERT INTO emp VALUES (1004, 65000);
INSERT INTO emp VALUES (1005, 40000);

DECLARE
    v_avg_salary NUMBER(10,2);
    
    CURSOR c_emp_salary IS
        SELECT emp_no, salary
        FROM emp
        WHERE salary < (SELECT AVG(salary) FROM emp);
BEGIN
    SELECT AVG(salary) INTO v_avg_salary FROM emp;    
    DBMS_OUTPUT.PUT_LINE('Average salary: ' || v_avg_salary);
    FOR emp_rec IN c_emp_salary LOOP
        DECLARE
            v_new_salary NUMBER(10,2);
        BEGIN
            v_new_salary := emp_rec.salary * 1.1;
            
            UPDATE emp
            SET salary = v_new_salary
            WHERE emp_no = emp_rec.emp_no;
            
            INSERT INTO increment_salary (emp_no, salary, increment_date)
            VALUES (emp_rec.emp_no, v_new_salary, SYSDATE);
            
            DBMS_OUTPUT.PUT_LINE('Employee ' || emp_rec.emp_no || 
                               ' salary increased from ' || emp_rec.salary || 
                               ' to ' || v_new_salary);
        END;
    END LOOP;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Salary increment process completed successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        ROLLBACK;
END;
/
SELECT * FROM emp ORDER BY emp_no;
SELECT * FROM increment_salary ORDER BY emp_no;

DROP TABLE increment_salary;
DROP TABLE emp;
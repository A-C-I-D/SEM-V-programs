DROP TABLE Stud_Marks;
DROP TABLE Result;

CREATE TABLE Stud_Marks (
    Roll NUMBER PRIMARY KEY,
    Name VARCHAR2(100),
    total_marks NUMBER(4)
);

CREATE TABLE Result (
    Roll NUMBER PRIMARY KEY,
    Name VARCHAR2(100),
    Class VARCHAR2(50),
    FOREIGN KEY (Roll) REFERENCES Stud_Marks(Roll)
);

INSERT INTO Stud_Marks VALUES (101, 'Rahul Verma', 1200);
INSERT INTO Stud_Marks VALUES (102, 'Priya Shah', 950);
INSERT INTO Stud_Marks VALUES (103, 'Amit Kumar', 875);
INSERT INTO Stud_Marks VALUES (104, 'Sneha Patel', 1100);
INSERT INTO Stud_Marks VALUES (105, 'Raj Singh', 920);

CREATE OR REPLACE PROCEDURE proc_Grade (
    p_roll IN NUMBER,
    p_grade OUT VARCHAR2
) IS
    v_marks NUMBER;
    v_name VARCHAR2(100);
BEGIN
    SELECT total_marks, Name
    INTO v_marks, v_name
    FROM Stud_Marks
    WHERE Roll = p_roll;
    
    IF v_marks >= 990 AND v_marks <= 1500 THEN
        p_grade := 'Distinction';
    ELSIF v_marks >= 900 AND v_marks <= 989 THEN
        p_grade := 'First Class';
    ELSIF v_marks >= 825 AND v_marks <= 899 THEN
        p_grade := 'Higher Second Class';
    ELSE
        p_grade := 'Pass Class';
    END IF;

    MERGE INTO Result r
    USING (SELECT p_roll as roll, v_name as name, p_grade as class FROM dual) s
    ON (r.Roll = s.roll)
    WHEN MATCHED THEN
        UPDATE SET r.Class = s.class
    WHEN NOT MATCHED THEN
        INSERT (Roll, Name, Class)
        VALUES (s.roll, s.name, s.class);
        
    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'Student with Roll No ' || p_roll || ' not found');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Error: ' || SQLERRM);
END proc_Grade;
/

DECLARE
    v_grade VARCHAR2(50);
    v_roll NUMBER;
BEGIN
    v_roll := &roll_no;
    proc_Grade(v_roll, v_grade);
    
    DBMS_OUTPUT.PUT_LINE('Grade for Roll No ' || v_roll || ': ' || v_grade);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/


DECLARE
    v_grade VARCHAR2(50);
    v_roll NUMBER;
BEGIN
    v_roll := &roll_no;
    proc_Grade(v_roll, v_grade);
    
    DBMS_OUTPUT.PUT_LINE('Grade for Roll No ' || v_roll || ': ' || v_grade);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

SELECT * FROM Result;

DROP PROCEDURE proc_Grade;
DROP TABLE Result;
DROP TABLE Stud_Marks;
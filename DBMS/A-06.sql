CREATE TABLE Stud_Marks (
    roll NUMBER PRIMARY KEY,
    name VARCHAR2(10),
    total_marks NUMBER
);

CREATE TABLE Result (
    roll NUMBER PRIMARY KEY,
    name VARCHAR2(10),
    class VARCHAR2(20)
);

INSERT INTO Stud_Marks VALUES (1, 'Ved', 1200);
INSERT INTO Stud_Marks VALUES (2, 'Sarthak', 950);
INSERT INTO Stud_Marks VALUES (3, 'Sarvesh', 875);
INSERT INTO Stud_Marks VALUES (4, 'Athrava', 800);
INSERT INTO Stud_Marks VALUES (5, 'Aadi', 750);

SELECT * FROM Stud_Marks;

CREATE OR REPLACE PROCEDURE proc_Grade (
    p_roll IN NUMBER,
    p_name IN VARCHAR2,
    p_marks IN NUMBER
) AS
    v_class VARCHAR2(20);
BEGIN
    IF p_marks >= 990 AND p_marks <= 1500 THEN
        v_class := 'Distinction';
    ELSIF p_marks >= 900 AND p_marks <= 989 THEN
        v_class := 'First Class';
    ELSIF p_marks >= 825 AND p_marks <= 899 THEN
        v_class := 'Higher Second Class';
    ELSIF p_marks >= 0 AND p_marks < 825 THEN
        v_class := 'Second Class';
    ELSE
        v_class := 'Invalid Marks';
    END IF;

    BEGIN
        INSERT INTO Result (roll, name, class)
        VALUES (p_roll, p_name, v_class);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            UPDATE Result
            SET name = p_name, class = v_class
            WHERE roll = p_roll;
    END;
    
    DBMS_OUTPUT.PUT_LINE('Student: ' || p_name || ' classified as: ' || v_class);
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        ROLLBACK;
END proc_Grade;
/

SELECT * FROM Result;

SET SERVEROUTPUT ON;

DECLARE
    CURSOR c_students IS
        SELECT rownum as roll, name, total_marks
        FROM Stud_Marks;
    
    v_roll NUMBER;
    v_name VARCHAR2(50);
    v_marks NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Processing Student Grades');
    
    FOR student_rec IN c_students LOOP
        proc_Grade(student_rec.roll, student_rec.name, student_rec.total_marks);
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('All students processed successfully!');
    
END;
/


SELECT * FROM Result ORDER BY roll;

BEGIN
    proc_Grade(6, 'Aditya', 1100);
END;
/


DECLARE
    v_roll NUMBER := 7;
    v_name VARCHAR2(50) := 'Pranav';
    v_marks NUMBER := 920;
BEGIN
    proc_Grade(v_roll, v_name, v_marks);
END;
/

DROP TABLE Result;
DROP TABLE Stud_Marks;
DROP PROCEDURE proc_Grade;
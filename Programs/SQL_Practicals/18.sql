DROP table Student;

CREATE TABLE Student (
  Roll       NUMBER PRIMARY KEY,
  Name       VARCHAR2(100),
  Attendance NUMBER,
  Status     VARCHAR2(20)
);

SET SERVEROUTPUT ON;
DECLARE
  v_roll       Student.Roll%TYPE;
  v_name       Student.Name%TYPE;
  v_attendance Student.Attendance%TYPE;
BEGIN
  v_roll := &roll_no;
  v_name := '&name';
  v_attendance := &attendance;
  
  INSERT INTO Student (Roll, Name, Attendance) VALUES (v_roll, v_name, v_attendance);
  
  IF v_attendance < 75 THEN
    UPDATE Student SET Status = 'Detained' WHERE Roll = v_roll;
    DBMS_OUTPUT.PUT_LINE('Term not granted');
  ELSE
    UPDATE Student SET Status = 'Not Detained' WHERE Roll = v_roll;
    DBMS_OUTPUT.PUT_LINE('Term granted');
  END IF;
  
  COMMIT;
  
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
    DBMS_OUTPUT.PUT_LINE('Error: Student with Roll ' || v_roll || ' already exists.');
    ROLLBACK;
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    ROLLBACK;
END;
/
CREATE TABLE O_RollCall (
    roll_no NUMBER PRIMARY KEY,
    student_name VARCHAR2(10),
    class VARCHAR2(20),
    attendance_date DATE
);

CREATE TABLE N_RollCall (
    roll_no NUMBER PRIMARY KEY,
    student_name VARCHAR2(10),
    class VARCHAR2(20),
    attendance_date DATE
);

INSERT INTO O_RollCall VALUES (101, 'Rajesh', 'CS-A', SYSDATE-5);
INSERT INTO O_RollCall VALUES (102, 'Priya', 'CS-A', SYSDATE-5);
INSERT INTO O_RollCall VALUES (103, 'Amit', 'CS-B', SYSDATE-5);
INSERT INTO O_RollCall VALUES (104, 'Sneha', 'CS-B', SYSDATE-5);
INSERT INTO O_RollCall VALUES (105, 'Vikram', 'CS-A', SYSDATE-5);


INSERT INTO N_RollCall VALUES (102, 'Priya', 'CS-A', SYSDATE);       
INSERT INTO N_RollCall VALUES (104, 'Sneha', 'CS-B', SYSDATE);       
INSERT INTO N_RollCall VALUES (106, 'Ved', 'CS-A', SYSDATE);
INSERT INTO N_RollCall VALUES (107, 'Sarvesh', 'CS-B', SYSDATE);         
INSERT INTO N_RollCall VALUES (108, 'Yash', 'CS-A', SYSDATE);  
INSERT INTO N_RollCall VALUES (109, 'Tanvi', 'CS-B', SYSDATE);      

SET SERVEROUTPUT ON;

DECLARE
    CURSOR c_new_students (p_class VARCHAR2) IS
        SELECT roll_no, student_name, class, attendance_date
        FROM N_RollCall
        WHERE class = p_class
        ORDER BY roll_no;
    
    v_roll_no NUMBER;
    v_student_name VARCHAR2(50);
    v_class VARCHAR2(20);
    v_attendance_date DATE;
    
    v_inserted_count NUMBER := 0;
    v_skipped_count NUMBER := 0;
    v_total_count NUMBER := 0;
    
    v_exists NUMBER;
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('MERGING N_RollCall INTO O_RollCall');
    DBMS_OUTPUT.PUT_LINE('');
    
    DBMS_OUTPUT.PUT_LINE('Processing Class: CS-A');
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------');
    
    FOR student_rec IN c_new_students('CS-A') LOOP
        v_total_count := v_total_count + 1;
        
        SELECT COUNT(*)
        INTO v_exists
        FROM O_RollCall
        WHERE roll_no = student_rec.roll_no;
        
        IF v_exists = 0 THEN
            INSERT INTO O_RollCall (roll_no, student_name, class, attendance_date)
            VALUES (student_rec.roll_no, student_rec.student_name, 
                    student_rec.class, student_rec.attendance_date);
            
            DBMS_OUTPUT.PUT_LINE('Inserted: Roll No ' || student_rec.roll_no || 
                               ' - ' || student_rec.student_name);
            v_inserted_count := v_inserted_count + 1;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Skipped: Roll No ' || student_rec.roll_no || 
                               ' - ' || student_rec.student_name || ' (Already exists)');
            v_skipped_count := v_skipped_count + 1;
        END IF;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('');
    
    DBMS_OUTPUT.PUT_LINE('Processing Class: CS-B');
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------');
    
    FOR student_rec IN c_new_students('CS-B') LOOP
        v_total_count := v_total_count + 1;
        
        SELECT COUNT(*)
        INTO v_exists
        FROM O_RollCall
        WHERE roll_no = student_rec.roll_no;
        
        IF v_exists = 0 THEN
            INSERT INTO O_RollCall (roll_no, student_name, class, attendance_date)
            VALUES (student_rec.roll_no, student_rec.student_name, 
                    student_rec.class, student_rec.attendance_date);
            
            DBMS_OUTPUT.PUT_LINE('Inserted: Roll No ' || student_rec.roll_no || 
                               ' - ' || student_rec.student_name);
            v_inserted_count := v_inserted_count + 1;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Skipped: Roll No ' || student_rec.roll_no || 
                               ' - ' || student_rec.student_name || ' (Already exists)');
            v_skipped_count := v_skipped_count + 1;
        END IF;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('MERGE SUMMARY');
    DBMS_OUTPUT.PUT_LINE('Total Records Processed: ' || v_total_count);
    DBMS_OUTPUT.PUT_LINE('Records Inserted: ' || v_inserted_count);
    DBMS_OUTPUT.PUT_LINE('Records Skipped: ' || v_skipped_count);
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
END;
/

DBMS_OUTPUT.PUT_LINE('');
DBMS_OUTPUT.PUT_LINE('Final O_RollCall Table Contents:');

SELECT * FROM O_RollCall ORDER BY roll_no;

DECLARE
    CURSOR c_new_students (p_class VARCHAR2) IS
        SELECT roll_no, student_name, class, attendance_date
        FROM N_RollCall
        WHERE class = p_class OR p_class IS NULL
        ORDER BY class, roll_no;
    
    CURSOR c_classes IS
        SELECT DISTINCT class FROM N_RollCall ORDER BY class;
    
    v_exists NUMBER;
    v_inserted NUMBER := 0;
    v_skipped NUMBER := 0;
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('DYNAMIC MERGE - ALL CLASSES');
    
    FOR class_rec IN c_classes LOOP
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('Processing Class: ' || class_rec.class);
        DBMS_OUTPUT.PUT_LINE('-------------------------------------------------');
        
        FOR student_rec IN c_new_students(class_rec.class) LOOP
            
            SELECT COUNT(*) INTO v_exists
            FROM O_RollCall
            WHERE roll_no = student_rec.roll_no;
            
            IF v_exists = 0 THEN
                INSERT INTO O_RollCall VALUES (
                    student_rec.roll_no,
                    student_rec.student_name,
                    student_rec.class,
                    student_rec.attendance_date
                );
                DBMS_OUTPUT.PUT_LINE('✓ ' || student_rec.roll_no || ' - ' || student_rec.student_name);
                v_inserted := v_inserted + 1;
            ELSE
                DBMS_OUTPUT.PUT_LINE('✗ ' || student_rec.roll_no || ' - ' || student_rec.student_name || ' (Exists)');
                v_skipped := v_skipped + 1;
            END IF;
        END LOOP;
    END LOOP;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Summary: ' || v_inserted || ' inserted, ' || v_skipped || ' skipped');
    
END;
/

DROP TABLE N_RollCall;
DROP TABLE O_RollCall;

DROP TABLE O_RollCall;
DROP TABLE N_RollCall;
SET SERVEROUTPUT ON;

CREATE TABLE O_RollCall (
    roll_no NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    class VARCHAR2(50),
    division VARCHAR2(10),
    status CHAR(1)
);

CREATE TABLE N_RollCall (
    roll_no NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    class VARCHAR2(50),
    division VARCHAR2(10),
    status CHAR(1)
);

INSERT INTO O_RollCall VALUES (1, 'Rahul Verma', 'TY BSc', 'A', 'P');
INSERT INTO O_RollCall VALUES (2, 'Priya Shah', 'TY BSc', 'A', 'A');
INSERT INTO O_RollCall VALUES (3, 'Amit Patel', 'TY BSc', 'B', 'P');

INSERT INTO N_RollCall VALUES (2, 'Priya Shah', 'TY BSc', 'B', 'P');
INSERT INTO N_RollCall VALUES (4, 'Sneha Kumar', 'TY BSc', 'A', 'P');
INSERT INTO N_RollCall VALUES (5, 'Raj Sharma', 'TY BSc', 'B', 'A');
DECLARE
    CURSOR new_records IS
        SELECT * FROM N_RollCall;
    
    v_count NUMBER;
BEGIN
    FOR new_rec IN new_records LOOP
        SELECT COUNT(*)
        INTO v_count
        FROM O_RollCall
        WHERE roll_no = new_rec.roll_no;

        IF v_count > 0 THEN
            UPDATE O_RollCall
            SET name = new_rec.name,
                class = new_rec.class,
                division = new_rec.division,
                status = new_rec.status
            WHERE roll_no = new_rec.roll_no;
            
            DBMS_OUTPUT.PUT_LINE('Updated Roll No: ' || new_rec.roll_no);
        ELSE
            INSERT INTO O_RollCall
            VALUES (
                new_rec.roll_no,
                new_rec.name,
                new_rec.class,
                new_rec.division,
                new_rec.status
            );
            
            DBMS_OUTPUT.PUT_LINE('Inserted Roll No: ' || new_rec.roll_no);
        END IF;
    END LOOP;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Merge completed successfully.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

SELECT * FROM O_RollCall ORDER BY roll_no;
DROP TABLE Fine;
DROP TABLE Borrower;
SET SERVEROUTPUT ON;

CREATE TABLE Borrower (
    Rollin NUMBER PRIMARY KEY,
    Name VARCHAR2(100),
    DateofIssue DATE,
    NameofBook VARCHAR2(100),
    Status CHAR(1) CHECK (Status IN ('I', 'R'))
);

CREATE TABLE Fine (
    Roll_no NUMBER,
    Date_Returned DATE,
    Amt NUMBER(10,2),
    FOREIGN KEY (Roll_no) REFERENCES Borrower(Rollin)
);

INSERT INTO Borrower VALUES (101, 'Rahul Sharma', '01-OCT-2025', 'Database Management', 'I');
INSERT INTO Borrower VALUES (102, 'Priya Patel', '15-OCT-2025', 'Data Structures', 'I');
INSERT INTO Borrower VALUES (103, 'Amit Kumar', '20-OCT-2025', 'Operating Systems', 'I');

DECLARE
    v_roll_no NUMBER;
    v_book_name VARCHAR2(100);
    v_date_of_issue DATE;
    v_days NUMBER;
    v_fine_amount NUMBER(10,2);
    v_status CHAR(1);
BEGIN
    v_roll_no := &roll_no;
    v_book_name := '&book_name';
    
    SELECT DateofIssue, Status
    INTO v_date_of_issue, v_status
    FROM Borrower
    WHERE Rollin = v_roll_no AND NameofBook = v_book_name;
    
    v_days := TRUNC(SYSDATE - v_date_of_issue);

    IF v_days BETWEEN 15 AND 30 THEN
        v_fine_amount := v_days * 5;
    ELSIF v_days > 30 THEN
        v_fine_amount := (30 * 5) + ((v_days - 30) * 50);
    ELSE
        v_fine_amount := 0;
    END IF;
    
    UPDATE Borrower
    SET Status = 'R'
    WHERE Rollin = v_roll_no AND NameofBook = v_book_name;
    
    IF v_fine_amount > 0 THEN
        INSERT INTO Fine (Roll_no, Date_Returned, Amt)
        VALUES (v_roll_no, SYSDATE, v_fine_amount);
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('Fine Amount: Rs. ' || v_fine_amount);
    
    COMMIT;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No such borrower or book found!');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        ROLLBACK;
END;
/
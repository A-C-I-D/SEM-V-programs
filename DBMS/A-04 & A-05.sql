CREATE TABLE Borrower(
    Roll_no INT PRIMARY KEY,
    Name VARCHAR2(20),
    Date_of_Issue DATE,
    Name_of_Book VARCHAR2(50),
    Status CHAR(1)
);

CREATE TABLE Fine(
    Roll_no INT,
    Date_of_Fine DATE,
    Amt INT,
    FOREIGN KEY (Roll_no) REFERENCES Borrower(Roll_no)
);

INSERT INTO Borrower VALUES (1, 'Rohan Patil', TO_DATE('2025-08-20', 'YYYY-MM-DD'), 'DBMS Concepts', 'I');
INSERT INTO Borrower VALUES (2, 'Sneha Kulkarni', TO_DATE('2025-07-25', 'YYYY-MM-DD'), 'Operating Systems', 'I');
INSERT INTO Borrower VALUES (3, 'Amit Sharma', TO_DATE('2025-09-01', 'YYYY-MM-DD'), 'Computer Networks', 'I');
INSERT INTO Borrower VALUES (4, 'Priya Deshmukh', TO_DATE('2025-06-15', 'YYYY-MM-DD'), 'Java Programming', 'I');
INSERT INTO Borrower VALUES (5, 'Vikram Joshi', TO_DATE('2025-08-30', 'YYYY-MM-DD'), 'Data Structures', 'I');


SET SERVEROUTPUT ON;

DECLARE
  -- use table%TYPE where possible
  roll        Borrower.Roll_no%TYPE := &roll_no;
  name_book   Borrower.Name_of_Book%TYPE := '&Name_Of_The_Book';
  date_issue  Borrower.Date_of_Issue%TYPE;
  fine        NUMBER := 0;
  totalDays   NUMBER;
BEGIN
  SELECT Date_of_Issue
    INTO date_issue
    FROM Borrower
   WHERE Roll_no = roll
     AND Name_of_Book = name_book;

  totalDays := TRUNC(SYSDATE) - TRUNC(date_issue);

  IF totalDays < 15 THEN
    DBMS_OUTPUT.PUT_LINE('No fine. Book returned within 15 days. (Days = ' || totalDays || ')');
    UPDATE Borrower
       SET Status = 'R'
     WHERE Roll_no = roll
       AND Name_of_Book = name_book;

    INSERT INTO Fine (Roll_no, Date_of_Fine, Amt)
    VALUES (roll, SYSDATE, 0);

  ELSIF totalDays BETWEEN 15 AND 30 THEN
    fine := (totalDays - 15) * 5;
    DBMS_OUTPUT.PUT_LINE('Fine is ' || TO_CHAR(fine) || ' Rs. (Days = ' || totalDays || ')');

    UPDATE Borrower
       SET Status = 'R'
     WHERE Roll_no = roll
       AND Name_of_Book = name_book;

    INSERT INTO Fine (Roll_no, Date_of_Fine, Amt)
    VALUES (roll, SYSDATE, ROUND(fine));

  ELSE
    fine := (15 * 5) + ((totalDays - 30) * 50);
    DBMS_OUTPUT.PUT_LINE('Fine is ' || TO_CHAR(fine) || ' Rs. (Days = ' || totalDays || ')');

    UPDATE Borrower
       SET Status = 'R'
     WHERE Roll_no = roll
       AND Name_of_Book = name_book;

    INSERT INTO Fine (Roll_no, Date_of_Fine, Amt)
    VALUES (roll, SYSDATE, ROUND(fine));
  END IF;

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Operation completed successfully.');

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No matching borrower record found for Roll_no=' || roll || ' and Book="' || name_book || '".');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
END;
/

-- Circle area calculation from 5 to 9

CREATE TABLE circle(
    radius INT PRIMARY KEY,
    area FLOAT
);

SET SERVEROUTPUT ON;
DECLARE
    r INT;
    a FLOAT;
BEGIN
    FOR r IN 5..9 LOOP
        a := 3.14 * r * r;
        INSERT INTO circle (radius, area) VALUES (r, a);
        DBMS_OUTPUT.PUT_LINE('Radius: ' || r || ', Area: ' || a);
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('All records inserted successfully.');

END;
/
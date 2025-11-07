DROP TABLE Library_Audit;
DROP TABLE Library;
DROP SEQUENCE audit_seq;
DROP TRIGGER Library_Before_Trigger;
DROP TRIGGER Library_After_Trigger;

CREATE TABLE Library (
  Book_ID NUMBER PRIMARY KEY,
  Book_Name VARCHAR2(100),
  Author VARCHAR2(100),
  Price NUMBER,
  Quantity NUMBER
);

CREATE TABLE Library_Audit (
  Audit_ID NUMBER PRIMARY KEY,
  Book_ID NUMBER,
  Book_Name VARCHAR2(100),
  Author VARCHAR2(100),
  Price NUMBER,
  Quantity NUMBER,
  Operation VARCHAR2(10),
  Operation_Date DATE,
  Trigger_Type VARCHAR2(10)
);

CREATE SEQUENCE audit_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER Library_Before_Trigger
BEFORE UPDATE OR DELETE ON Library
FOR EACH ROW
DECLARE
  v_operation VARCHAR2(10);
BEGIN
  IF UPDATING THEN
    v_operation := 'UPDATE';
  ELSE
    v_operation := 'DELETE';
  END IF;

  INSERT INTO Library_Audit (
    Audit_ID,
    Book_ID,
    Book_Name,
    Author,
    Price,
    Quantity,
    Operation,
    Operation_Date,
    Trigger_Type
  ) VALUES (
    audit_seq.NEXTVAL,
    :OLD.Book_ID,
    :OLD.Book_Name,
    :OLD.Author,
    :OLD.Price,
    :OLD.Quantity,
    v_operation,
    SYSDATE,
    'BEFORE'
  );
END;
/

CREATE OR REPLACE TRIGGER Library_After_Trigger
AFTER UPDATE OR DELETE ON Library
FOR EACH ROW
DECLARE
  v_operation VARCHAR2(10);
BEGIN
  IF UPDATING THEN
    v_operation := 'UPDATE';
  ELSE
    v_operation := 'DELETE';
  END IF;

  INSERT INTO Library_Audit (
    Audit_ID,
    Book_ID,
    Book_Name,
    Author,
    Price,
    Quantity,
    Operation,
    Operation_Date,
    Trigger_Type
  ) VALUES (
    audit_seq.NEXTVAL,
    :OLD.Book_ID,
    :OLD.Book_Name,
    :OLD.Author,
    :OLD.Price,
    :OLD.Quantity,
    v_operation,
    SYSDATE,
    'AFTER'
  );
END;
/

INSERT INTO Library VALUES (1, 'Database Systems', 'Ramez Elmasri', 500, 10);
INSERT INTO Library VALUES (2, 'Operating Systems', 'Silberschatz', 450, 15);
INSERT INTO Library VALUES (3, 'Computer Networks', 'Andrew S. Tanenbaum', 600, 8);
INSERT INTO Library VALUES (4, 'Artificial Intelligence', 'Stuart Russell', 700, 5);
INSERT INTO Library VALUES (5, 'Data Structures', 'Mark Allen Weiss', 400, 12);
INSERT INTO Library VALUES (6, 'Software Engineering', 'Ian Sommerville', 550, 7);  
INSERT INTO Library VALUES (7, 'Computer Architecture', 'John L. Hennessy', 650, 9);


UPDATE Library SET Price = 550 WHERE Book_ID = 1;
UPDATE Library SET Quantity = 20 WHERE Book_ID = 3;
UPDATE Library SET Price = 750, Quantity = 10 WHERE Book_ID = 4;
UPDATE Library SET Price = 420 WHERE Book_ID = 6;

DELETE FROM Library WHERE Book_ID = 2;
DELETE FROM Library WHERE Book_ID = 5;
DELETE FROM Library WHERE Book_ID = 7;

SELECT * FROM Library_Audit ORDER BY Audit_ID;


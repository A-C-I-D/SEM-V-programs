CREATE TABLE Library (
    book_id NUMBER PRIMARY KEY,
    title VARCHAR2(30),
    author VARCHAR2(20),
    isbn VARCHAR2(20),
    quantity NUMBER,
    price NUMBER(10,2)
);

CREATE TABLE Library_Audit (
    audit_id NUMBER PRIMARY KEY,
    book_id NUMBER,
    title VARCHAR2(30),
    author VARCHAR2(20),
    isbn VARCHAR2(20),
    quantity NUMBER,
    price NUMBER(10,2),
    operation VARCHAR2(10),
    operation_date TIMESTAMP,
    username VARCHAR2(15)
);

CREATE SEQUENCE audit_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER library_update_trigger
BEFORE UPDATE ON Library
FOR EACH ROW
BEGIN
    INSERT INTO Library_Audit (
        audit_id,
        book_id,
        title,
        author,
        isbn,
        quantity,
        price,
        operation,
        operation_date,
        username
    ) VALUES (
        audit_seq.NEXTVAL,
        :OLD.book_id,
        :OLD.title,
        :OLD.author,
        :OLD.isbn,
        :OLD.quantity,
        :OLD.price,
        'UPDATE',
        SYSTIMESTAMP,
        USER
    );
END;
/

CREATE OR REPLACE TRIGGER library_delete_trigger
BEFORE DELETE ON Library
FOR EACH ROW
BEGIN
    INSERT INTO Library_Audit (
        audit_id,
        book_id,
        title,
        author,
        isbn,
        quantity,
        price,
        operation,
        operation_date,
        username
    ) VALUES (
        audit_seq.NEXTVAL,
        :OLD.book_id,
        :OLD.title,
        :OLD.author,
        :OLD.isbn,
        :OLD.quantity,
        :OLD.price,
        'DELETE',
        SYSTIMESTAMP,
        USER
    );
END;
/

INSERT INTO Library VALUES (1, 'Database Systems', 'Ramez Elmasri', '978-0133970777', 15, 89.99);
INSERT INTO Library VALUES (2, 'Clean Code', 'Robert Martin', '978-0132350884', 20, 45.50);
INSERT INTO Library VALUES (3, 'Design Patterns', 'Erich Gamma', '978-0201633610', 10, 54.99);
INSERT INTO Library VALUES (4, 'The Pragmatic Programmer', 'Andrew Hunt', '978-0135957059', 12, 49.95);
INSERT INTO Library VALUES (5, 'Introduction to Algorithms', 'Thomas Cormen', '978-0262033848', 8, 95.00);

SELECT * FROM Library;

SELECT * FROM Library_Audit;

UPDATE Library SET quantity = 18, price = 85.99 WHERE book_id = 1;

UPDATE Library SET author = 'Robert C. Martin' WHERE book_id = 2;

DELETE FROM Library WHERE book_id = 5;

SELECT * FROM Library;

SELECT * FROM Library_Audit;

DROP TRIGGER library_update_trigger;
DROP TRIGGER library_delete_trigger;
DROP TABLE Library_Audit;
DROP TABLE Library;
DROP SEQUENCE audit_seq;
DROP TABLE areas;
SET SERVEROUTPUT ON;

CREATE TABLE areas (
    radius NUMBER(5,2),
    area NUMBER(12,2)
);

DECLARE
    v_area NUMBER(12,2);
    v_pi CONSTANT NUMBER(4,2) := 3.14;
BEGIN
    FOR v_radius IN 5..9 LOOP
        v_area := v_pi * v_radius * v_radius;
        
        INSERT INTO areas (radius, area)
        VALUES (v_radius, v_area);
        
        DBMS_OUTPUT.PUT_LINE('Radius: ' || v_radius || ', Area: ' || v_area);
    END LOOP;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/

SELECT * FROM areas ORDER BY radius;
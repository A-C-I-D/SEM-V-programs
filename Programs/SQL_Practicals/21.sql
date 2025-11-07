DROP FUNCTION Age_calc;

CREATE OR REPLACE FUNCTION Age_calc(
  p_dob IN DATE,
  p_months OUT NUMBER,
  p_days OUT NUMBER
) RETURN NUMBER IS
  v_years NUMBER;
  v_total_months NUMBER;
  v_total_days NUMBER;
BEGIN
  v_total_days := TRUNC(SYSDATE) - TRUNC(p_dob);
  
  v_years := TRUNC(MONTHS_BETWEEN(SYSDATE, p_dob) / 12);
  v_total_months := TRUNC(MONTHS_BETWEEN(SYSDATE, p_dob));
  
  p_months := v_total_months - (v_years * 12);
  p_days := v_total_days - TRUNC(ADD_MONTHS(p_dob, v_total_months) - p_dob);
  
  RETURN v_years;
END;
/

SET SERVEROUTPUT ON;
DECLARE
  v_dob DATE;
  v_years NUMBER;
  v_months NUMBER;
  v_days NUMBER;
BEGIN
  v_dob := TO_DATE('&date_of_birth', 'DD-MON-YYYY');
  
  v_years := Age_calc(v_dob, v_months, v_days);
  
  DBMS_OUTPUT.PUT_LINE('Age: ' || v_years || ' years, ' || v_months || ' months, ' || v_days || ' days');
END;
/

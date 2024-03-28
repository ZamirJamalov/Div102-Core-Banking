-- This script generates fake tardiness data for employee tracking.
-- The tardiness tracking system began on January 1, 2010.
-- Fake data will be generated from the start date until January 1, 2023.
-- For each day, tardiness records will be generated for 20 employees.
-- The 20 employees will be randomly selected from the EMPLOYEES table.

DECLARE 
    v_days_count NUMBER;
    v_emp_id NUMBER;
    v_tardiness_date DATE;
    v_minutes_late NUMBER;
    v_coll_count NUMBER;
    TYPE TLIST IS TABLE OF NUMBER(10);
    v_emp_list TLIST := TLIST();
BEGIN
    -- Calculate the number of days between the start date and January 1, 2023.
    SELECT TO_DATE('01.01.2023','DD.MM.YYYY') - TO_DATE('01.01.2010','DD.MM.YYYY') INTO v_days_count FROM dual;
    
    -- Set the start date for generating tardiness data.
    v_tardiness_date := TO_DATE('01.01.2010','DD.MM.YYYY');
    
    -- Loop through each day to generate tardiness data.
    FOR i IN 1..v_days_count LOOP
        -- Clear the employee list for each day.
        v_emp_list.DELETE;
        
        -- Set the next date for generating tardiness data.
        v_tardiness_date := v_tardiness_date + 1;
        
        -- Randomly select 1 to 3 employees for tardiness records.
        FOR j IN 1..FLOOR(DBMS_RANDOM.VALUE(1,3)) LOOP
            <<get_emp_id>>
            -- Randomly select an employee ID.
            v_emp_id := FLOOR(DBMS_RANDOM.VALUE(100,207));
            
            -- Check if the employee ID already exists in the collection for the same date.
            FOR k IN 1..v_emp_list.COUNT LOOP 
                IF v_emp_list(k) = v_emp_id THEN 
                    -- Skip adding the same employee ID again for the same date.
                    GOTO get_emp_id;
                END IF;
            END LOOP k;    
            
            -- Add the employee ID to the collection.
            v_emp_list.EXTEND(1);
            v_emp_list(v_emp_list.LAST) := v_emp_id;
            
            -- Generate random minutes late for the tardiness record.
            v_minutes_late := FLOOR(DBMS_RANDOM.VALUE(1,20));
            
            -- Insert the tardiness record into the tardiness_tracking table.
            INSERT INTO tardiness_tracking(employee_id, tardiness_date, minutes_late) 
            VALUES(v_emp_id, v_tardiness_date, v_minutes_late);
            
            -- Commit the transaction.
            COMMIT;
        END LOOP j;
    END LOOP i;
END;

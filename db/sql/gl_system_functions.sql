CREATE OR REPLACE FUNCTION 
  post_to_gl(je_number VARCHAR(255), description VARCHAR(1024), gl_period INT, accounting_date DATE, posted_by INT)
  AS $$
DECLARE
 BEGIN
   -- Verify the accounting data is within the period

 END;
$$ LANGUAGE PLPGSQL;

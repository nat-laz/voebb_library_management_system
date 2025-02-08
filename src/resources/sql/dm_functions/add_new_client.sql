CREATE OR REPLACE FUNCTION insert_client(forename TEXT, last_name TEXT, date_of_birth DATE, email TEXT, password TEXT)
RETURNS VOID AS $$
DECLARE
    v_id INT;
BEGIN

    INSERT INTO client(client_first_name, client_second_name, client_date_of_birth, client_email, client_password)
    VALUES (forename, last_name, date_of_birth, email, password)
    returning client_id INTO v_id;


    INSERT INTO client_relation (client_id)
    VALUES (v_id);

END;
$$ LANGUAGE plpgsql;
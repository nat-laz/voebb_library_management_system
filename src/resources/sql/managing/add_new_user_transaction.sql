CREATE OR REPLACE FUNCTION insert_client(forename TEXT, lastname TEXT, email TEXT)
RETURNS VOID AS $$
BEGIN
    INSERT INTO client(client_forename, client_lastname, client_email) 
		VALUES (forename, lastname, email);

		INSERT INTO 
END;
$$ LANGUAGE plpgsql;
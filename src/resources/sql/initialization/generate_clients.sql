
DO $$
    BEGIN
        FOR i IN 1..1000000 LOOP
                INSERT INTO client (
                    client_forename,
                    client_lastname,
                    client_date_of_birth,
                    client_registration_date,
                    client_membership_expiring_date,
                    client_email,
                    client_password
                )
                VALUES (
                           -- Random first name
                           'Forename_' || floor(random() * 1000)::int,

                           -- Random last name
                           'Lastname_' || floor(random() * 1000)::int,

                           -- Random birth date (between 1950-01-01 and 2000-01-01)
                           (CURRENT_DATE - (floor(random() * 18250) + 6570) * INTERVAL '1 day')::date,

                           -- Random registration date (last year)
                           (CURRENT_DATE - (floor(random() * 365) + 365) * INTERVAL '1 day')::date,

                           -- Membership expiry date (1 year after registration date)
                           ((CURRENT_DATE - (floor(random() * 365) + 365) * INTERVAL '1 day') + INTERVAL '1 year')::date,

                           -- Random email address
                           'client_' || i || '@example.com',

                           -- Random password (minimum length of 8 characters)
                           'Password_' || floor(random() * 100)::int
                       );

                INSERT INTO client_relation(client_id)
                VALUES(i);
            END LOOP;
    END $$;

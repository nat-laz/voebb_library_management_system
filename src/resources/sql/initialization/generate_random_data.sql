DO
$$
    DECLARE
        r_product RECORD;
    BEGIN -- Generating random clients
        FOR i IN 1..100000
            LOOP
                INSERT INTO client (client_forename,
                                    client_lastname,
                                    client_date_of_birth,
                                    client_registration_date,
                                    client_membership_expiring_date,
                                    client_email,
                                    client_password)
                VALUES (
                           -- Random first name
                           'Forename_' || floor(random() * 1000)::int,
                           -- Random last name
                           'Lastname_' || floor(random() * 1000)::int,
                           -- Random birth date (between 1950-01-01 and 2000-01-01)
                           (
                               CURRENT_DATE - (floor(random() * 18250) + 6570) * INTERVAL '1 day'
                               )::date,
                           -- Random registration date (last year)
                           (
                               CURRENT_DATE - (floor(random() * 365) + 365) * INTERVAL '1 day'
                               )::date,
                           -- Membership expiry date (1 year after registration date)
                           (
                               (
                                   CURRENT_DATE - (floor(random() * 365) + 365) * INTERVAL '1 day'
                                   ) + INTERVAL '1 year'
                               )::date,
                           -- Random email address
                           'client_' || i || '@example.com',
                           -- Random password (minimum length of 8 characters)
                           'Password_' || floor(random() * 100)::int);
                INSERT INTO client_relation(client_id)
                VALUES (i);
            END LOOP;
-- Generating random products
        FOR i in 1..100000
            LOOP
                INSERT INTO product(product_title,
                                    product_year,
                                    product_note,
                                    product_link_to_emedia,
                                    media_format_id)
                values (
                           -- title
                           'Product Title #' || i,
                           -- Random year (between 1950-01-01 and 2000-01-01)
                           (
                               CURRENT_DATE - (floor(random() * 18250) + 6570) * INTERVAL '1 day'
                               )::date,
                           -- Note
                           'Note for product #' || i,
                           -- media_format_id
                           floor(random() * 6 + 1)::INT)
            END LOOP;
-- Create link for ebook, duration for video and book_details for book
        FOR r_product IN (SELECT *
                          FROM product)
            LOOP
                IF r_product.media_format_id = 1 THEN
                    INSERT INTO book(product_id,
                                     book_isbn,
                                     book_pages,
                                     book_publisher)
                    VALUES (r_product.product_id,
                            'ISBN FOR BOOK ' || r_product.product_id,
                            floor(random() * (1000 - 50) + 50)::INT,
                            'Publisher #' || floor(random() * (500) + 1)::INT;
                    );
                ELSIF r_product.media_format_id = 2 THEN
                    UPDATE product
                    SET product_link_to_emedia = 'link/to/digital_media'
                    where product_id = r_product.product_id;
                    INSERT INTO book(product_id,
                                     book_isbn,
                                     book_pages,
                                     book_publisher)
                    VALUES (r_product.product_id,
                            'ISBN FOR BOOK ' || r_product.product_id,
                            floor(random() * (1000 - 50) + 50)::INT,
                            'Publisher #' || floor(random() * (500) + 1)::INT;
                    );
                ELSIF r_product.media_format_id = 3 THEN
                    INSERT INTO video(product_id,
                                      video_duration_in_minutes)
                    VALUES (r_product.product_id,
                            floor(random() * (180 - 60) + 60)::INT,);
                ELSIF r_product.media_format_id = 4 THEN
                    INSERT INTO video(product_id,
                                      video_duration_in_minutes)
                    VALUES (r_product.product_id,
                            floor(random() * (180 - 60) + 60)::INT,);
                END IF;
            END LOOP;
-- random items
        FOR i IN 1..1000000
            LOOP
                INSERT INTO product_item()
                    END LOOP;
                END
$$;
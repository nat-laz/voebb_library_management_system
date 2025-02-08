-- generate 100_000 clients
SELECT insert_client(s.client_forename,
                     s.client_lastname,
                     s.client_date_of_birth,
                     s.client_email,
                     s.client_password)
FROM (SELECT 'Forename_' || i                                                           AS client_forename,
             'Lastname_' || i                                                           AS client_lastname,
             (CURRENT_DATE - (FLOOR(RANDOM() * 18250) + 6570) * INTERVAL '1 day')::DATE AS client_date_of_birth,
             'client_' || i || '@example.com'                                           AS client_email,
             'Password_' || pg_catalog.floor(RANDOM() * 100)::INT                       AS client_password
      FROM GENERATE_SERIES(1, 100000) s(i)) AS s;

-- Generate 100_000 products
INSERT INTO product(product_title,
                    product_year,
                    product_note,
                    media_format_id)
SELECT 'Product Title #' || i,
       FLOOR(RANDOM() * (2025 - 1950) + 1) + 1950,
       'Note for product #' || i,
       FLOOR(RANDOM() * 4 + 1)::INT
FROM GENERATE_SERIES(1, 100000) s(i);

-- Fill details for books and video
DO
$$
    DECLARE
        r_product RECORD;
    BEGIN
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
                            FLOOR(RANDOM() * (1000 - 50) + 50)::INT,
                            'Publisher #' || FLOOR(RANDOM() * (500) + 1)::INT);
                ELSIF r_product.media_format_id = 2 THEN
                    UPDATE product
                    SET product_link_to_emedia = 'link/to/digital_media'
                    WHERE product_id = r_product.product_id;
                    INSERT INTO book(product_id,
                                     book_isbn,
                                     book_pages,
                                     book_publisher)
                    VALUES (r_product.product_id,
                            'ISBN FOR BOOK ' || r_product.product_id,
                            FLOOR(RANDOM() * (1000 - 50) + 50)::INT,
                            'Publisher #' || FLOOR(RANDOM() * (500) + 1)::INT);
                ELSIF r_product.media_format_id = 3 THEN
                    INSERT INTO video(product_id,
                                      video_duration_in_minutes)
                    VALUES (r_product.product_id,
                            FLOOR(RANDOM() * (180 - 60) + 60)::INT);
                ELSIF r_product.media_format_id = 4 THEN
                    INSERT INTO video(product_id,
                                      video_duration_in_minutes)
                    VALUES (r_product.product_id,
                            FLOOR(RANDOM() * (180 - 60) + 60)::INT);
                END IF;
            END LOOP;
    END
$$;

-- random items
DO
$$
    DECLARE
        product_counter INT = 1;
    BEGIN
        FOR i IN 1..1000000
            LOOP
                INSERT INTO product_item(product_id, item_status_id)
                VALUES (product_counter, 1);

-- Every time we insert 10 items, move to the next product
                IF i % 10 = 0 THEN
                    product_counter = product_counter + 1;
                END IF;
            END LOOP;
    END
$$;

-- Random library location for each item
DO
$$
    BEGIN
        FOR i IN 1..1000000
            LOOP
                INSERT INTO item_location(item_id, library_id)
                VALUES (i,
                        FLOOR(RANDOM() * 10 + 1)::INT);
            END LOOP;
    END
$$;

-- Give abo to random 70% of clients
DO
$$
    BEGIN
        FOR i IN 1..100000
            LOOP
                IF FLOOR(RANDOM() * 10 + 1) > 3 THEN
                    UPDATE client
                    SET client_membership_expiring_date = (CURRENT_DATE + INTERVAL '1 years')
                    WHERE client_id = i;

                    UPDATE client_relation
                    SET client_status = 'active'
                    WHERE client_id = i;
                END IF;
            END LOOP;
    END
$$;

-- borrow 50% of items
DO
$$
    DECLARE
        v_item_status_id INT;
    BEGIN
        FOR i IN 1..1000000 -- for each item
            LOOP
                IF FLOOR(RANDOM() * 10 + 1) > 5 THEN
                    -- check if item is not reserved and not borrowed
                    v_item_status_id := (SELECT product_item.item_status_id FROM product_item WHERE item_id = i);

                    PERFORM validate_item_status(v_item_status_id);

                    -- Borrow new item
                    INSERT INTO borrow(client_id, item_id)
                    VALUES (FLOOR(RANDOM() * (100000 - 1) + 1), i);

                    -- Change status for item
                    UPDATE product_item
                    SET item_status_id = 2
                    WHERE product_item.item_id = i;
                END IF;
            END LOOP;
    END
$$;

-- Generate creators
INSERT INTO creator(creator_forename, creator_lastname)
SELECT 'Forename' || i, 'Lastname' || i
FROM GENERATE_SERIES(1, 100000) s(i);

-- Generate creator_product_relation
DO
$$
    BEGIN
        FOR product_id_counter IN 1..100000
            LOOP
                FOR role_id_counter IN 1..FLOOR(RANDOM() * 3) + 1
                    LOOP
                        INSERT INTO creator_relation(creator_id, product_id, role_id)
                        VALUES (FLOOR(RANDOM() * 100000) + 1,
                                product_id_counter,
                                FLOOR(RANDOM() * 6) + 1);
                    END LOOP;
            END LOOP;
    END
$$;

-- Generate language_product relation
DO
$$
    BEGIN
        FOR product_id_counter IN 1..100000
            LOOP
                FOR role_id_counter IN 1..FLOOR(RANDOM() * 3) + 1
                    LOOP
                        INSERT INTO language_relation(product_id, language_id, language_type_id)
                        VALUES (product_id_counter,
                                FLOOR(RANDOM() * 52) + 1,
                                role_id_counter);
                    END LOOP;
            END LOOP;
    END
$$;
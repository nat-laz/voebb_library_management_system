INSERT INTO client (client_forename,
                    client_lastname,
                    client_date_of_birth,
                    client_registration_date,
                    client_email,
                    client_password)
SELECT 'Forename_' || i,
       'Lastname_' || i,
       (CURRENT_DATE - (floor(random() * 18250) + 6570) * INTERVAL '1 day')::date,
       (CURRENT_DATE - (floor(random() * 365 * 10) + 365 * 10) * INTERVAL '1 day')::date,
       'client_' || i || '@example.com',
       'Password_' || pg_catalog.floor(random() * 100)::int
from generate_series(1, 100000) s(i);

insert into client_relation (client_id)
select i
from generate_series(1, 100000) s(i);

INSERT INTO product(product_title,
                    product_year,
                    product_note,
                    media_format_id)
select 'Product Title #' || i,
       floor(random() * (2025 - 1950) + 1) + 1950,
       'Note for product #' || i,
       floor(random() * 4 + 1)::INT
from generate_series(1, 100000) s(i);

DO
$$
    DECLARE
        r_product record;
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
                            floor(random() * (1000 - 50) + 50)::INT,
                            'Publisher #' || floor(random() * (500) + 1)::INT);
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
                            'Publisher #' || floor(random() * (500) + 1)::INT);
                ELSIF r_product.media_format_id = 3 THEN
                    INSERT INTO video(product_id,
                                      video_duration_in_minutes)
                    VALUES (r_product.product_id,
                            floor(random() * (180 - 60) + 60)::INT);
                ELSIF r_product.media_format_id = 4 THEN
                    INSERT INTO video(product_id,
                                      video_duration_in_minutes)
                    VALUES (r_product.product_id,
                            floor(random() * (180 - 60) + 60)::INT);
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
                        floor(random() * 10 + 1)::INT);
            END LOOP;
    END
$$;

-- Give abo to random 70% of clients
DO
$$
    BEGIN
        FOR i IN 1..100000
            LOOP
                IF floor(random() * 10 + 1) > 3 THEN
                    update client
                    set client_membership_expiring_date = (current_date + INTERVAL '1 years')
                    where client_id = i;

                    update client_relation
                    set client_status = 'active'
                    where client_id = i;
                end if;
            END LOOP;
    END
$$;


-- borrow 50% of books
DO
$$
    DECLARE
        v_item_status_id INT;
    BEGIN
        FOR i IN 1..1000000 -- for each item
            LOOP
                IF floor(random() * 10 + 1) > 5 THEN
                    -- check if item is not reserved and not borrowed
                    v_item_status_id := (SELECT product_item.item_status_id FROM product_item WHERE item_id = i);

                    IF (v_item_status_id = 2) THEN
                        RAISE EXCEPTION 'Item with id % is already borrowed', i;
                    ELSIF (v_item_status_id = 3) THEN
                        RAISE EXCEPTION 'Item with id % is reserved', i;
                    END IF;

                    -- Borrow new item
                    INSERT INTO borrow(client_id, item_id)
                    VALUES (floor(random() * (100000 - 1) + 1), i);

                    -- Change status for item
                    UPDATE product_item
                    SET item_status_id = 2
                    WHERE product_item.item_id = i;
                end if;
            END LOOP;
    END
$$;


-- delete this
SELECT product.product_title,
       array_agg(fii.library_name) filter ( where fii.item_status_name = 'available' ) as available_in_libraries
FROM product
         LEFT JOIN full_item_info AS fii ON fii.product_id = product.product_id
group by product.product_id;
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

CREATE TABLE IF NOT EXISTS product
(
    product_id              SERIAL PRIMARY KEY,
    product_title           TEXT NOT NULL,
    product_year            SMALLINT CHECK (product_year BETWEEN 0 AND extract(YEAR FROM current_date)),
    media_format_id         INT  NOT NULL,
    product_link_to_emedia  TEXT,
    product_age_restriction INT,
    product_photo_link      TEXT NOT NULL DEFAULT ('default'),
    product_note            TEXT
);


CREATE TABLE IF NOT EXISTS media_format
(
    media_format_id      SERIAL PRIMARY KEY,
    media_format_name    TEXT NOT NULL,
    borrow_duration_days INT  NOT NULL CHECK (borrow_duration_days IN (14, 28))
);

CREATE TABLE IF NOT EXISTS book
(
    product_id     INT NOT NULL,
    book_isbn      TEXT,
    book_pages     INT,
    book_edition   TEXT,
    book_publisher TEXT
);

CREATE TABLE IF NOT EXISTS video
(
    product_id                INT NOT NULL UNIQUE,
    video_duration_in_minutes INT
);

CREATE TABLE IF NOT EXISTS product_item
(
    item_id        SERIAL PRIMARY KEY,
    product_id     INT NOT NULL,
    item_status_id INT NOT NULL
);

CREATE TABLE IF NOT EXISTS item_status
(
    item_status_id   SERIAL PRIMARY KEY,
    item_status_name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS language
(
    language_id   SERIAL PRIMARY KEY,
    language_name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS language_relation
(
    product_id       INT NOT NULL,
    language_id      INT NOT NULL,
    language_type_id INT NOT NULL,
    PRIMARY KEY (product_id, language_id, language_type_id)
);

CREATE TABLE IF NOT EXISTS language_type
(
    language_type_id   SERIAL PRIMARY KEY,
    language_type_name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS country
(
    country_id   SERIAL PRIMARY KEY,
    country_name TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS country_relation
(
    country_id INT NOT NULL,
    product_id INT NOT NULL,
    PRIMARY KEY (country_id, product_id)
);

CREATE TABLE IF NOT EXISTS creator
(
    creator_id       SERIAL PRIMARY KEY,
    creator_forename TEXT NOT NULL,
    creator_lastname TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS creator_relation
(
    creator_id INT NOT NULL,
    product_id INT NOT NULL,
    role_id    INT NOT NULL,
    PRIMARY KEY (product_id, creator_id, role_id)
);

CREATE TABLE IF NOT EXISTS creator_role
(
    role_id   SERIAL PRIMARY KEY,
    role_name TEXT NOT NULL
);


CREATE TABLE IF NOT EXISTS library
(
    library_id          SERIAL PRIMARY KEY,
    library_name        TEXT NOT NULL,
    library_description TEXT
);

CREATE TABLE IF NOT EXISTS item_location
(
    item_id             INT NOT NULL,
    library_id          INT NOT NULL,
    location_in_library TEXT
);

CREATE TABLE IF NOT EXISTS library_address
(
    library_id   INT  NOT NULL,
    city         TEXT NOT NULL,
    street       TEXT NOT NULL,
    house_number INT  NOT NULL,
    osm_link     TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS client
(
    client_id                       SERIAL PRIMARY KEY,
    client_forename                 TEXT        NOT NULL,
    client_lastname                 TEXT        NOT NULL,
    client_date_of_birth            DATE        NOT NULL,
    client_registration_date        DATE        NOT NULL, -- 1 year
    client_membership_expiring_date DATE,
    client_email                    TEXT UNIQUE NOT NULL CHECK (client_email ~* '^[A-Za-z0-9._+%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$'),
    client_password                 TEXT        NOT NULL CHECK (length(client_password) > 8)
);

CREATE TYPE client_status AS ENUM ('active', 'inactive', 'warning', 'banned');

CREATE TABLE IF NOT EXISTS client_relation
(
    client_id             INT UNIQUE    NOT NULL,
    client_status         client_status NOT NULL DEFAULT 'inactive',
    borrowed_items_amount INT CHECK (borrowed_items_amount <= 5 AND borrowed_items_amount >= 0), -- update after each borrow
    penalty_balance       DECIMAL(10, 2)
);

CREATE TABLE IF NOT EXISTS borrow
(
    client_id          INT  NOT NULL,
    item_id            INT  NOT NULL,
    borrow_start_date  DATE NOT NULL DEFAULT CURRENT_DATE,
    borrow_due_date    DATE NOT NULL, -- set update based on how many days the item can be borrowed; update if user extends
    borrow_return_date DATE,
    borrow_extends     INT           DEFAULT 0 CHECK ( borrow_extends >= 0 AND borrow_extends <= 3),
    PRIMARY KEY (client_id, item_id, borrow_start_date)
);



CREATE TABLE IF NOT EXISTS reservation
(
    client_id              INT  NOT NULL,
    item_id                INT  NOT NULL,
    reservation_start_date DATE NOT NULL DEFAULT CURRENT_DATE,
    reservation_due_date   DATE NOT NULL DEFAULT CURRENT_DATE + INTERVAL '3 days',
    PRIMARY KEY (client_id, item_id, reservation_start_date)
);

CREATE VIEW full_item_info AS
SELECT product_item.item_id,
       product.product_id,
       product_title,
       item_status_name,
       library.library_id,
       library_name,
       location_in_library,
       library_address.city,
       library_address.street,
       library_address.house_number

FROM product_item
         JOIN product ON product.product_id = product_item.product_id
         JOIN item_status ON product_item.item_status_id = item_status.item_status_id
         JOIN item_location ON product_item.item_id = item_location.item_id
         JOIN library ON item_location.library_id = library.library_id
         JOIN library_address ON library.library_id = library_address.library_id;


CREATE OR REPLACE VIEW main_page_info AS
SELECT product.product_id,
       -- check if product is_physical
       CASE
           WHEN product.product_link_to_emedia IS NOT NULL THEN TRUE -- set digital products always available
           ELSE
               CASE
                   WHEN EXISTS (SELECT 1
                                FROM full_item_info
                                WHERE full_item_info.product_id = product.product_id
                                  AND full_item_info.item_status_name = 'available') THEN TRUE
                   ELSE FALSE
                   END
           END  AS avaliable,
       media_format_name,
       product.product_title,
       product.product_year,
       product.product_photo_link,
       array_agg(case
                     when fii.item_status_name = 'available' -- available
                         then fii.library_name
           end) as available_in_libraries
FROM product
         LEFT JOIN media_format ON media_format.media_format_id = product.media_format_id
         LEFT JOIN full_item_info AS fii ON fii.product_id = product.product_id
group by product.product_id, product.product_title,
         product.product_year,
         product.product_photo_link,
         media_format_name;



ALTER TABLE product
    ADD FOREIGN KEY (media_format_id) REFERENCES media_format (media_format_id);

ALTER TABLE book
    ADD FOREIGN KEY (product_id) REFERENCES product (product_id);

ALTER TABLE video
    ADD FOREIGN KEY (product_id) REFERENCES product (product_id);

ALTER TABLE product_item
    ADD FOREIGN KEY (product_id) REFERENCES product (product_id);

ALTER TABLE product_item
    ADD FOREIGN KEY (item_status_id) REFERENCES item_status (item_status_id);

ALTER TABLE language_relation
    ADD FOREIGN KEY (product_id) REFERENCES product (product_id);

ALTER TABLE language_relation
    ADD FOREIGN KEY (language_id) REFERENCES language (language_id);

ALTER TABLE language_relation
    ADD FOREIGN KEY (language_type_id) REFERENCES language_type (language_type_id);

ALTER TABLE country_relation
    ADD FOREIGN KEY (product_id) REFERENCES product (product_id);

ALTER TABLE country_relation
    ADD FOREIGN KEY (country_id) REFERENCES country (country_id);

ALTER TABLE creator_relation
    ADD FOREIGN KEY (product_id) REFERENCES product (product_id);

ALTER TABLE creator_relation
    ADD FOREIGN KEY (creator_id) REFERENCES creator (creator_id);

ALTER TABLE creator_relation
    ADD FOREIGN KEY (role_id) REFERENCES creator_role (role_id);

ALTER TABLE item_location
    ADD FOREIGN KEY (item_id) REFERENCES product_item (item_id);

ALTER TABLE item_location
    ADD FOREIGN KEY (library_id) REFERENCES library (library_id);

ALTER TABLE library_address
    ADD FOREIGN KEY (library_id) REFERENCES library (library_id);

ALTER TABLE client_relation
    ADD FOREIGN KEY (client_id) REFERENCES client (client_id);

ALTER TABLE reservation
    ADD FOREIGN KEY (client_id) REFERENCES client_relation (client_id);

ALTER TABLE reservation
    ADD FOREIGN KEY (item_id) REFERENCES product_item (item_id);

ALTER TABLE borrow
    ADD FOREIGN KEY (item_id) REFERENCES product_item (item_id);

ALTER TABLE borrow
    ADD FOREIGN KEY (client_id) REFERENCES client_relation (client_id);



-------------------- EXTENSIONS: --------------------

-- pg_trgm - support for similarity of text using trigram matching
CREATE EXTENSION IF NOT EXISTS pg_trgm;


-------------------- INDEXES: --------------------
-- GIN Index for full-search and similarity on product title, notes
CREATE INDEX idx_gin_product_search
    ON product
        USING GIN (
                   product_title gin_trgm_ops,
                   product_note gin_trgm_ops
            );

-- GIN Index for full-search on creator names
CREATE INDEX idx_gin_creator_search
    ON creator
        USING GIN (
                   creator_forename gin_trgm_ops,
                   creator_lastname gin_trgm_ops
            );

-- PARTIAL Index: improves performance when checking if the product is physical or not
CREATE INDEX idx_product_link_to_emedia_not_null
    ON product (product_link_to_emedia)
    WHERE product_link_to_emedia IS NOT NULL;


-------------------- UTILS: --------------------

-- VALIDATION IN BORROW AND RESERVE TRANSACTIONS
CREATE OR REPLACE FUNCTION validate_item_and_client_ids(v_item_id INT, v_client_id INT)
    RETURNS VOID AS
$$
BEGIN
    IF v_item_id IS NULL THEN
        RAISE EXCEPTION 'Item ID cannot be null';
    END IF;

    IF v_client_id IS NULL THEN
        RAISE EXCEPTION 'Client ID cannot be null';
    END IF;
END;
$$ LANGUAGE plpgsql;

-- check if item is not reserved and not borrowed
CREATE OR REPLACE FUNCTION validate_item_status(v_item_id INT)
    RETURNS VOID AS
$$
DECLARE
    v_item_status_id INT;
BEGIN

    v_item_status_id := (SELECT product_item.item_status_id
                         FROM product_item
                         WHERE item_id = v_item_id);

    IF v_item_status_id = 2 THEN
        RAISE EXCEPTION 'Item with id % is already borrowed', v_item_id;
    ELSIF v_item_status_id = 3 THEN
        RAISE EXCEPTION 'Item with id % is reserved', v_item_id;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- check if product is physical and exists in specific library
CREATE OR REPLACE FUNCTION validate_item_location(v_item_id INT, v_library_id INT, v_context TEXT)
    RETURNS VOID AS
$$
DECLARE
    v_is_physical   BOOLEAN;
    v_valid_library BOOLEAN;
BEGIN
    -- check if the item is physical or digital
    v_is_physical := NOT EXISTS (SELECT 1
                                 FROM product
                                 WHERE product_id = (SELECT product_id
                                                     FROM product_item
                                                     WHERE item_id = v_item_id)
                                   AND product_link_to_emedia IS NOT NULL);

    -- exception for attempt to reserve digital product
    IF v_context = 'reservation' AND NOT v_is_physical THEN
        RAISE EXCEPTION 'This item % can be borrowed immediately.', v_item_id;
    END IF;

    -- skip validation for digital products during borrowing transaction
    IF NOT v_is_physical THEN
        RETURN;
    END IF;


    -- validate relationship between library_id <=> item_id
    v_valid_library := EXISTS (SELECT 1
                               FROM item_location
                               WHERE item_id = v_item_id
                                 AND library_id = v_library_id);

    -- exception if the library_id is invalid
    IF NOT v_valid_library THEN
        RAISE EXCEPTION 'Library with id % does not contain item with id %', v_library_id, v_item_id;
    END IF;

END;
$$ LANGUAGE plpgsql;

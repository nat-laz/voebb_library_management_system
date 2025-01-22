DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

CREATE TABLE IF NOT EXISTS product
(
    product_id              SERIAL PRIMARY KEY,
    product_title           TEXT NOT NULL,
    product_year            smallint check (product_year between 0 and extract(year from current_date)),
    media_format_id         INT  NOT NULL,
    product_link_to_emedia  TEXT,
    product_age_restriction INT,
    product_photo_link      TEXT NOT NULL DEFAULT ('default'),
    product_note            TEXT
);

CREATE TABLE IF NOT EXISTS media_format
(
    media_format_id      SERIAL PRIMARY KEY,
    media_format_name    TEXT                 NOT NULL,
    borrow_duration_days INT NOT NULL CHECK (borrow_duration_days IN (14, 28))
);

CREATE TABLE IF NOT EXISTS book
(
    product_id INT NOT NULL,
    book_isbn    TEXT,
    book_pages   INT,
    book_edition TEXT,
    book_publisher TEXT
);

CREATE TABLE IF NOT EXISTS video
(
    product_id INT NOT NULL UNIQUE,
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
    language_type_id int NOT NULL,
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
    city         text NOT NULL,
    street       text NOT NULL,
    house_number INT  NOT NULL,
    osm_link     text NOT NULL
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
    client_id         INT  NOT NULL,
    item_id           INT  NOT NULL,
    borrow_start_date DATE NOT NULL DEFAULT CURRENT_DATE,
    borrow_due_date   DATE NOT NULL, -- set update based on how many days the item can be borrowed; update if user extends
    borrow_return_date       DATE,
    borrow_extends           INT           DEFAULT 0 CHECK ( borrow_extends >= 0 AND borrow_extends <= 3),
    PRIMARY KEY (client_id, item_id)
);


CREATE TABLE IF NOT EXISTS reservation
(
    client_id              INT  NOT NULL,
    item_id                INT  NOT NULL,
    reservation_start_date DATE NOT NULL DEFAULT CURRENT_DATE,
    reservation_due_date   DATE NOT NULL,
    PRIMARY KEY (client_id, item_id)
);

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
INSERT INTO creator (creator_forename, creator_lastname)
VALUES ('J.K.', 'Rowling'),
       ('George', 'Orwell'),
       ('Jane', 'Austen'),
       ('Mark', 'Twain'),
       ('Harper', 'Lee'),
       ('J.R.R.', 'Tolkien'),
       ('F. Scott', 'Fitzgerald'),
       ('Charles', 'Dickens'),
       ('Ernest', 'Hemingway'),
       ('Virginia', 'Woolf'),
       ('Joshua', 'Bloch'),     -- Author of Effective Java
       ('Herbert', 'Schildt'),  -- Author of Java: The Complete Reference
       ('Kathy', 'Sierra'),     -- Co-author of Head First Java
       ('Bert', 'Bates'),       -- Co-author of Head First Java
       ('Brian', 'Goetz'),      -- Author of Java Concurrency in Practice
       ('Cay S.', 'Horstmann'), -- Co-author of Core Java Volume I: Fundamentals
       ('Gary', 'Cornell'); -- Co-author of Core Java Volume I: Fundamentals
;

INSERT INTO product (product_title, product_year, media_format_id, product_link_to_emedia, product_note)
VALUES ('Harry Potter and the Philosopher Stone', 1997, 1, NULL, NULL), -- J.K. Rowling
       ('1984', 1949, 1, NULL, NULL),                                   -- George Orwell
       ('Pride and Prejudice', 1813, 1, NULL, NULL),                    -- Jane Austen
       ('The Adventures of Tom Sawyer', 1876, 1, NULL, NULL),           -- Mark Twain
       ('To Kill a Mockingbird', 1960, 1, NULL, NULL),                  -- Harper Lee
       ('The Hobbit', 1937, 1, NULL, NULL),                             -- J.R.R. Tolkien
       ('The Great Gatsby', 1925, 1, NULL, NULL),                       -- F. Scott Fitzgerald
       ('A Tale of Two Cities', 1859, 1, NULL, NULL),                   -- Charles Dickens
       ('The Old Man and the Sea', 1952, 1, NULL, NULL),                -- Ernest Hemingway
       ('Mrs Dalloway', 1925, 1, NULL, NULL),                           -- Virginia Woolf
       ('1984', 1949, 2, 'direct link to e-media', NULL),               -- George Orwell (e-book)
       ('Effective Java', 2018, 1, NULL, 'Book edition by Joshua Bloch'),
       ('Java: The Complete Reference', 2021, 2, 'https://example.com/java-complete-reference',
        'E-book edition by Herbert Schildt'),
       ('Head First Java', 2022, 3, 'https://example.com/java-tutorial',
        'Video tutorial based on the book by Kathy Sierra and Bert Bates'),
       ('Java Concurrency in Practice', 2006, 1, NULL, 'Book edition by Brian Goetz'),
       ('Core Java Volume I: Fundamentals', 2020, 2, 'https://example.com/core-java-fundamentals',
        'E-book edition by Cay S. Horstmann and Gary Cornell');

INSERT INTO book (product_id, book_pages)
VALUES (1, 223),  -- J.K. Rowling
       (2, 328),  -- George Orwell
       (3, 279),  -- Jane Austen
       (4, 274),  -- Mark Twain
       (5, 281),  -- Harper Lee
       (6, 310),  -- J.R.R. Tolkien
       (7, 218),  -- F. Scott Fitzgerald
       (8, 489),  -- Charles Dickens
       (9, 127),  -- Ernest Hemingway
       (10, 194), -- Virginia Woolf
       (11, 328); -- George Orwell

INSERT INTO video(product_id, video_duration_in_minutes)
VALUES (14, 125); -- Video tutorial based on the book by Kathy Sierra and Bert Bates

INSERT INTO creator_relation(creator_id, product_id, role_id)
VALUES (1, 1, 2),
       (2, 2, 2),
       (3, 3, 2),
       (4, 4, 2),
       (5, 5, 2),
       (6, 6, 2),
       (7, 7, 2),
       (8, 8, 2),
       (9, 9, 2),
       (10, 10, 2),
       (2, 11, 2),
       (11, 12, 2), -- Joshua Bloch, Author of Effective Java
       (12, 13, 2), -- Herbert Schildt, Author of Java: The Complete Reference
       (13, 14, 6), -- Kathy Sierra, Co-Author of Head First Java
       (14, 14, 6), -- Bert Bates, Co-Author of Head First Java
       (15, 15, 2), -- Brian Goetz, Author of Java Concurrency in Practice
       (16, 16, 6), -- Cay S. Horstmann, Co-Author of Core Java Volume I: Fundamentals
       (17, 16, 6); -- Gary Cornell, Co-Author of Core Java Volume I: Fundamentals
;

INSERT INTO language_relation(product_id, language_id, language_type_id)
VALUES (1, 1, 1),
       (2, 1, 1),
       (3, 1, 1),
       (4, 1, 1),
       (5, 1, 1),
       (6, 1, 1),
       (7, 1, 1),
       (8, 1, 1),
       (9, 1, 1),
       (10, 1, 1),
       (11, 1, 2),
       (12, 1, 1),  -- English Original (Effective Java)
       (13, 1, 1),  -- English Original (Java: The Complete Reference)
       (14, 12, 2), -- German Translation (Head First Java, translated into German)
       (15, 1, 1),  -- English Original (Java Concurrency in Practice)
       (16, 12, 2); -- German Translation (Core Java Volume I: Fundamentals, translated into German)

INSERT INTO item_status (item_status_name)
VALUES ('available'),
       ('borrowed'),
       ('reserved');

INSERT INTO product_item (product_id, item_status_id)
VALUES (1, 1),
       (1, 1),
       (1, 1),
       (1, 1),
       (1, 1),
       (1, 1),
       (1, 1),
       (1, 1),
       (1, 1),
       (1, 1),

       (2, 1),
       (2, 1),
       (2, 1),
       (2, 1),
       (2, 1),
       (2, 1),
       (2, 1),
       (2, 1),

       (3, 1),
       (3, 1),
       (3, 1),
       (3, 1),
       (3, 1),
       (3, 1),
       (3, 1),

       (4, 1),
       (4, 1),
       (4, 1),
       (4, 1),
       (4, 1),
       (4, 1),

       (5, 1),
       (5, 1),
       (5, 1),
       (5, 1),
       (5, 1),

       (6, 1),
       (6, 1),
       (6, 1),
       (6, 1),

       (7, 1),
       (7, 1),
       (7, 1),

       (8, 1),
       (8, 1),

       (9, 1),

       (10, 1),

       (11, 1),

       (12, 1),
       (12, 1),
       (12, 1),

       (15, 1),
       (15, 1),
       (15, 1);


INSERT INTO item_location (item_id, library_id)
VALUES (1, 3),
       (2, 1),
       (3, 4),
       (4, 2),
       (5, 5),
       (6, 3),
       (7, 1),
       (8, 2),
       (9, 5),
       (10, 4),
       (11, 2),
       (12, 3),
       (13, 1),
       (14, 5),
       (15, 4),
       (16, 2),
       (17, 3),
       (18, 5),
       (19, 1),
       (20, 4),
       (21, 2),
       (22, 5),
       (23, 3),
       (24, 1),
       (25, 4),
       (26, 2),
       (27, 5),
       (28, 3),
       (29, 1),
       (30, 4),
       (31, 2),
       (32, 5),
       (33, 1),
       (34, 3),
       (35, 4),
       (36, 2),
       (37, 5),
       (38, 1),
       (39, 3),
       (40, 4),
       (41, 5),
       (42, 2),
       (43, 3),
       (44, 1),
       (45, 4),
       (49, 3),
       (50, 1),
       (51, 4),
       (52, 2),
       (53, 5),
       (54, 1);

INSERT INTO country_relation (country_id, product_id)
VALUES
-- Harry Potter and the Philosopher Stone
((SELECT country_id FROM country WHERE country_name = 'United Kingdom'), 1),
-- 1984
((SELECT country_id FROM country WHERE country_name = 'United Kingdom'), 2),
((SELECT country_id FROM country WHERE country_name = 'United Kingdom'), 11), -- e-book version
-- Pride and Prejudice
((SELECT country_id FROM country WHERE country_name = 'United Kingdom'), 3),
-- The Adventures of Tom Sawyer
((SELECT country_id FROM country WHERE country_name = 'United States of America'), 4),
-- To Kill a Mockingbird
((SELECT country_id FROM country WHERE country_name = 'United States of America'), 5),
-- The Hobbit
((SELECT country_id FROM country WHERE country_name = 'United Kingdom'), 6),
-- The Great Gatsby
((SELECT country_id FROM country WHERE country_name = 'United States of America'), 7),
-- A Tale of Two Cities
((SELECT country_id FROM country WHERE country_name = 'United Kingdom'), 8),
((SELECT country_id FROM country WHERE country_name = 'France'), 8),
-- The Old Man and the Sea
((SELECT country_id FROM country WHERE country_name = 'United States of America'), 9),
-- Mrs Dalloway
((SELECT country_id FROM country WHERE country_name = 'United Kingdom'), 10),
(185, 12),
(185, 13),
(63, 14),
(185, 15),
(63, 16);

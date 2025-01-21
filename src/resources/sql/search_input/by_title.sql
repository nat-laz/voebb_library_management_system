INSERT INTO product (product_title, product_year, media_format_id, product_link_to_emedia, product_note)
VALUES ('Effective Java', 2018, 1, NULL, 'Book edition by Joshua Bloch'),
       ('Java: The Complete Reference', 2021, 2, 'https://example.com/java-complete-reference',
        'E-book edition by Herbert Schildt'),
       ('Head First Java', 2022, 3, 'https://example.com/java-tutorial',
        'Video tutorial based on the book by Kathy Sierra and Bert Bates'),
       ('Java Concurrency in Practice', 2006, 1, NULL, 'Book edition by Brian Goetz'),
       ('Core Java Volume I: Fundamentals', 2020, 2, 'https://example.com/core-java-fundamentals',
        'E-book edition by Cay S. Horstmann and Gary Cornell');

INSERT INTO language_relation (product_id, language_id, language_type_id)
VALUES (12, 1, 1),  -- English Original (Effective Java)
       (13, 1, 1),  -- English Original (Java: The Complete Reference)
       (14, 12, 2), -- German Translation (Head First Java, translated into German)
       (15, 1, 1),  -- English Original (Java Concurrency in Practice)
       (16, 12, 2); -- German Translation (Core Java Volume I: Fundamentals, translated into German)

INSERT INTO creator_relation (creator_id, product_id, role_id)
VALUES (11, 12, 2), -- Joshua Bloch, Author of Effective Java
       (12, 13, 2), -- Herbert Schildt, Author of Java: The Complete Reference
       (13, 14, 6), -- Kathy Sierra, Co-Author of Head First Java
       (14, 14, 6), -- Bert Bates, Co-Author of Head First Java
       (15, 15, 2), -- Brian Goetz, Author of Java Concurrency in Practice
       (16, 16, 6), -- Cay S. Horstmann, Co-Author of Core Java Volume I: Fundamentals
       (17, 16, 6); -- Gary Cornell, Co-Author of Core Java Volume I: Fundamentals

INSERT INTO country_relation(country_id, product_id)
VALUES (185, 12),
       (185, 13),
       (63, 14),
       (185, 15),
       (63, 16);

INSERT INTO product_item (product_id, item_status_id)
VALUES (12, 1),
       (12, 1),
       (12, 1),

       (15, 1),
       (15, 1),
       (15, 1);

INSERT INTO item_location (item_id, library_id)
VALUES (49, 3),
       (50, 1),
       (51, 4),
       (52, 2),
       (53, 5),
       (54, 1);



SELECT DISTINCT product.product_id,
                product.product_title                                               as title,
                concat(creator.creator_forename || ' ' || creator.creator_lastname) as creator_full_name,
                media_format.media_format_name                                      as format,
                product.product_link_to_emedia                                      as link,
                product.product_year                                                as year,
                country.country_name                                                as publication_country,
                language.language_name                                              as language,
                array_agg(CASE
                              WHEN item_status.item_status_id = 1 -- available
                                  THEN library.library_name
                    END)                                                            as available_in_libraries

FROM product
         LEFT JOIN creator_relation ON creator_relation.product_id = product.product_id
         LEFT JOIN creator ON creator.creator_id = creator_relation.creator_id
         LEFT JOIN media_format ON product.media_format_id = media_format.media_format_id
         LEFT JOIN product_item ON product_item.product_id = product.product_id
         LEFT JOIN item_status ON item_status.item_status_id = product_item.item_status_id
         LEFT JOIN item_location ON item_location.item_id = product_item.item_id
         LEFT JOIN library ON item_location.library_id = library.library_id
         LEFT JOIN language_relation ON product.product_id = language_relation.product_id
         LEFT JOIN language ON language_relation.language_id = language.language_id
         LEFT JOIN language_type ON language_relation.language_type_id = language_type.language_type_id
         LEFT JOIN country_relation ON product.product_id = country_relation.product_id
         LEFT JOIN country ON country_relation.country_id = country.country_id
WHERE product.product_title ILIKE '%' || :user_input || '%'
GROUP BY product.product_year, product.product_title, product.product_link_to_emedia, product.media_format_id,
         creator.creator_lastname, creator.creator_forename, media_format.media_format_id, country.country_name,
         language.language_name, product.product_id;

-- Fix: if 2 co-authors appear 2 times

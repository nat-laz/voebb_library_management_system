CREATE VIEW full_product_info AS
SELECT DISTINCT product.product_title                                               as title,
                concat(creator.creator_forename || ' ' || creator.creator_lastname) as creator_full_name,
                media_format.media_format_name                                      as format,
                product.product_link_to_emedia                                      as link,
                product.product_year                                                as year,
                array_agg(CASE
                              WHEN item_status.item_status_id = 1 -- available
                                  THEN library.library_name
                    END)                                                            as available_in_libraries
FROM product
         JOIN creator_relation ON creator_relation.product_id = product.product_id
         JOIN creator ON creator.creator_id = creator_relation.creator_id
         JOIN media_format ON product.media_format_id = media_format.media_format_id
         LEFT JOIN product_item ON product_item.product_id = product.product_id
         LEFT JOIN item_status ON item_status.item_status_id = product_item.item_status_id
         LEFT JOIN item_location ON item_location.item_id = product_item.item_id
         LEFT JOIN library ON item_location.library_id = library.library_id
GROUP BY product.product_year, product.product_title, product.product_link_to_emedia, product.media_format_id,
         creator.creator_lastname, creator.creator_forename, media_format.media_format_id;

-- EXPLAIN ANALYZE SELECT *
-- from full_product_info
-- WHERE creator_full_name ILIKE '%' || ? || '%';


CREATE VIEW full_product_info_new AS
SELECT DISTINCT product.product_title                                                                  as title,
                STRING_AGG(DISTINCT creator.creator_forename || ' ' || creator.creator_lastname,
                           ', ')                                                                       AS creator_full_name,
                media_format.media_format_name                                                         as format,
                product.product_link_to_emedia                                                         as link,
                product.product_year                                                                   as year,
                array_agg(CASE
                              WHEN item_status.item_status_id = 1 -- available
                                  THEN library.library_name
                    END)                                                                               as available_in_libraries
FROM product
         JOIN creator_relation ON creator_relation.product_id = product.product_id
         JOIN creator ON creator.creator_id = creator_relation.creator_id
         JOIN media_format ON product.media_format_id = media_format.media_format_id
         LEFT JOIN product_item ON product_item.product_id = product.product_id
         LEFT JOIN item_status ON item_status.item_status_id = product_item.item_status_id
         LEFT JOIN item_location ON item_location.item_id = product_item.item_id
         LEFT JOIN library ON item_location.library_id = library.library_id
GROUP BY product.product_year, product.product_title, product.product_link_to_emedia, product.media_format_id,
         creator.creator_lastname, creator.creator_forename, media_format.media_format_id;

SELECT *
FROM full_product_info_new
WHERE exists (SELECT 1
              FROM unnest(string_to_array(creator_full_name, ', ')) AS individual_creator
              WHERE individual_creator ILIKE '%' || ? || '%');

-- RETURN OF GENERIC SEARCH
CREATE OR REPLACE VIEW comprehensive_product_view AS
SELECT p.product_id,
       p.product_title      AS title,
       c.creator_forename,
       c.creator_lastname,
       mf.media_format_name AS format,
       p.product_note       AS notes
FROM product p
         JOIN creator_relation cr ON cr.product_id = p.product_id
         JOIN creator c ON c.creator_id = cr.creator_id
         JOIN media_format mf ON mf.media_format_id = p.media_format_id;

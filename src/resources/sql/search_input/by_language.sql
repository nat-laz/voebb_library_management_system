SELECT product.product_title,
       STRING_AGG(DISTINCT creator.creator_forename || ' ' || creator.creator_lastname, ', ') AS creator_full_name,
       product.product_year,
       media_format.media_format_name,
       language.language_name,
       array_agg(CASE
                     WHEN item_status.item_status_id = 1 -- available
                         THEN library.library_name
           END)                                                                               as available_in_libraries
FROM product
         JOIN language_relation ON product.product_id = language_relation.product_id
         JOIN language ON language_relation.language_id = language.language_id
         LEFT JOIN creator_relation ON creator_relation.product_id = product.product_id
         LEFT JOIN creator ON creator.creator_id = creator_relation.creator_id
         LEFT JOIN media_format ON product.media_format_id = media_format.media_format_id
         LEFT JOIN product_item ON product_item.product_id = product.product_id
         LEFT JOIN item_status ON item_status.item_status_id = product_item.item_status_id
         LEFT JOIN item_location ON item_location.item_id = product_item.item_id
         LEFT JOIN library ON item_location.library_id = library.library_id
WHERE language.language_name ILIKE ?
GROUP BY product.product_title, product.product_year, language.language_name, media_format.media_format_name;
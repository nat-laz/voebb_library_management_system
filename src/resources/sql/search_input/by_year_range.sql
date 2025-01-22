SELECT product.product_title,
       STRING_AGG(DISTINCT creator.creator_forename || ' ' || creator.creator_lastname, ', ') AS creator_full_name,
       product.product_year,
       media_format.media_format_name,
       array_agg(CASE
                     WHEN item_status.item_status_id = 1 -- available
                         THEN library.library_name
           END)                                                                               as available_in_libraries
FROM product
         LEFT JOIN creator_relation ON creator_relation.product_id = product.product_id
         LEFT JOIN creator ON creator.creator_id = creator_relation.creator_id
         LEFT JOIN media_format ON product.media_format_id = media_format.media_format_id
         LEFT JOIN product_item ON product_item.product_id = product.product_id
         LEFT JOIN item_status ON item_status.item_status_id = product_item.item_status_id
         LEFT JOIN item_location ON item_location.item_id = product_item.item_id
         LEFT JOIN library ON item_location.library_id = library.library_id
         LEFT JOIN country_relation ON product.product_id = country_relation.product_id
         LEFT JOIN country ON country_relation.country_id = country.country_id
WHERE product_year BETWEEN ? AND ?
group by product.product_title,
         product.product_year,
         media_format.media_format_name;
SELECT avaliable,
       media_format_name,
       product_title,
       CONCAT(creator.creator_forename || ' ' || creator.creator_lastname) AS creator_full_name,
       product_year,
       product_photo_link,
       available_in_libraries
FROM main_page_info
         LEFT JOIN creator_relation ON creator_relation.product_id = main_page_info.product_id
         LEFT JOIN creator ON creator.creator_id = creator_relation.creator_id
         LEFT JOIN creator_role ON creator.creator_id = creator_role.role_id
WHERE creator_forename ILIKE '%' || ? || '%'
   OR creator_lastname ILIKE '%' || ? || '%'
LIMIT 22 OFFSET 0;
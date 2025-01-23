SELECT avaliable,
       media_format_name,
       product_title,
       product_year,
       product_photo_link,
       available_in_libraries
FROM main_page_info
         LEFT JOIN creator_relation ON creator_relation.product_id = main_page_info.product_id
         LEFT JOIN creator ON creator.creator_id = creator_relation.creator_id
         LEFT JOIN creator_role ON creator.creator_id = creator_role.role_id
WHERE creator_lastname ILIKE '%' || ? || '%'
   OR creator_forename ILIKE '%' || ? || '%'
LIMIT 22 OFFSET 0;
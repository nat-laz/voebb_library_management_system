SELECT avaliable,
       media_format_name,
       product_title,
       product_year,
       product_photo_link,
       available_in_libraries
FROM main_page_info
         LEFT JOIN language_relation ON language_relation.product_id = main_page_info.product_id
         LEFT JOIN language ON language_relation.language_id = language.language_id
         LEFT JOIN language_type ON language_relation.language_type_id = language_type.language_type_id
WHERE language.language_name ILIKE ?
LIMIT 22 OFFSET 0;
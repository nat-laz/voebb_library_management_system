SELECT product.product_title                                               as title,
       product.product_year                                                as publication_year,
       media_format.media_format_name                                      as media_format,
       concat(creator.creator_forename || ' ' || creator.creator_lastname) as creator_full_name,
       country.country_name                                                as publication_country,
       language.language_name                                              as language
FROM product
         LEFT JOIN media_format ON product.media_format_id = media_format.media_format_id
         LEFT JOIN creator_relation ON creator_relation.product_id = product.product_id
         LEFT JOIN creator ON creator_relation.creator_id = creator.creator_id
         LEFT JOIN creator_role ON creator_relation.role_id = creator_role.role_id
         LEFT JOIN language_relation ON product.product_id = language_relation.product_id
         LEFT JOIN language ON language_relation.language_id = language.language_id
         LEFT JOIN language_type ON language_relation.language_type_id = language_type.language_type_id
         LEFT JOIN country_relation ON product.product_id = country_relation.product_id
         LEFT JOIN country ON country_relation.country_id = country.country_id
         LEFT JOIN book ON product.product_id = book.product_id
         LEFT JOIN video ON product.product_id = video.product_id
WHERE product.product_id = 12;


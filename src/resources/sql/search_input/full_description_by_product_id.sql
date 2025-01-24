-- I think only way to load all info about product properly is to move logic of joining table by media_type to the backend
SELECT media_format_name,
       product_title,
       product_year,
       array_agg(DISTINCT CONCAT(language_type_name, ':', language_name))                                   as languages,
       array_agg(DISTINCT CONCAT(role_name, ':', CONCAT(creator_forename, ' ', creator_lastname))) as creators,
       product_photo_link,
       available_in_libraries,
       book_isbn,                -- Meh
       book_pages,               -- Meh
       book_edition,             -- Meh
       video_duration_in_minutes -- Meh

FROM main_page_info AS mpi
         LEFT JOIN language_relation ON language_relation.product_id = mpi.product_id
         LEFT JOIN language ON language_relation.language_id = language.language_id
         LEFT JOIN language_type ON language_relation.language_type_id = language_type.language_type_id
         LEFT JOIN creator_relation ON creator_relation.product_id = mpi.product_id
         LEFT JOIN creator ON creator.creator_id = creator_relation.creator_id
         LEFT JOIN creator_role ON creator_relation.role_id = creator_role.role_id
         LEFT JOIN book on mpi.product_id = book.product_id     -- Meh
         LEFT JOIN video on mpi.product_id = video.product_id   -- Meh
--WHERE mpi.product_id = ?
WHERE product_title ilike '%' || ?
group by media_format_name, product_title, product_year, product_photo_link, available_in_libraries, mpi.product_id,
         book.book_isbn, book.book_pages, book.book_edition, video.video_duration_in_minutes;
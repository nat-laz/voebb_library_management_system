-- debug
DROP FUNCTION IF EXISTS search_across_metadata(text);

-- function
CREATE OR REPLACE FUNCTION search_across_metadata(search_term TEXT)
    RETURNS TABLE
            (
                title                  TEXT,
                creator_forename       TEXT,
                creator_lastname       TEXT,
                avaliable              BOOLEAN,
                format                 TEXT,
                year                   SMALLINT,
                product_link_to_emedia TEXT,
                available_in_libraries TEXT,
                description            TEXT
            )
AS
$$
BEGIN
    RETURN QUERY
        SELECT mpi.product_title                                 AS title,
               c.creator_forename,
               c.creator_lastname,
               mpi.avaliable,
               mpi.media_format_name                             AS format,
               mpi.product_year                                  AS year,
               mpi.product_link_to_emedia,
               array_to_string(mpi.available_in_libraries, ', ') AS available_in_libraries,
               mpi.product_note                                  AS description
        FROM main_page_info mpi
                 LEFT JOIN creator_relation cr ON cr.product_id = mpi.product_id
                 LEFT JOIN creator c ON c.creator_id = cr.creator_id
        WHERE mpi.product_title % search_term
           OR mpi.product_note % search_term
           OR c.creator_forename % search_term
           OR c.creator_lastname % search_term
           OR mpi.product_title ILIKE '%' || search_term || '%'
           OR mpi.product_note ILIKE '%' || search_term || '%'
           OR c.creator_forename ILIKE '%' || search_term || '%'
           OR c.creator_lastname ILIKE '%' || search_term || '%'
        ORDER BY GREATEST(
                         similarity(lower(mpi.product_title), lower(search_term)),
                         similarity(lower(mpi.product_note), lower(search_term)),
                         similarity(lower(c.creator_forename), lower(search_term)),
                         similarity(lower(c.creator_lastname), lower(search_term))
                 ) DESC
        LIMIT 100;
END;
$$ LANGUAGE plpgsql;


-- TEST QUERY
SELECT *
FROM search_across_metadata(:search_term);

-- ANALYSE PERFORMANCE
EXPLAIN ANALYSE
SELECT *
FROM search_across_metadata(:search_term);
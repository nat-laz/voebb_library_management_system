-- debug
-- DROP FUNCTION IF EXISTS search_across_multiple_tables(text);

-- function
CREATE OR REPLACE FUNCTION search_across_multiple_tables(search_term TEXT)
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
               p.product_link_to_emedia,
               ARRAY_TO_STRING(mpi.available_in_libraries, ', ') AS available_in_libraries,
               p.product_note                                    AS description
        FROM main_page_info mpi
                 LEFT JOIN creator_relation cr ON cr.product_id = mpi.product_id
                 LEFT JOIN creator c ON c.creator_id = cr.creator_id
                 LEFT JOIN product p ON cr.product_id = p.product_id
        WHERE mpi.product_title % search_term
           OR p.product_note % search_term
           OR c.creator_forename % search_term
           OR c.creator_lastname % search_term
           OR mpi.product_title ILIKE '%' || search_term || '%'
           OR p.product_note ILIKE '%' || search_term || '%'
           OR c.creator_forename ILIKE '%' || search_term || '%'
           OR c.creator_lastname ILIKE '%' || search_term || '%'
        ORDER BY GREATEST(
                         similarity(LOWER(mpi.product_title), LOWER(search_term)),
                         similarity(LOWER(p.product_note), LOWER(search_term)),
                         similarity(LOWER(c.creator_forename), LOWER(search_term)),
                         similarity(LOWER(c.creator_lastname), LOWER(search_term))
                 ) DESC
        LIMIT 100;
END;
$$ LANGUAGE plpgsql;


-- TEST QUERY
SELECT *
FROM search_across_multiple_tables(:search_term);

-- ANALYSE PERFORMANCE
-- EXPLAIN ANALYSE
-- SELECT *
-- FROM search_across_multiple_tables(:search_term);
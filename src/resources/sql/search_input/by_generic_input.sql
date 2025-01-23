-- add extension: pg_trgm - support for similarity of text using trigram matching
CREATE EXTENSION IF NOT EXISTS pg_trgm;


-- Create supporting index for product title, notes
CREATE INDEX idx_gin_product_search
    ON product
        USING GIN (
                   product_title gin_trgm_ops,
                   product_note gin_trgm_ops
            );


-- before re-run drop
DROP INDEX IF EXISTS idx_gin_creator_search;

-- Create index for creator names
CREATE INDEX idx_gin_creator_search
    ON creator
        USING GIN (
                   creator_forename gin_trgm_ops,
                   creator_lastname gin_trgm_ops
            );


-- before re-run drop
DROP FUNCTION IF EXISTS comprehensive_product_search(text);

-- function
CREATE OR REPLACE FUNCTION comprehensive_product_search(search_term TEXT)
    RETURNS TABLE
            (
                product_id       INT,
                title            TEXT,
                creator_forename TEXT,
                creator_lastname TEXT,
                format           TEXT,
                notes            TEXT
            )
AS
$$
BEGIN
    RETURN QUERY
        SELECT cpv.product_id,
               cpv.title,
               cpv.creator_forename,
               cpv.creator_lastname,
               cpv.format,
               cpv.notes
        FROM comprehensive_product_view cpv
        WHERE cpv.title % search_term
           OR cpv.notes % search_term
           OR cpv.creator_forename % search_term
           OR cpv.creator_lastname % search_term
           OR cpv.title ILIKE '%' || search_term || '%'
           OR cpv.notes ILIKE '%' || search_term || '%'
           OR cpv.creator_forename ILIKE '%' || search_term || '%'
           OR cpv.creator_lastname ILIKE '%' || search_term || '%'
        ORDER BY GREATEST(
                         similarity(lower(cpv.title), lower(search_term)),
                         similarity(lower(cpv.notes), lower(search_term)),
                         similarity(lower(cpv.creator_forename), lower(search_term)),
                         similarity(lower(cpv.creator_lastname), lower(search_term))
                 ) DESC
        LIMIT 100;
END;
$$ LANGUAGE plpgsql;



SELECT *
FROM comprehensive_product_search(:search_term);

EXPLAIN ANALYSE
SELECT *
FROM comprehensive_product_search(:search_term);
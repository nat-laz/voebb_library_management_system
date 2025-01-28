-------------------- INDEXES: --------------------
-- GIN Index for full-search and similarity on product title, notes
CREATE INDEX idx_gin_product_search
    ON product
        USING gin (
                   product_title gin_trgm_ops,
                   product_note gin_trgm_ops
            );

-- GIN Index for full-search on creator names
CREATE INDEX idx_gin_creator_search
    ON creator
        USING gin (
                   creator_forename gin_trgm_ops,
                   creator_lastname gin_trgm_ops
            );

-- PARTIAL Index: improves performance when checking if the product is physical or not
CREATE INDEX idx_product_link_to_emedia_not_null
    ON product (product_link_to_emedia)
    WHERE product_link_to_emedia IS NOT NULL;

-- B-TREE Index: improves performance when searching by title
-- TODO: Read about tsvector and don't use % for pattern matching
CREATE INDEX idx_product_title ON product USING btree (product_title);
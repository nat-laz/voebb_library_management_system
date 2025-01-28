SELECT *
FROM main_page_info
WHERE product_title ILIKE '%' || ? || '%';

SELECT COUNT(*)
FROM main_page_info
WHERE product_title ILIKE '%' || ? || '%';
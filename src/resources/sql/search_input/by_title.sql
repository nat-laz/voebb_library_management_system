SELECT *
FROM main_page_info
WHERE product_title ILIKE '%' || ? || '%'
LIMIT 22 OFFSET 0;

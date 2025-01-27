-- TOTAL AMOUNT OF ITEMS IN EACH LIBRARY
SELECT library.library_name,
       COUNT(*) AS total_items
FROM library
         JOIN item_location ON library.library_id = item_location.library_id
         JOIN product_item ON item_location.item_id = product_item.item_id
--where item_location.library_id = ?
GROUP BY library.library_name;

-- DETAILED STATISTIC ABOUT MEDIA FORMATS BY LIBRARY_ID
SELECT media_format_name,
       COUNT(*) AS total_items
FROM library
         JOIN item_location ON library.library_id = item_location.library_id
         JOIN product_item ON item_location.item_id = product_item.item_id
         JOIN product ON product_item.product_id = product.product_id
         JOIN media_format ON product.media_format_id = media_format.media_format_id
WHERE item_location.library_id = ?
GROUP BY media_format_name;

-- DETAILED STATISTIC ABOUT AVAILABILITY BY LIBRARY_ID
SELECT item_status_name,
       COUNT(*) AS total_items
FROM library
         JOIN item_location ON library.library_id = item_location.library_id
         JOIN product_item ON item_location.item_id = product_item.item_id
         JOIN product ON product_item.product_id = product.product_id
         JOIN item_status ON product_item.item_status_id = item_status.item_status_id
WHERE item_location.library_id = ?
GROUP BY item_status_name;
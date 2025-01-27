-- Check borrow table
SELECT *
FROM borrow;

-- Get borrow duration days by item_id
SELECT mf.borrow_duration_days
FROM product_item
         JOIN product ON product_item.product_id = product.product_id
         JOIN media_format mf ON product.media_format_id = mf.media_format_id
WHERE item_id = ?;

-- Borrow table more details
SELECT client_id,
       borrow.item_id,
       product.product_id,
       item_location.library_id,
       item_status_name,
       borrow_start_date,
       borrow_due_date,
       borrow_return_date
FROM borrow
         JOIN product_item ON borrow.item_id = product_item.item_id
         JOIN product ON product_item.product_id = product.product_id
         JOIN item_status ON product_item.item_status_id = item_status.item_status_id
         JOIN item_location ON product_item.item_id = item_location.item_id
ORDER BY item_id;


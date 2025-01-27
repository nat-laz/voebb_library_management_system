SELECT p.product_title,
       b.borrow_start_date,
       b.borrow_return_date,
       b.borrow_due_date - b.borrow_return_date AS verdue
FROM borrow b
         JOIN product_item pi ON b.item_id = pi.item_id
         JOIN product p ON pi.product_id = p.product_id
WHERE b.borrow_return_date <= CURRENT_DATE
  AND b.client_id = ?;
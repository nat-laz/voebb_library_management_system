-- Check borrow table
select *
from borrow;

-- Get borrow duration days by item_id
select mf.borrow_duration_days
from product_item
         join product on product_item.product_id = product.product_id
         join media_format mf on product.media_format_id = mf.media_format_id
where item_id = ?;

-- Borrow table more details
select client_id,
       borrow.item_id,
       borrow_start_date,
       borrow_due_date,
       borrow_return_date,
       item_status_name
from borrow
         JOIN product_item ON borrow.item_id = product_item.item_id
         JOIN item_status ON product_item.item_status_id = item_status.item_status_id;
-- Check borrow table
select *
from borrow;

-- Get borrow duration days by item_id
select mf.borrow_duration_days
from product_item
         join product on product_item.product_id = product.product_id
         join media_format mf on product.media_format_id = mf.media_format_id
where item_id = ?;
select p.product_title,
       b.borrow_start_date,
       b.borrow_return_date,
       b.borrow_due_date - b.borrow_return_date as verdue
from borrow b
         join product_item pi on b.item_id = pi.item_id
         join product p on pi.product_id = p.product_id
where b.borrow_return_date <= current_date
  and b.client_id = ?;
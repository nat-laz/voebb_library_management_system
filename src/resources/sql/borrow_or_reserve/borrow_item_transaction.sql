-- TRANSACTION FOR BORROWING
BEGIN;
-- Borrow new item
insert into borrow(client_id, item_id)
VALUES (1, 7);

-- Change status for item
update product_item
set item_status_id = 1
where product_item.item_id = 7;

COMMIT;
insert into borrow(client_id, item_id)
VALUES (1, 4);

select * from borrow;

-- Get borrow duration days by item_id
select media_format.borrow_duration_days
from product_item
         join product on product_item.product_id = product.product_id
         join media_format on product.media_format_id = media_format.media_format_id
where item_id = ?;

-- function
CREATE OR REPLACE FUNCTION calculate_borrow_due_date()
    RETURNS TRIGGER AS $$
BEGIN
    NEW.borrow_due_date := CURRENT_DATE + (select media_format.borrow_duration_days
        from product_item
        join product on product_item.product_id = product.product_id
        join media_format on product.media_format_id = media_format.media_format_id
                                                       where item_id = NEW.item_id)::INT;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- trigger
CREATE OR REPLACE TRIGGER calculate_borrow_due_date
    BEFORE INSERT ON borrow
    FOR EACH ROW
EXECUTE FUNCTION calculate_borrow_due_date();


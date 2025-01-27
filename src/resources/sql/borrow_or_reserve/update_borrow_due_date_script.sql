-- function
CREATE OR REPLACE FUNCTION calculate_borrow_due_date()
    RETURNS TRIGGER AS
$$
BEGIN
    new.borrow_due_date := CURRENT_DATE + (SELECT media_format.borrow_duration_days
                                           FROM product_item
                                                    JOIN product ON product_item.product_id = product.product_id
                                                    JOIN media_format ON product.media_format_id = media_format.media_format_id
                                           WHERE item_id = new.item_id)::INT;
    RETURN new;
END;
$$ LANGUAGE plpgsql;

-- trigger
CREATE OR REPLACE TRIGGER calculate_borrow_due_date
    BEFORE INSERT
    ON borrow
    FOR EACH ROW
EXECUTE FUNCTION calculate_borrow_due_date();
DO
$$
    DECLARE
        v_item_id INT := ?;

    BEGIN
        IF EXISTS(SELECT item_id FROM borrow WHERE item_id = v_item_id AND borrow_return_date IS NULL)
        THEN
            -- re-activate  status to "available"
            UPDATE product_item
            SET item_status_id = 1
            WHERE product_item.item_id = v_item_id;

            UPDATE borrow
            SET borrow_return_date = CURRENT_DATE
            WHERE item_id = v_item_id;
        ELSE
            RAISE EXCEPTION 'Item with id % is not borrowed.', v_item_id;
        END IF;
    END
$$;

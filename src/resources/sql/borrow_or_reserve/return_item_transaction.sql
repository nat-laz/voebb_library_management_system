DO
$$
    DECLARE
        v_item_id INT := ?;

    BEGIN
        IF exists(select item_id from borrow where item_id = v_item_id and borrow_return_date is null)
        THEN
            UPDATE borrow
            SET borrow_return_date = CURRENT_DATE
            WHERE item_id = v_item_id;
        ELSE
            RAISE EXCEPTION 'Item with id % is not borrowed.', v_item_id;
        END IF;
    END
$$;

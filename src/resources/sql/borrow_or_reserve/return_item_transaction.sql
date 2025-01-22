DO
$$
    DECLARE
        v_item_id INT := ?;

    BEGIN
        IF EXISTS(SELECT item_id FROM borrow WHERE item_id = v_item_id AND borrow_return_date IS NULL)
        THEN
            UPDATE borrow
            SET borrow_return_date = CURRENT_DATE
            WHERE item_id = v_item_id;
        ELSE
            RAISE EXCEPTION 'Item with id % is not borrowed.', v_item_id;
        END IF;
    END
$$;

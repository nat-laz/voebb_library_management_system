-- TRANSACTION FOR RESERVATION
DO
$$
    DECLARE
        v_item_id        INT := ?;
        v_client_id      INT := ?;
        v_item_status_id INT;
    BEGIN
        -- check if item is not reserved and not borrowed
        v_item_status_id := (SELECT product_item.item_status_id FROM product_item WHERE item_id = v_item_id);

        IF (v_item_status_id = 2) THEN
            RAISE EXCEPTION 'Item with id % is borrowed', v_item_id;
        ELSIF (v_item_status_id = 3) THEN
            RAISE EXCEPTION 'Item with id % is reserved', v_item_id;
        END IF;

        -- Reserve new item
        INSERT INTO reservation(client_id, item_id)
        VALUES (v_client_id, v_item_id);

        -- Change status for item
        UPDATE product_item
        SET item_status_id = 3
        WHERE product_item.item_id = v_item_id;
    END
$$;


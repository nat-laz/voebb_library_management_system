-- TRANSACTION FOR BORROWING
DO
$$
    DECLARE
        v_item_id        INT := ?;
        v_client_id      INT := ?;
        v_library_id     INT := ?;


    BEGIN
        PERFORM validate_item_and_client_ids(v_item_id, v_client_id);

        PERFORM validate_item_status(v_item_id);

        PERFORM validate_item_location(v_item_id, v_library_id, 'borrow');

        -- Borrow new item
        INSERT INTO borrow(client_id, item_id, library_id)
        VALUES (v_client_id, v_item_id, v_library_id);


        -- Change status for item
        UPDATE product_item
        SET item_status_id = 2
        WHERE product_item.item_id = v_item_id;
    END
$$;


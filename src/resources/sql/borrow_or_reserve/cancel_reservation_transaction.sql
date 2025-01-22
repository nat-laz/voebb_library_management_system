DO
$$
    DECLARE
        v_item_id INT := ?;

    BEGIN
        IF EXISTS(SELECT item_id
                  FROM reservation
                  WHERE item_id = v_item_id
                     OR (current_date - reservation_start_date) > 3)
        THEN
            -- re-activate  status to "available"
            UPDATE product_item
            SET item_status_id = 1
            WHERE product_item.item_id = v_item_id;
        ELSE
            RAISE EXCEPTION 'Item with id % is not reserved.', v_item_id;
        END IF;
    END
$$;




-- function
CREATE OR REPLACE FUNCTION expire_reservations()
    RETURNS TRIGGER AS
$$
BEGIN

    -- Check if the reservation has expired
    IF (current_date - NEW.reservation_start_date) > INTERVAL '3 days' THEN

    -- Test trigger
--     IF (CURRENT_TIMESTAMP - NEW.reservation_start_date) > INTERVAL '30 seconds' THEN


        -- re-activate  status to "available"
        UPDATE product_item
        SET item_status_id = 1
        WHERE product_item.item_id = NEW.item_id;


        RAISE NOTICE 'Reservation expired. Item % is now available.', NEW.item_id;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- trigger
CREATE TRIGGER trigger_expire_reservations
    AFTER INSERT OR UPDATE
    ON reservation
    FOR EACH ROW
EXECUTE FUNCTION expire_reservations();


-- -- TEST PURPOSE
-- INSERT INTO reservation (client_id, item_id, reservation_start_date, reservation_due_date)
-- VALUES (100, 50, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '1 day');
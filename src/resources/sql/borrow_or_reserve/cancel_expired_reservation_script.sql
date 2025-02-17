CREATE
    OR REPLACE FUNCTION expire_reservations_daily()
    RETURNS VOID AS
$$
DECLARE
    record_reservation RECORD;
BEGIN
    FOR record_reservation IN
        SELECT item_id, reservation_due_date
        FROM reservation
        LOOP
            IF (CURRENT_DATE > record_reservation.reservation_due_date) THEN
                -- re-activate  status to "available"
                UPDATE product_item
                SET item_status_id = 1
                WHERE product_item.item_id = record_reservation.item_id;

                -- delete record from reservation
                DELETE
                FROM reservation
                WHERE reservation.item_id = record_reservation.item_id;
            END IF;
        END LOOP;
END;
$$
    LANGUAGE plpgsql;

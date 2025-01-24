-- CHECK RESERVATION TABLE
SELECT *
FROM reservation;

-- CHECK RESERVATION TABLE MORE DETAILS
SELECT reservation.client_id,
       product_item.item_id,
       item_status_name,
       product.product_title,
       concat(client.client_forename || ' ' || client.client_lastname, ', ') AS creator_full_name,
       reservation_start_date,
       reservation_due_date
FROM reservation
         JOIN client_relation ON reservation.client_id = client_relation.client_id
         JOIN client ON client_relation.client_id = client.client_id
         JOIN product_item ON reservation.item_id = product_item.item_id
         JOIN product ON product_item.product_id = product.product_id
         JOIN item_status ON product_item.item_status_id = item_status.item_status_id;


-- RETURN ALL PRODUCTS WITH their statuses
SELECT product_item.item_id,
       client.client_id,
       item_status_name
FROM product_item
         JOIN item_status ON product_item.item_status_id = item_status.item_status_id
         LEFT JOIN reservation ON product_item.item_id = reservation.item_id
         LEFT JOIN client_relation ON reservation.client_id = client_relation.client_id
         LEFT JOIN client ON client_relation.client_id = client.client_id
ORDER BY item_id;
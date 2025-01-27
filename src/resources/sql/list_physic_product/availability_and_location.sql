SELECT DISTINCT fii.item_status_name,
                fii.product_title                                   AS title,
                CONCAT(c.creator_forename, ' ', c.creator_lastname) AS creator_full_name,
                fii.library_name,
                fii.city,
                fii.street,
                fii.house_number,
                la.osm_link,
                fii.item_id
FROM full_item_info fii
         LEFT JOIN creator_relation cr ON cr.product_id = fii.product_id
         LEFT JOIN creator c ON c.creator_id = cr.creator_id
         LEFT JOIN library_address la ON la.library_id = fii.library_id
WHERE fii.product_id = ?;

-- TOTAL AMOUNT OF ITEMS IN EACH LIBRARY
select library.library_name,
       count(*) as total_items
from library
         join item_location on library.library_id = item_location.library_id
         join product_item on item_location.item_id = product_item.item_id
--where item_location.library_id = ?
group by library.library_name;

-- DETAILED STATISTIC ABOUT MEDIA FORMATS BY LIBRARY_ID
select media_format_name,
       count(*) as total_items
from library
         join item_location on library.library_id = item_location.library_id
         join product_item on item_location.item_id = product_item.item_id
         join product on product_item.product_id = product.product_id
         join media_format on product.media_format_id = media_format.media_format_id
where item_location.library_id = ?
group by media_format_name;

-- DETAILED STATISTIC ABOUT AVAILABILITY BY LIBRARY_ID
select item_status_name,
       count(*) as total_items
from library
         join item_location on library.library_id = item_location.library_id
         join product_item on item_location.item_id = product_item.item_id
         join product on product_item.product_id = product.product_id
         join item_status on product_item.item_status_id = item_status.item_status_id
where item_location.library_id = ?
group by item_status_name;
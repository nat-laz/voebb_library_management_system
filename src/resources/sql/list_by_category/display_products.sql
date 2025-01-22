select product.product_id,
       case
           when MIN(item_status.item_status_id) = 1
               then 'true' end as avaliable,
       array_agg(case
                     when item_status.item_status_id = 1 -- available
                         then  library.library_name
           end)                as available_in_libraries,
       product.product_title,
       creator_forename,
       creator_lastname,
       product.product_year,
       product.product_photo_link,
       media_format_name
from product
         join media_format on media_format.media_format_id = product.media_format_id
         join creator_relation on product.product_id = creator_relation.product_id
         join creator on creator_relation.creator_id = creator.creator_id
         join product_item on product.product_id = product_item.product_id
         join item_status on product_item.item_status_id = item_status.item_status_id
         join item_location on product_item.item_id = item_location.item_id
         join library on item_location.library_id = library.library_id
WHERE product.media_format_id = ? -- here maybe better media_format_name
  AND product.product_title ilike ?
group by product.product_id, product.product_title, creator_forename, creator_lastname, product.product_year,
         product.product_photo_link, item_status.item_status_id, media_format.media_format_name
limit 10 offset ?;

select * from media_format;
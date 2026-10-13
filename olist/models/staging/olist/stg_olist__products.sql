with src as (
    select * from {{ source('olist_bronze', 'products') }}
)
select
    product_id,
    product_category_name,
    cast(product_name_lenght as int)            as product_name_length,
    cast(product_description_lenght as int)     as product_description_length,
    cast(product_photos_qty as int)             as product_photos_qty,
    cast(product_weight_g as int)               as product_weight_g,
    cast(product_length_cm as int)              as product_length_cm,
    cast(product_height_cm as int)              as product_height_cm,
    cast(product_width_cm as int)               as product_width_cm,
    _ingested_at
from src
qualify row_number() over (partition by product_id order by _ingested_at desc) = 1
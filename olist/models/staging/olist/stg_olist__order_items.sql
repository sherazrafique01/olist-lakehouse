with src as (
    select * from {{ source('olist_bronze', 'order_items') }}
)
select
    order_id,
    cast(order_item_id as int)                  as order_item_id,
    product_id,
    seller_id,
    cast(shipping_limit_date as timestamp)      as shipping_limit_at,
    cast(price as decimal(10,2))                as price,
    cast(freight_value as decimal(10,2))        as freight_value,
    _ingested_at
from src
qualify row_number() over (partition by order_id, order_item_id order by _ingested_at desc) = 1
with products as (
    select * from {{ ref('stg_olist__products') }}
),
translation as (
    select * from {{ ref('stg_olist__category_translation') }}
)
select
    p.product_id,
    coalesce(t.product_category_name_english, p.product_category_name, 'unknown') as category,
    p.product_category_name                                                       as category_pt,
    p.product_photos_qty,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm
from products p
left join translation t on p.product_category_name = t.product_category_name
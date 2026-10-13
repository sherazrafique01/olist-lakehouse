with src as (
    select * from {{ source('olist_bronze', 'product_category_name_translation') }}
)
select
    product_category_name,
    product_category_name_english,
    _ingested_at
from src
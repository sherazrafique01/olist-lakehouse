with src as (
    select * from {{ source('olist_bronze', 'customers') }}
)
select
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix                as zip_code_prefix,
    lower(trim(customer_city))              as city,
    upper(trim(customer_state))             as state,
    _ingested_at
from src
qualify row_number() over (partition by customer_id order by _ingested_at desc) = 1
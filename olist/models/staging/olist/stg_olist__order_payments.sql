with src as (
    select * from {{ source('olist_bronze', 'order_payments') }}
)
select
    order_id,
    cast(payment_sequential as int)             as payment_sequential,
    lower(trim(payment_type))                   as payment_type,
    cast(payment_installments as int)           as payment_installments,
    cast(payment_value as decimal(10,2))        as payment_value,
    _ingested_at
from src
qualify row_number() over (partition by order_id, payment_sequential order by _ingested_at desc) = 1
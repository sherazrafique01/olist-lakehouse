with customers as (
    select * from {{ ref('stg_olist__customers') }}
),
orders as (
    select * from {{ ref('stg_olist__orders') }}
),
joined as (
    select
        c.customer_unique_id,
        c.zip_code_prefix,
        c.city,
        c.state,
        o.purchased_at
    from customers c
    join orders o on o.customer_id = c.customer_id
)
select
    customer_unique_id,
    zip_code_prefix,
    city,
    state,
    min(purchased_at) over (partition by customer_unique_id) as first_order_at,
    count(*)         over (partition by customer_unique_id) as total_orders
from joined
qualify row_number() over (partition by customer_unique_id order by purchased_at desc) = 1
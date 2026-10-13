with items as (
    select * from {{ ref('stg_olist__order_items') }}
),
orders as (
    select order_id, customer_id, order_status, purchased_at from {{ ref('stg_olist__orders') }}
),
customers as (
    select customer_id, customer_unique_id from {{ ref('stg_olist__customers') }}
)
select
    {{ dbt_utils.generate_surrogate_key(['i.order_id', 'i.order_item_id']) }} as order_item_sk,
    i.order_id,
    i.order_item_id,
    c.customer_unique_id,
    i.product_id,
    i.seller_id,
    o.order_status,
    o.purchased_at,
    cast(o.purchased_at as date)   as purchase_date,
    i.price,
    i.freight_value,
    i.price + i.freight_value      as item_total
from items i
join orders o     on i.order_id = o.order_id
join customers c  on o.customer_id = c.customer_id
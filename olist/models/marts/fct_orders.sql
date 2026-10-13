with orders as (
    select * from {{ ref('stg_olist__orders') }}
),
customers as (
    select customer_id, customer_unique_id from {{ ref('stg_olist__customers') }}
),
items as (
    select
        order_id,
        count(*)            as item_count,
        sum(price)          as items_value,
        sum(freight_value)  as freight_value
    from {{ ref('stg_olist__order_items') }}
    group by order_id
),
payments as (
    select * from {{ ref('int_order_payments_pivoted') }}
),
reviews as (
    select * from {{ ref('int_order_reviews_per_order') }}
)
select
    o.order_id,
    c.customer_unique_id,
    o.order_status,
    o.purchased_at,
    cast(o.purchased_at as date)                         as purchase_date,
    o.delivered_at,
    o.estimated_delivery_at,
    coalesce(i.item_count, 0)                            as item_count,
    coalesce(i.items_value, 0)                           as items_value,
    coalesce(i.freight_value, 0)                         as freight_value,
    coalesce(p.total_paid, 0)                            as total_paid,
    p.credit_card_amount,
    p.boleto_amount,
    p.voucher_amount,
    p.debit_card_amount,
    r.avg_review_score,
    datediff(o.delivered_at, o.purchased_at)             as delivery_days,
    datediff(o.delivered_at, o.estimated_delivery_at)    as delivery_delay_days,
    case
        when o.delivered_at is null then null
        when o.delivered_at > o.estimated_delivery_at then true
        else false
    end                                                  as is_late
from orders o
join customers c       on o.customer_id = c.customer_id
left join items i      on o.order_id = i.order_id
left join payments p   on o.order_id = p.order_id
left join reviews r    on o.order_id = r.order_id
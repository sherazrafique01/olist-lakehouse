with seller_revenue as (
    select seller_id, count(distinct order_id) as orders, sum(item_total) as revenue
    from {{ ref('fct_order_items') }}
    where order_status = 'delivered'
    group by seller_id
),
seller_reviews as (
    select i.seller_id, avg(o.avg_review_score) as avg_review
    from {{ ref('fct_order_items') }} i
    join {{ ref('fct_orders') }} o on i.order_id = o.order_id
    group by i.seller_id
)
select
    s.seller_id,
    s.state,
    r.orders,
    round(r.revenue, 2)      as revenue,
    round(v.avg_review, 2)   as avg_review
from seller_revenue r
join {{ ref('dim_sellers') }} s     on r.seller_id = s.seller_id
left join seller_reviews v          on r.seller_id = v.seller_id
order by r.revenue desc
limit 10
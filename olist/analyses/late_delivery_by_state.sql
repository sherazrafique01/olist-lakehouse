select
    c.state,
    count(*)                                          as delivered_orders,
    round(avg(cast(f.is_late as int)) * 100, 1)       as late_pct
from {{ ref('fct_orders') }} f
join {{ ref('dim_customers') }} c on f.customer_unique_id = c.customer_unique_id
where f.is_late is not null
group by c.state
having count(*) >= 100
order by late_pct desc
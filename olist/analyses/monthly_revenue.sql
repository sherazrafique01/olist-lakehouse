select
    d.year_month,
    count(*)              as orders,
    sum(f.total_paid)     as revenue
from {{ ref('fct_orders') }} f
join {{ ref('dim_date') }} d on f.purchase_date = d.date_day
where f.order_status not in ('canceled', 'unavailable')
group by d.year_month
order by d.year_month
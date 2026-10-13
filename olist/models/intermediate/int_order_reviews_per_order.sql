select
    order_id,
    avg(review_score)  as avg_review_score,
    count(*)           as review_count
from {{ ref('stg_olist__order_reviews') }}
group by order_id
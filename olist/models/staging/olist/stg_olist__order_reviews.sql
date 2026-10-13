with src as (
    select * from {{ source('olist_bronze', 'order_reviews') }}
)
select
    review_id,
    order_id,
    cast(review_score as int)                   as review_score,
    review_comment_title,
    review_comment_message,
    cast(review_creation_date as timestamp)     as review_created_at,
    cast(review_answer_timestamp as timestamp)  as review_answered_at,
    _ingested_at
from src
qualify row_number() over (partition by review_id, order_id order by _ingested_at desc) = 1
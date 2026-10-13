select
    zip_code_prefix,
    avg(latitude)   as latitude,
    avg(longitude)  as longitude,
    max(city)       as city,
    max(state)      as state,
    count(*)        as points_in_zip
from {{ ref('stg_olist__geolocation') }}
group by zip_code_prefix
with days as (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2016-01-01' as date)",
        end_date="cast('2019-01-01' as date)"
    ) }}
)
select
    cast(date_day as date)               as date_day,
    year(date_day)                       as year,
    month(date_day)                      as month,
    date_format(date_day, 'MMMM')        as month_name,
    date_format(date_day, 'yyyy-MM')     as year_month,
    dayofweek(date_day)                  as day_of_week,
    dayofweek(date_day) in (1, 7)        as is_weekend
from days
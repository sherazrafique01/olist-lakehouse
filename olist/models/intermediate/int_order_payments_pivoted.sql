{% set payment_types = ['credit_card', 'boleto', 'voucher', 'debit_card'] %}

select
    order_id,
    {% for p in payment_types %}
    sum(case when payment_type = '{{ p }}' then payment_value else 0 end) as {{ p }}_amount,
    {% endfor %}
    sum(payment_value) as total_paid
from {{ ref('stg_olist__order_payments') }}
group by order_id
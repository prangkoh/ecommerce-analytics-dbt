with customers as (
    select * from {{ ref('int_customer_order_summary') }}
),

-- assign spend tiers based on lifetime value
segmented as (
    select
        *,
        case
            when lifetime_value >= 1000000  then 'High Value'
            when lifetime_value >= 500000   then 'Mid Value'
            else                                 'Low Value'
        end as spend_tier,

        case
            when total_orders >= 20 then 'Frequent'
            when total_orders >= 10 then 'Regular'
            else                         'Occasional'
        end as order_frequency_tier,

        case
            when lifetime_value >= 1000000
             and total_orders   >= 20       then 'Champion'
            when lifetime_value >= 500000
             and total_orders   >= 10       then 'Loyal'
            when lifetime_value >= 1000000  then 'Big Spender'
            when total_orders   >= 20       then 'Power User'
            else                                 'Standard'
        end as customer_segment

    from customers
)

select
    customer_id,
    customer_name,
    market_segment,
    nation_name,
    region_name,
    total_orders,
    lifetime_value,
    avg_order_value,
    first_order_date,
    last_order_date,
    customer_tenure_days,
    open_orders,
    fulfilled_orders,
    spend_tier,
    order_frequency_tier,
    customer_segment
from segmented
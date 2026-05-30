{% snapshot snp_customer_segments %}

{{
    config(
        target_schema='PUBLIC',
        unique_key='customer_id',
        strategy='check',
        check_cols=['customer_segment', 'spend_tier', 'order_frequency_tier']
    )
}}

select
    customer_id,
    customer_name,
    market_segment,
    nation_name,
    region_name,
    total_orders,
    lifetime_value,
    customer_segment,
    spend_tier,
    order_frequency_tier
from {{ ref('dim_customers') }}

{% endsnapshot %}
with orders as (
    select * from {{ ref('stg_orders') }}
),

customers as (
    select * from {{ ref('stg_customers') }}
),

nations as (
    select * from {{ ref('stg_nations') }}
),

regions as (
    select * from {{ ref('stg_regions') }}
),

final as (
    select
        -- order info
        o.order_id,
        o.order_date,
        o.status,
        o.total_price,
        o.order_priority,
        o.ship_priority,

        -- customer info
        c.customer_id,
        c.customer_name,
        c.market_segment,
        c.account_balance as customer_account_balance,

        -- geography
        n.nation_name,
        r.region_name

    from orders o
    left join customers c on o.customer_id = c.customer_id
    left join nations n   on c.nation_id = n.nation_id
    left join regions r   on n.region_id = r.region_id
)

select * from final
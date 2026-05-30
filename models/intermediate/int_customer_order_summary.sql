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

order_aggregates as (
    select
        customer_id,
        count(order_id)                             as total_orders,
        sum(total_price)                            as lifetime_value,
        avg(total_price)                            as avg_order_value,
        min(order_date)                             as first_order_date,
        max(order_date)                             as last_order_date,
        datediff('day', min(order_date),
                        max(order_date))            as customer_tenure_days,
        sum(case when status = 'O'
                 then 1 else 0 end)                 as open_orders,
        sum(case when status = 'F'
                 then 1 else 0 end)                 as fulfilled_orders
    from orders
    group by customer_id
),

final as (
    select
        c.customer_id,
        c.customer_name,
        c.market_segment,
        n.nation_name,
        r.region_name,
        a.total_orders,
        a.lifetime_value,
        a.avg_order_value,
        a.first_order_date,
        a.last_order_date,
        a.customer_tenure_days,
        a.open_orders,
        a.fulfilled_orders

    from customers c
    left join order_aggregates a  on c.customer_id = a.customer_id
    left join nations n           on c.nation_id = n.nation_id
    left join regions r           on n.region_id = r.region_id
)

select * from final
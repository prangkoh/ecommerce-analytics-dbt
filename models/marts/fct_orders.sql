with orders as (
    select * from {{ ref('int_orders_with_details') }}
),

lineitems as (
    select
        order_id,
        count(line_number)          as total_line_items,
        sum(quantity)               as total_quantity,
        sum(extended_price)         as gross_revenue,
        sum(net_revenue)            as net_revenue,
        sum(extended_price * tax)   as total_tax,
        avg(discount)               as avg_discount_rate,
        min(ship_date)              as first_ship_date,
        max(ship_date)              as last_ship_date,
        count(case when return_flag = 'R'
              then 1 end)           as returned_items
    from {{ ref('stg_lineitems') }}
    group by order_id
),

final as (
    select
        -- keys
        o.order_id,
        o.customer_id,

        -- dates
        o.order_date,
        o.order_date::date                              as order_month_start,
        date_trunc('month', o.order_date)               as order_month,
        date_trunc('year',  o.order_date)               as order_year,

        -- order details
        o.status,
        o.order_priority,
        o.total_price,

        -- line item metrics
        l.total_line_items,
        l.total_quantity,
        l.gross_revenue,
        l.net_revenue,
        l.total_tax,
        l.avg_discount_rate,
        l.returned_items,
        l.first_ship_date,
        l.last_ship_date,

        -- days to ship
        datediff('day', o.order_date,
                        l.first_ship_date)              as days_to_first_ship,

        -- customer & geography
        o.customer_name,
        o.market_segment,
        o.nation_name,
        o.region_name

    from orders o
    left join lineitems l on o.order_id = l.order_id
)

select * from final
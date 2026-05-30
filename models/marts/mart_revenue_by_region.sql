with fct_orders as (
    select * from {{ ref('fct_orders') }}
),

final as (
    select
        region_name,
        nation_name,
        order_year,
        order_month,

        -- volume
        count(distinct order_id)            as total_orders,
        count(distinct customer_id)         as unique_customers,

        -- revenue
        sum(gross_revenue)                  as gross_revenue,
        sum(net_revenue)                    as net_revenue,
        avg(net_revenue)                    as avg_order_net_revenue,

        -- returns
        sum(returned_items)                 as total_returned_items,

        -- fulfillment
        avg(days_to_first_ship)             as avg_days_to_ship,
        sum(case when status = 'F'
                 then 1 else 0 end)         as fulfilled_orders,
        sum(case when status = 'O'
                 then 1 else 0 end)         as open_orders,

        -- fulfillment rate
        round(
            sum(case when status = 'F'
                     then 1 else 0 end)
            / nullif(count(order_id), 0)
        , 4)                                as fulfillment_rate

    from fct_orders
    group by 1, 2, 3, 4
)

select * from final
order by region_name, nation_name, order_year, order_month
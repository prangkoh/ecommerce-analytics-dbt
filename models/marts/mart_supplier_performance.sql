with lineitems as (
    select * from {{ ref('int_lineitems_with_details') }}
),

supplier_metrics as (
    select
        supplier_id,
        supplier_name,
        supplier_region,
        supplier_nation,

        count(distinct order_id)                        as total_orders,
        sum(quantity)                                   as total_quantity_supplied,

        -- using our cents_to_dollars macro on revenue columns
        {{ cents_to_dollars('sum(extended_price)') }}   as gross_revenue_dollars,
        {{ cents_to_dollars('sum(net_revenue)') }}      as net_revenue_dollars,

        avg(discount)                                   as avg_discount_rate,
        count(case when return_flag = 'R'
                   then 1 end)                          as total_returns,

        -- using safe_divide macro for return rate
        {{ safe_divide('count(case when return_flag = \'R\' then 1 end)',
                       'count(order_id)') }}            as return_rate,

        -- using surrogate key macro
        {{ generate_surrogate_key(['supplier_id', 'supplier_nation']) }}
                                                        as supplier_key

    from lineitems
    group by
        supplier_id,
        supplier_name,
        supplier_region,
        supplier_nation
)

select * from supplier_metrics
order by net_revenue_dollars desc
with lineitems as (
    select * from {{ ref('stg_lineitems') }}
),

suppliers as (
    select * from {{ ref('stg_suppliers') }}
),

nations as (
    select * from {{ ref('stg_nations') }}
),

regions as (
    select * from {{ ref('stg_regions') }}
),

final as (
    select
        -- line item info
        l.order_id,
        l.line_number,
        l.part_id,
        l.quantity,
        l.extended_price,
        l.discount,
        l.tax,
        l.net_revenue,
        l.return_flag,
        l.line_status,
        l.ship_date,
        l.ship_mode,

        -- supplier info
        s.supplier_id,
        s.supplier_name,
        s.account_balance as supplier_account_balance,

        -- supplier geography
        n.nation_name     as supplier_nation,
        r.region_name     as supplier_region

    from lineitems l
    left join suppliers s on l.supplier_id = s.supplier_id
    left join nations n   on s.nation_id = n.nation_id
    left join regions r   on n.region_id = r.region_id
)

select * from final
with enriched_orders as (

    select * from {{ ref('int_orders_enriched') }}

),

final as (

    select
        -- time dimensions
        date_trunc(created_at, day)     as date_day,
        date_trunc(created_at, month)   as date_month,
        date_trunc(created_at, year)    as date_year,

        -- product dimensions
        category,
        brand,
        department,

        -- order dimensions
        order_status,
        gender,

        -- metrics
        count(distinct order_id)                as num_orders,
        count(distinct order_item_id)           as num_items_sold,
        round(sum(sale_price), 2)               as total_revenue,
        round(avg(sale_price), 2)               as avg_item_price,
        round(sum(sale_price) / 
            nullif(count(distinct order_id), 0), 2) as avg_order_value,
        round(sum(cost), 2)                     as total_cost,
        round(sum(sale_price) - sum(cost), 2)   as total_profit

    from enriched_orders
    where order_status not in ('cancelled', 'returned')

    group by 1, 2, 3, 4, 5, 6, 7, 8

)

select * from final
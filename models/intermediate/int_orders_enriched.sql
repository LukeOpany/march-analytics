with orders as (

    select * from {{ ref('stg_orders') }}

),

order_items as (

    select * from {{ ref('stg_order_items') }}

),

products as (

    select * from {{ ref('stg_products') }}

),

order_items_with_products as (

    select
        order_items.order_item_id,
        order_items.order_id,
        order_items.user_id,
        order_items.status,
        order_items.sale_price,
        order_items.created_at,

        -- product details
        products.product_name,
        products.category,
        products.brand,
        products.department,
        products.retail_price,
        products.cost

    from order_items
    left join products
        on order_items.product_id = products.product_id

),

final as (

    select
        order_items_with_products.*,

        -- order details
        orders.status as order_status,
        orders.gender,
        orders.num_of_item

    from order_items_with_products
    left join orders
        on order_items_with_products.order_id = orders.order_id

)

select * from final
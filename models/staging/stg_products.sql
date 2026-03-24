with source as (

    select * from {{ source('thelook_ecommerce', 'products') }}

),

renamed as (

    select
        -- ids
        id as product_id,

        -- dimensions
        name as product_name,
        category,
        brand,
        department,

        -- amounts
        retail_price,
        cost

    from source

)

select * from renamed
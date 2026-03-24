with source as (

    select * from {{ source('thelook_ecommerce', 'orders') }}

),

renamed as (

    select
        -- ids
        order_id,
        user_id,

        -- dimensions
        status,
        gender,
        num_of_item,

        -- timestamps
        created_at,
        returned_at,
        shipped_at,
        delivered_at

    from source

)

select * from renamed
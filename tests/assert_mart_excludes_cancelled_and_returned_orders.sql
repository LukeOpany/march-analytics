-- The sales mart should contain commercial activity only.
-- A row returned by this query causes the dbt test to fail.

select *
from {{ ref('mart_sales_performance') }}
where lower(order_status) in ('cancelled', 'returned')

-- Custom data-quality test: every sale in the fact table must have a positive
-- revenue amount. The test passes when this query returns zero rows.
select
    order_number,
    sales_amount
from {{ ref('fct_sales') }}
where sales_amount <= 0

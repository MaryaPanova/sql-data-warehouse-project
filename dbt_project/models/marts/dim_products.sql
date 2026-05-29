-- Gold-layer product dimension: add a surrogate key to the enriched (current)
-- products produced by the intermediate layer.
with products as (
    select * from {{ ref('int_products__enriched') }}
)

select
    row_number() over (order by start_date, product_number) as product_key,  -- surrogate key
    product_id,
    product_number,
    product_name,
    category_id,
    category,
    subcategory,
    maintenance,
    cost,
    product_line,
    start_date
from products

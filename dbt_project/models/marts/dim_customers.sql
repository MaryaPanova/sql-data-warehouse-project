-- Gold-layer customer dimension: add a surrogate key to the unified customer
-- record produced by the intermediate layer.
with customers as (
    select * from {{ ref('int_customers__joined') }}
)

select
    row_number() over (order by customer_id) as customer_key,  -- surrogate key
    customer_id,
    customer_number,
    first_name,
    last_name,
    country,
    marital_status,
    gender,
    birthdate,
    create_date
from customers

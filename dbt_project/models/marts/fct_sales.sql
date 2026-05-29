-- Gold-layer sales fact: cleansed sales transactions linked to the customer
-- and product dimensions via their surrogate keys.
with sales as (
    select * from {{ ref('stg_crm__sales_details') }}
),

products as (
    select * from {{ ref('dim_products') }}
),

customers as (
    select * from {{ ref('dim_customers') }}
)

select
    sales.sls_ord_num   as order_number,
    products.product_key,
    customers.customer_key,
    sales.sls_order_dt  as order_date,
    sales.sls_ship_dt   as shipping_date,
    sales.sls_due_dt    as due_date,
    sales.sls_sales     as sales_amount,
    sales.sls_quantity  as quantity,
    sales.sls_price     as price
from sales
left join products  on sales.sls_prd_key = products.product_number
left join customers on sales.sls_cust_id = customers.customer_id

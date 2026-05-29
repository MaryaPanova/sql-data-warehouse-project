-- Business-logic join: enrich CRM products with ERP category/subcategory.
-- Only current product versions are kept (prd_end_dt is null), matching the
-- gold-layer dim_products definition.
with products as (
    select * from {{ ref('stg_crm__prd_info') }}
),

categories as (
    select * from {{ ref('stg_erp__px_cat_g1v2') }}
)

select
    products.prd_id     as product_id,
    products.prd_key    as product_number,
    products.prd_nm     as product_name,
    products.cat_id     as category_id,
    categories.cat      as category,
    categories.subcat   as subcategory,
    categories.maintenance,
    products.prd_cost   as cost,
    products.prd_line   as product_line,
    products.prd_start_dt as start_date
from products
left join categories on products.cat_id = categories.id
where products.prd_end_dt is null   -- filter out historical versions

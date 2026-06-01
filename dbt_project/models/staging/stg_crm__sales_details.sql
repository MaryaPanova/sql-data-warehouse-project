-- Silver-layer cleansing for CRM sales details:
--   * convert 8-digit integer dates into real DATEs (via parse_yyyymmdd macro)
--   * recompute sales = quantity * |price| when sales is missing/inconsistent
--   * recompute price = sales / quantity when price is missing/invalid
with source as (
    select * from {{ ref('crm_sales_details') }}
)

select
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    {{ parse_yyyymmdd('sls_order_dt') }} as sls_order_dt,
    {{ parse_yyyymmdd('sls_ship_dt') }}  as sls_ship_dt,
    {{ parse_yyyymmdd('sls_due_dt') }}   as sls_due_dt,
    case
        when sls_sales is null or sls_sales <= 0 or sls_sales != sls_quantity * abs(sls_price)
            then sls_quantity * abs(sls_price)
        else sls_sales
    end as sls_sales,
    sls_quantity,
    case
        when sls_price is null or sls_price <= 0
            then sls_sales / nullif(sls_quantity, 0)
        else sls_price
    end as sls_price
from source

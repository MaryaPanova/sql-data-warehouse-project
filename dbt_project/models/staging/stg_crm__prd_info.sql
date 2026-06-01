-- Silver-layer cleansing for CRM product info:
--   * split prd_key into a category id (joins to ERP categories) and product key
--   * default missing cost to 0, decode product line
--   * derive prd_end_dt as the day before the next version's start (SCD-style)
with source as (
    select * from {{ ref('crm_prd_info') }}
)

select
    prd_id,
    replace(substring(prd_key, 1, 5), '-', '_') as cat_id,
    substring(prd_key, 7, length(prd_key))      as prd_key,
    prd_nm,
    coalesce(prd_cost, 0) as prd_cost,
    case upper(trim(prd_line))
        when 'M' then 'Mountain'
        when 'R' then 'Road'
        when 'S' then 'Other Sales'
        when 'T' then 'Touring'
        else 'n/a'
    end as prd_line,
    cast(prd_start_dt as date) as prd_start_dt,
    cast(
        lead(prd_start_dt) over (partition by prd_key order by prd_start_dt) - 1
        as date
    ) as prd_end_dt
from source

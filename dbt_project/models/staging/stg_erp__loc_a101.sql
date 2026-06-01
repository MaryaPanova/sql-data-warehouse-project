-- Silver-layer cleansing for ERP location data:
--   * remove dashes so cid matches the CRM customer key
--   * normalise country codes/names to full country names
with source as (
    select * from {{ ref('erp_loc_a101') }}
)

select
    replace(cid, '-', '') as cid,
    case
        when trim(regexp_replace(cntry, '[\r]', '', 'g')) = 'DE' then 'Germany'
        when trim(regexp_replace(cntry, '[\r]', '', 'g')) in ('US', 'USA') then 'United States'
        when cntry is null or trim(regexp_replace(cntry, '[\r]', '', 'g')) = '' then 'n/a'
        else trim(regexp_replace(cntry, '[\r]', '', 'g'))
    end as cntry
from source

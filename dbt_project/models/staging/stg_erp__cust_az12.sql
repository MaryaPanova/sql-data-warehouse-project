-- Silver-layer cleansing for ERP customer demographics:
--   * strip the 'NAS' prefix so cid matches the CRM customer key
--   * null out impossible (future) birthdates
--   * standardise gender, tolerating stray whitespace/control characters
with source as (
    select * from {{ ref('erp_cust_az12') }}
)

select
    case
        when cid like 'NAS%' then substring(cid, 4, length(cid))
        else cid
    end as cid,
    case
        when cast(bdate as date) > current_date then null
        else cast(bdate as date)
    end as bdate,
    case
        when upper(trim(regexp_replace(gen, '[\t\r\n]', '', 'g'))) in ('F', 'FEMALE') then 'Female'
        when upper(trim(regexp_replace(gen, '[\t\r\n]', '', 'g'))) in ('M', 'MALE')   then 'Male'
        else 'n/a'
    end as gen
from source

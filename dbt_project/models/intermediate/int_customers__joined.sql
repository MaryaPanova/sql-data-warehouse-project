-- Business-logic join: unify the CRM customer master with ERP demographics
-- and location. CRM is the system of record for gender; fall back to ERP only
-- when CRM has no value.
with crm as (
    select * from {{ ref('stg_crm__cust_info') }}
),

erp_demo as (
    select * from {{ ref('stg_erp__cust_az12') }}
),

erp_loc as (
    select * from {{ ref('stg_erp__loc_a101') }}
)

select
    crm.cst_id            as customer_id,
    crm.cst_key           as customer_number,
    crm.cst_firstname     as first_name,
    crm.cst_lastname      as last_name,
    erp_loc.cntry         as country,
    crm.cst_marital_status as marital_status,
    case
        when crm.cst_gndr != 'n/a' then crm.cst_gndr      -- CRM is master for gender
        else coalesce(erp_demo.gen, 'n/a')
    end as gender,
    erp_demo.bdate        as birthdate,
    crm.cst_create_date   as create_date
from crm
left join erp_demo on crm.cst_key = erp_demo.cid
left join erp_loc  on crm.cst_key = erp_loc.cid

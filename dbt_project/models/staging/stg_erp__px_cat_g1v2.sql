-- Silver-layer pass-through for ERP product categories.
-- This source is already clean; the staging model exists for consistency and
-- to give downstream models a single, documented interface to the data.
with source as (
    select * from {{ ref('erp_px_cat_g1v2') }}
)

select
    id,
    cat,
    subcat,
    maintenance
from source

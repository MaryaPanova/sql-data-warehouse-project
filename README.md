# Data Warehouse and Analytics Project

Welcome to the **Data Warehouse and Analytics Project** repository.
This project demonstrates a comprehensive data warehousing and analytics solution, from building a DWH to generating actionable insights.

---

## Project Requirements

### Building the Data Warehouse 

#### Objective
Develop a modern DWH using SQL Server (or alternative) to consolidate sales data, enabling analytical reporting and informed decision-making.

#### Specifications
- **Data Source:** Import data from two source systems (ERP & CRM) provides as CSV files.
- **Data Quality:** Cleanse and resolve data quality issues prior to analysis.
- **Integration:** Combine both sources into a single, user-friendly data model designed for analytical queries.
- **Scope:** Focus on the latest dataset only. Historization of data is not required.
- **Documentation:** Provide clear documentation of the data model to support both business stakeholders and analysts.

### BI: Analytics & Reporting

#### Objective

Develop SQL-based analytics to deliver detailed insights into:

- Customer behaviour
- Product performance
- Sales Trends

This insights empower stakeholders with key business metrics, enabling strategic decision-making.

---

## dbt transformation layer

The transformation pipeline is now managed with **dbt** (data build tool), the
industry standard for analytics engineering. The original raw SQL scripts are
preserved in `scripts/` for reference; dbt re-implements the same
bronze → silver → gold logic as versioned, tested, documented models.

The project ships configured for **DuckDB**, so it runs end-to-end with zero
external infrastructure — no SQL Server required.

### Setup

```bash
cd dbt_project
python3 -m venv .venv && source .venv/bin/activate
pip install dbt-duckdb            # or dbt-sqlserver / dbt-postgres
cp profiles.yml.example profiles.yml   # gitignored; edit if not using DuckDB

dbt seed   --profiles-dir .       # load the CSV source data (bronze)
dbt run    --profiles-dir .       # build all models (silver + gold)
dbt test   --profiles-dir .       # run all data-quality tests
dbt docs generate --profiles-dir . && dbt docs serve --profiles-dir .  # browse docs + lineage
```

### Model layers

The dbt layers map directly onto the original medallion architecture:

| Original layer | dbt layer       | Path                    | Purpose                                            |
|----------------|-----------------|-------------------------|----------------------------------------------------|
| Bronze         | `seeds/`        | `dbt_project/seeds/`    | Raw ERP & CRM extracts, loaded verbatim from CSV   |
| Silver         | `staging/`      | `models/staging/`       | Cleansing, casting, standardisation (1:1 w/ source)|
| —              | `intermediate/` | `models/intermediate/`  | Business-logic joins (unify customers, products)   |
| Gold           | `marts/`        | `models/marts/`         | Star schema: `fct_sales`, `dim_customers`, `dim_products` |

### What dbt adds here

- **Models as SQL** — every transformation is a versioned, testable `.sql` file.
- **Dependency graph** — dbt resolves run order automatically (seed → staging → intermediate → marts).
- **Testing** — 38 tests run via `dbt test`: `not_null`, `unique`, `accepted_values`,
  `relationships` on every key, plus a custom `assert_positive_sales_amount` data check.
- **Documentation** — YAML descriptions on every model/column generate a browsable
  docs site with a full lineage graph (`dbt docs serve`).
- **Reusable macros** — e.g. `parse_yyyymmdd` for the integer-encoded sales dates.

### Lineage

```
seeds (bronze)            staging (silver)              marts (gold)
crm_cust_info   ─┐
erp_cust_az12   ─┼─► stg_* ─► int_customers__joined ─► dim_customers ─┐
erp_loc_a101    ─┘                                                    ├─► fct_sales
crm_prd_info    ─┐                                                    │
erp_px_cat_g1v2 ─┴─► stg_* ─► int_products__enriched ─► dim_products ─┘
crm_sales_details ─► stg_crm__sales_details ────────────────────────►┘
```

Run `dbt docs serve` to explore the interactive version.

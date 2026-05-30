# E-commerce Analytics — dbt + Snowflake

A real-world dbt project modelling e-commerce sales data using
the Snowflake TPC-H sample dataset.

## Project Structure

models/
├── staging/        # Light cleanup, 1-to-1 with source tables
├── intermediate/   # Business logic and joins
└── marts/          # Final analytics-ready tables

## Marts

| Model | Description | Rows |
|---|---|---|
| `fct_orders` | Core sales fact table, one row per order | ~1.5M |
| `dim_customers` | Customer dimension with RFM segmentation | ~150K |
| `mart_revenue_by_region` | Monthly revenue by region and nation | ~2K |

## Tech Stack
- **dbt Core** 1.11
- **Snowflake** (source: TPC-H sample dataset)
- **Python** virtual environment

## Setup

1. Clone the repo
2. Create and activate a virtual environment
3. Install dependencies: `pip install dbt-snowflake`
4. Configure `~/.dbt/profiles.yml` with your Snowflake credentials
5. Run: `dbt run && dbt test`

## Business Questions Answered

- Which regions and nations generate the most revenue?
- Who are our highest-value customers (Champion, Loyal, Big Spender)?
- What is the monthly order fulfillment rate?
- How long does it take to ship orders on average?
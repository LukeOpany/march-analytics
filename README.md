# March Analytics — dbt Project

A dbt project analysing sales performance using the TheLook Ecommerce public dataset in BigQuery. Built with dbt Fusion, connected to Google BigQuery, and visualised in Looker Studio.

---

## Overview

- ✅ Project setup
- ✅ Source registration
- ✅ Staging models
- ✅ Intermediate model
- ✅ Marts model
- ✅ Tests

---

## Project Overview

![Mind Map](images/mind_map.png)

---

## Dashboard

![Sales Performance Dashboard](images/sales_performance_dashboard.png)

---

## Tech Stack

| tool | purpose |
|---|---|
| dbt Fusion 2.0 | data transformation and modelling |
| Google BigQuery | data warehouse |
| Looker Studio | dashboard and visualisation |
| Python 3.11 | virtual environment |
| VSCode | development environment |

---

## Data Source

**BigQuery Public Dataset:** `bigquery-public-data.thelook_ecommerce`

| table | description |
|---|---|
| `orders` | order-level data including status and timestamps |
| `order_items` | individual line items with sale price per order |
| `products` | product catalog with category, brand and cost |
| `users` | customer data |
| `events` | user website activity |
| `inventory_items` | stock levels |
| `distribution_centers` | warehouse locations |

---

## Project Structure

```
march_analytics/
├── models/
│   ├── staging/
│   │   ├── sources.yml              # source definitions
│   │   ├── schema.yml               # tests and documentation
│   │   ├── stg_orders.sql           # cleaned orders
│   │   ├── stg_order_items.sql      # cleaned order items
│   │   └── stg_products.sql         # cleaned products
│   ├── intermediate/
│   │   └── int_orders_enriched.sql  # joined orders, items and products
│   └── marts/
│       └── mart_sales_performance.sql  # final sales metrics table
├── macros/
├── seeds/
├── dbt_project.yml
├── packages.yml
└── README.md
```

---

## Data Lineage

```
bigquery-public-data.thelook_ecommerce
    ├── orders          →  stg_orders
    ├── order_items     →  stg_order_items    →  int_orders_enriched  →  mart_sales_performance
    └── products        →  stg_products
```

---

## Materializations

| layer | type | reason |
|---|---|---|
| staging | view | lightweight, no storage cost |
| intermediate | view | lightweight, no storage cost |
| marts | table | fully materialised for fast dashboard queries |

---

## Tests

12 data quality tests are defined in `models/staging/schema.yml`:

| model | column | tests |
|---|---|---|
| `stg_orders` | `order_id` | unique, not_null |
| `stg_orders` | `user_id` | not_null |
| `stg_orders` | `status` | not_null, accepted_values |
| `stg_order_items` | `order_item_id` | unique, not_null |
| `stg_order_items` | `order_id` | not_null |
| `stg_order_items` | `sale_price` | not_null |
| `stg_products` | `product_id` | unique, not_null |

Run tests with:
```bash
./venv/bin/dbt test
```

---

## Getting Started

### Prerequisites
- Python 3.11
- dbt Fusion 2.0
- Google Cloud account with BigQuery access
- A service account key file with BigQuery permissions

### Setup

**1. Clone the repository**
```bash
git clone https://github.com/LukeOpany/march-analytics.git
cd march-analytics
```

**2. Create and activate a virtual environment**
```bash
python3.11 -m venv venv
source venv/bin/activate
```

**3. Install dbt-bigquery**
```bash
pip install dbt-bigquery
```

**4. Configure your profiles.yml**

Create `~/.dbt/profiles.yml` with the following:
```yaml
march_analytics:
  target: dev
  outputs:
    dev:
      type: bigquery
      method: service-account
      project: your-gcp-project-id
      dataset: dbt_march
      threads: 4
      keyfile: /path/to/your/service-account-key.json
      location: US
```

**5. Test the connection**
```bash
dbt debug
```

**6. Run the models**
```bash
dbt run
```

**7. Run tests**
```bash
./venv/bin/dbt test
```

---

## Key SQL Concepts Used

- CTEs (Common Table Expressions) for readable, modular SQL
- `{{ source() }}` macro to reference raw BigQuery tables
- `{{ ref() }}` macro to reference other dbt models
- `LEFT JOIN` to enrich order items with product and order details
- `date_trunc()` for time-based aggregations
- `NULLIF()` to safely handle division by zero
- Filtering out cancelled and returned orders for clean metrics

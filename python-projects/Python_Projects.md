# 🐍 Python Projects

> [← Back to Portfolio](../README.md)

---

## Project 1: Exploratory Data Analysis — Sales Analytics
*Tech stack:* pandas — data wrangling & merging · matplotlib/seaborn — static & statistical plots · numpy — numerical computations  
*Files:* [`Python_for_DA_Module_Task.ipynb`](Python_for_DA_Module_Task.ipynb) · [`data/`](google-collaboratory/data/) (countries.csv, events.csv, products.csv)

- **Goal:** Perform end-to-end EDA on a multi-table sales dataset (countries, orders, products) to uncover business insights.
- **Highlights:**
  - Data cleaning: handled ~6.2% missing country codes (filled as "Unknown" to preserve rows) and 2 missing unit values (filled with median); fixed date types, normalized string columns, removed duplicates, verified no anomalies (no loss-sales, no invalid ship dates).
  - Merged 3 tables into a unified DataFrame via foreign keys: `events → countries (alpha-3)` and `events → products (id)`.
  - Computed KPIs: 1330 orders, ~$502M total profit, 45 countries, 34% avg. margin.
  - Visualized revenue, cost, and profit by product category, geography, and sales channel (online vs offline).
  - Analyzed shipping delays by product category, country, and region; examined their correlation with profit.
  - Identified seasonal and weekday sales patterns using time-series and `day_name()` breakdowns.

---

## EDA Workflow

1. **Data Overview** — loaded 3 CSV tables, explored column types and shapes, identified foreign keys linking `events → countries (alpha-3)` and `events → products (id)`.
2. **Data Cleaning** — detected and filled missing values (6.2% in Country Code → "Unknown", 2 missing Units Sold → median); converted date columns to `datetime`, cast Units Sold to `int64`; stripped whitespace, normalized casing, removed exact duplicates.
3. **Anomaly Detection** — checked for loss-sales (`Unit Cost > Unit Price`), invalid ship dates (`Ship Date < Order Date`), and statistical outliers via boxplots — none found.
4. **Table Merging** — joined all 3 tables into a single DataFrame, dropped redundant columns, renamed for clarity.
5. **KPI Computation** — calculated total orders, revenue, cost, profit, average margin, and number of countries covered.
6. **Sales Analysis** — compared revenue, cost, and profit across product categories, regions/countries, and sales channels (online vs offline).
7. **Shipping Delay Analysis** — computed order-to-ship intervals; broken down by product category, country, and region.
8. **Profit vs Shipping Correlation** — aggregated and visualized whether longer shipping delays impact profit.
9. **Time-Series Analysis** — tracked sales dynamics over time by category, country, and region; identified key trends.
10. **Weekday & Seasonality Analysis** — analyzed sales by day of week using `day_name()`; assessed which products show seasonal patterns.
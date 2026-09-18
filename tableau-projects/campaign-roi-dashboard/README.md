# Campaign ROI Dashboard

> [← Tableau Projects](../Tableau_Projects.md)

---

### Task Context

A company develops mobile apps and buys traffic — paying ad networks for installs. To understand which campaigns are profitable and which are draining the budget, a marketing showroom is needed: a single table combining ad spend and the revenue those campaigns brought. Currently, the data sits in four separate tables with no links between them.

| Table | What's inside |
| ----- | ------------- |
| non_org_installs_report | app installs from ad sources |
| cost_table | ad spend |
| ad_revenue_raw | in-app ad revenue |
| in_app_events_report | subscriptions, purchases, and related events |

### Task

1. Build a marketing showroom — one table that shows which ad campaigns pay off and which don't.
2. Based on the showroom, create a Tableau dashboard with multiple visualizations at your discretion.
3. Describe the full calculation process in detail. Also, please send the SQL query you built.

---

### Processing Logic

[Read full SQL query →](sql/SQL_Query.md)

1. **UNION ALL** — all four tables are unified into a single structure and merged into one CTE `combined`
2. **Revenue attribution** via `advertising_id` — each user is linked to the campaign that acquired them
3. **GROUP BY** — aggregation by `day × app_id × media_source × campaign_id`
4. **Metric calculation** — ROAS, CPI, total revenue

---

## Metrics

### Core

| Metric | Formula | Description |
| ------ | ------- | ----------- |
| Cost (USD) | `SUM(cost_usd)` | Total campaign spend |
| Installs | `COUNT(DISTINCT advertising_id)` | Number of acquired users |
| Ad Revenue | `SUM(event_revenue_usd)` from `ad_revenue_raw` | In-app ad revenue |
| IAP Revenue | `SUM(event_revenue_usd)` from `in_app_events_report` | In-app purchase / subscription revenue |
| Total Revenue | Ad Revenue + IAP Revenue | Combined revenue |
| **ROAS** | Total Revenue / Cost | Return on ad spend (>1 = profitable) |
| **CPI** | Cost / Installs | Cost per install |

### Additional (calculated in Tableau)

| Metric | Formula | Description |
| ------ | ------- | ----------- |
| Overall ROAS | `SUM(total_revenue) / SUM(cost)` | Blended ROAS across all campaigns |
| Budget Share | `cost_usd / SUM(cost_usd)` | Campaign's share of total spend |

---

## Dashboard

[![performanceDashboard.png](img/performanceDashboard.png)](https://public.tableau.com/views/MarketingPerformanceDashboard_17884454116940/MarketingPerformanceDashboard?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

**[▶ View on Tableau Public](https://public.tableau.com/views/MarketingPerformanceDashboard_17884454116940/MarketingPerformanceDashboard?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)**

### Visualizations

| # | Sheet | Chart Type | What it shows |
| --- | ----- | ---------- | ------------- |
| 1 | KPI Cards | Text Object | Total Cost, Total Revenue, Overall ROAS, Total Installs |
| 2 | ROAS by Campaign | Horizontal Bar | Campaign profitability (log scale, reference line = 1.0) |
| 3 | Cost vs Revenue | Dual Axis Line | Daily spend vs revenue dynamics |
| 4 | Cost by Media Source | Horizontal Bar | Budget distribution across ad channels |
| 5 | CPI by Campaign | Horizontal Bar | Cost per install by campaign |

### Interactivity

- **Filters:** date range, app_id, media_source, campaign_name
- **Reference Line:** ROAS = 1.0 (break-even mark)
- **Logarithmic Axis:** for ROAS — smooths out anomalous campaign spikes
- **Color Encoding:** Red-Green (ROAS < 1 = red, > 1 = green)

---

## Key Insights

- Overall ROAS: **346%** — profitable position for June–July 2026
- Top ROAS campaigns: mc_fe944d1c (3.68), mc_a2e93e84 (2.65), mc_2c0c0430 (2.22)
- Lowest ROAS campaigns (still > 1): mc_b7e37028 (1.05), mc_a5da28b5 (1.08), mc_d8ff83e7 (1.16)
- Most expensive channel by CPI: googleadwords_int ($0.05)
- Recommendation: increase budget for mc_fe944d1c — highest return

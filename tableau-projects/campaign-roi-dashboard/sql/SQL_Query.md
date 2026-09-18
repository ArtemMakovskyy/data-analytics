# SQL Query — Marketing Showroom

> [← Back to Campaign ROI Dashboard](../README.md)

---

## Query Logic

The query merges 4 tables into a single showroom via `UNION ALL`, then aggregates data by `report_date × app_id × media_source × campaign_id`.

### Step 1: CTE `combined`

Each table is cast to a unified structure:

| Column | cost_table | non_org_installs_report | ad_revenue_raw | in_app_events_report |
| ------ | ---------- | ----------------------- | -------------- | -------------------- |
| cost_usd | yes | 0 | 0 | 0 |
| advertising_id | NULL | yes | NULL | NULL |
| ad_revenue_usd | 0 | 0 | yes | 0 |
| iap_revenue_usd | 0 | 0 | 0 | yes |

### Step 2: Final SELECT

- `REPLACE(COALESCE(NULLIF(...), 'Unattributed'), 'mock_campaign_', 'mc_')` — shortens campaign names
- `COUNT(DISTINCT advertising_id)` — unique user count (deduplicated installs)
- `SAFE_DIVIDE(...)` — safe division (returns NULL on divide-by-zero)

### Two Revenue Sources

Both `ad_revenue_raw` and `in_app_events_report` are included in `total_revenue_usd` because both are consequences of user acquisition through an ad campaign:

- **ad_revenue_raw** — passive revenue from in-app ads (user sees video/banner → app receives payment from advertiser)
- **in_app_events_report** — active revenue from purchases/subscriptions (user consciously pays)

Together they form the total campaign revenue. ROAS is calculated from both since both income channels stem from the user acquired by the ad campaign.

### Deduplication & Empty Values

- **Install deduplication:** `COUNT(DISTINCT advertising_id)` is used because duplicate rows can appear within a single day for the same user
- **Empty campaign names:** `COALESCE(NULLIF(MAX(campaign_name), ''), 'Unattributed')` replaces missing or blank campaign names with 'Unattributed', ensuring these rows remain visible in the dashboard instead of being lost during grouping

---

## SQL (BigQuery)

```sql
WITH
    combined AS (
        SELECT
            PARSE_DATE('%Y-%m-%d', date) AS report_date,
            app_id,
            media_source,
            campaign_id,
            campaign AS campaign_name,
            cost_usd,
            impressions,
            clicks,
            CAST(NULL AS STRING) AS advertising_id,
            0.0 AS ad_revenue_usd,
            0.0 AS iap_revenue_usd
        FROM `test_app_dataset.cost_table`

        UNION ALL

        SELECT
            DATE(install_date) AS report_date,
            app_id,
            media_source,
            campaign_id,
            campaign_name,
            0.0 AS cost_usd,
            0 AS impressions,
            0 AS clicks,
            advertising_id,
            0.0 AS ad_revenue_usd,
            0.0 AS iap_revenue_usd
        FROM `test_app_dataset.non_org_installs_report`

        UNION ALL

        SELECT
            DATE(event_date) AS report_date,
            app_id,
            media_source,
            campaign_id,
            campaign_name,
            0.0 AS cost_usd,
            0 AS impressions,
            0 AS clicks,
            CAST(NULL AS STRING) AS advertising_id,
            event_revenue_usd AS ad_revenue_usd,
            0.0 AS iap_revenue_usd
        FROM `test_app_dataset.ad_revenue_raw`

        UNION ALL

        SELECT
            DATE(event_date) AS report_date,
            app_id,
            media_source,
            campaign_id,
            campaign_name,
            0.0 AS cost_usd,
            0 AS impressions,
            0 AS clicks,
            CAST(NULL AS STRING) AS advertising_id,
            0.0 AS ad_revenue_usd,
            event_revenue_usd AS iap_revenue_usd
        FROM `test_app_dataset.in_app_events_report`
    )

SELECT
    report_date,
    app_id,
    media_source,
    campaign_id,
    REPLACE(
            COALESCE(
                    NULLIF(MAX(campaign_name), ''),
                    'Unattributed'),
            'mock_campaign_',
            'mc_') AS campaign_name,
    SUM(cost_usd) AS cost_usd,
    SUM(impressions) AS impressions,
    SUM(clicks) AS clicks,
    COUNT(DISTINCT advertising_id) AS installs_count,
    SUM(ad_revenue_usd) AS ad_revenue_usd,
    SUM(iap_revenue_usd) AS iap_revenue_usd,
    SUM(ad_revenue_usd) + SUM(iap_revenue_usd) AS total_revenue_usd,
    SAFE_DIVIDE(SUM(ad_revenue_usd) + SUM(iap_revenue_usd), SUM(cost_usd)) AS roas,
    SAFE_DIVIDE(SUM(cost_usd), COUNT(DISTINCT advertising_id)) AS cpi_usd
FROM combined
GROUP BY
    report_date,
    app_id,
    media_source,
    campaign_id
ORDER BY
    report_date,
    media_source,
    campaign_id;
```

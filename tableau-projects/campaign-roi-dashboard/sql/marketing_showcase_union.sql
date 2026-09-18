WITH
    combined AS (
        -- таблиця витрат
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

        -- таблиця інсталіцій
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

-- Дві таблиці з доходом, тому що мобільний додаток має два канали монетизації:
--
-- 1. ad_revenue_raw — дохід від реклами всередині додатку (користувач бачить відео/банер → додаток отримує гроші від рекламодавця)
--    Це пасивний дохід: користувач не платить, але генерує revenue переглядом реклами.
--
-- 2. in_app_events_report — дохід від покупок та підписок (користувач купує підписку або внутрішньоігровий товар)
--    Це активний дохід: користувач свідомо платить гроші.
--
-- Разом вони дають загальний дохід кампанії. ROAS рахується з обох, бо обидва канали
-- є наслідком залучення користувача через рекламну кампанію.

-- таблиця прибутку 1
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

-- таблиця прибутку 2
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

-- Фінальний запит
SELECT
    report_date,
    app_id,
    media_source,
    campaign_id,
    -- зменшую назву для оптимізації простору в дашборді
    REPLACE(
            COALESCE(
                    NULLIF(MAX(campaign_name), ''),
                    'Unattributed'),
            'mock_campaign_',
            'mc_') AS campaign_name,
    SUM(cost_usd) AS cost_usd,
    SUM(impressions) AS impressions,
    SUM(clicks) AS clicks,
    -- зустрічаються дублікати advertising_id в рамках дня, рахуємо кількість без повторних інсталяцій
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

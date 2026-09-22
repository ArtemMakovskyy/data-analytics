# SQL Query — A/B Test Session Metrics

> [← Back to A/B Testing](A-B_Testing.md)

Source file: [`data/ab_test_session_metrics.sql`](data/ab_test_session_metrics.sql)

---

## Query Logic

The query collects daily session metrics for the A/B test and returns them in one long-format table: one row per date × country × device × continent × channel × test × test_group × event_name.

### CTEs

| CTE | What it counts |
|-----|----------------|
| `session_info` | joins `DA.ab_test` (test assignment) with `DA.session` and `DA.session_params` — session context: date, geo, device, channel, test, test_group |
| `session_with_orders` | sessions that placed an order |
| `events` | number of each event (`page_view`, `add_payment_info`, …) per day and segment |
| `session` | total sessions |
| `account` | sessions that created a new account (via `DA.account_session`) |

### Final SELECT

All four CTEs are combined with `UNION ALL` into a single table with two metric columns:

- `event_name` — `session`, `session with orders`, `new account`, or a real event name
- `value` — the count for that day and segment

This long format is what both the CSV export (for Excel pivots) and the Tableau dashboard consume.

---

## SQL (BigQuery)

```sql
with session_info as (
    Select
        s.date,
        s.ga_session_id,
        sp.country,
        sp.device,
        sp.continent,
        sp.channel,
        ab.test,
        ab.test_group
    from `DA.ab_test` ab
             join `DA.session` s
                  on ab.ga_session_id = s.ga_session_id
             join `DA.session_params` sp
                  on sp.ga_session_id = ab.ga_session_id
),
     session_with_orders as (
         SELECT
             session_info.date,
             session_info.country,
             session_info.device,
             session_info.continent,
             session_info.channel,
             session_info.test,
             session_info.test_group,
             count(distinct o.ga_session_id) as session_with_orders
         From `DA.order` o
                  join session_info
                       on o.ga_session_id = session_info.ga_session_id
         group by
             session_info.date,
             session_info.country,
             session_info.device,
             session_info.continent,
             session_info.channel,
             session_info.test,
             session_info.test_group
     ),
     events as (
         Select
             session_info.date,
             session_info.country,
             session_info.device,
             session_info.continent,
             session_info.channel,
             session_info.test,
             session_info.test_group,
             sp.event_name,
             count(sp.ga_session_id) as event_cnt
         From `DA.event_params` sp
                  join session_info
                       on sp.ga_session_id = session_info.ga_session_id
         group by
             session_info.date,
             session_info.country,
             session_info.device,
             session_info.continent,
             session_info.channel,
             session_info.test,
             session_info.test_group,
             sp.event_name
     ),
     session as (
         Select
             session_info.date,
             session_info.country,
             session_info.device,
             session_info.continent,
             session_info.channel,
             session_info.test,
             session_info.test_group,
             count(distinct session_info.ga_session_id) as session_cnt
         from session_info
         group by
             session_info.date,
             session_info.country,
             session_info.device,
             session_info.continent,
             session_info.channel,
             session_info.test,
             session_info.test_group
     ),
     account as (
         Select
             session_info.date,
             session_info.country,
             session_info.device,
             session_info.continent,
             session_info.channel,
             session_info.test,
             session_info.test_group,
             count(distinct acs.ga_session_id) as new_account_cnt
         from `DA.account_session` acs
                  join session_info
                       on acs.ga_session_id = session_info.ga_session_id
         group by
             session_info.date,
             session_info.country,
             session_info.device,
             session_info.continent,
             session_info.channel,
             session_info.test,
             session_info.test_group
     )


Select
    session_with_orders.date,
    session_with_orders.country,
    session_with_orders.device,
    session_with_orders.continent,
    session_with_orders.channel,
    session_with_orders.test,
    session_with_orders.test_group,
    'session with orders' as event_name,
    session_with_orders.session_with_orders as value
From session_with_orders
union all
Select
    events.date,
    events.country,
    events.device,
    events.continent,
    events.channel,
    events.test,
    events.test_group,
    event_name,
    event_cnt as value
From events
union all
Select
    session.date,
    session.country,
    session.device,
    session.continent,
    session.channel,
    session.test,
    session.test_group,
    'session' as event_name,
    session_cnt as value
From session
union all
Select
    account.date,
    account.country,
    account.device,
    account.continent,
    account.channel,
    account.test,
    account.test_group,
    'new account' as event_name,
    new_account_cnt as value
From account
```

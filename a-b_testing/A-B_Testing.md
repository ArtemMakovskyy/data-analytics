# 🧪 A/B Testing

> [← Back to Portfolio](../README.md)

*Tech stack:* SQL (BigQuery) · Excel (pivots, z-test) · Tableau

**[▶ Open Live Dashboard](https://public.tableau.com/app/profile/artem.makovskyi/viz/ABTEST_17848154968170/ABtest)** · **[⬇ Download the workbook](https://drive.google.com/uc?export=download&id=15jZbn_S5cadXUCjm2huYjlBo4_fyCOZS)**

<img src="data/pic/tableau-dashboard.png" width="500" alt="A/B Test Tableau dashboard"/>

---

## What the dashboard shows

Results of an A/B test on web analytics data: 4 tests, each split into two groups 50/50 (Nov 2020 – Jan 2021).

- **Fairness check** — both groups have the same traffic composition by device, continent, country and channel, so the comparison is valid
- **Event comparison** — how many times each event (page_view, begin_checkout, add_payment_info, …) happened in Group 1 vs Group 2, in absolute numbers and in %
- **Filters** — date range, test number, continent, device, country, channel

---

## Excel Analysis

The workbook has three sheets:

| Sheet | Purpose |
| --- | --- |
| `bq-results-ab` | Raw long-format export from the BigQuery query — one row per date × segment × test × test_group × event |
| `Dashboard_research` | Pivot tables, traffic-balance checks, and the z-test / decision engine for the selected test |
| `research_conclusion` | Log comparing results across data pulls, plus a per-channel breakdown |

### Pivot tables & traffic balance

- **Event pivot** — counts of every event by group, with a *Relative Difference* column highlighting the biggest shifts.
- **Traffic-balance pivots** by device, country, continent and channel — check that both groups get a comparable mix.
- **Balance guardrail:** `MIN(group share) ≥ 40%` against a nominal 50/50 split. For the test below, actual split is 49% / 51% — within tolerance. This is a simple share threshold, not a formal SRM chi-square test.

<img src="data/pic/excel-pivots-and-charts.png" width="450" alt="Excel pivots, charts and slicers"/>

### PCM / SCM calculation

For two tracked metrics — **Primary Conversion Metric (PCM)** and **Secondary Conversion Metric (SCM)** — the sheet computes, per group: Conversion Rate (event ÷ session), 95% CI, and a two-proportion two-sided z-test p-value.

<img src="data/pic/abTestResultByEvent.png" width="400" alt="A/B test results by event"/>

| Metric | Group 1 | Group 2 | Rel. difference | p-value | Conclusion |
| --- | --- | --- | --- | --- | --- |
| **PCM:** add_payment_info / session | 4.09% | 4.96% | **+21.25%** | 1.6×10⁻⁶ | Group 2 is more successful |
| SCM: new account / session | 8.41% | 8.15% | −3.02% | 0.292 | No significant difference |

<img src="data/pic/conclusionTable.png" width="550" alt="Research table with PCM and SCM calculations"/>

### Automated decision rules

A rule block (`pcm1–pcm6`, `scm1–scm6`) turns the stats above into a plain-text verdict against two thresholds set in the test brief — PCM target lift ≥ **+7%**, SCM acceptable loss ≥ **−5%** — and outputs one of: *success*, *target not reached*, *B worse than A*, or *inconclusive*.

> **PCM:** SUCCESS — add_payment_info up 21.3% (target 7%, p < 0.001). Recommendation: roll out Group 2.
>
> **SCM:** INCONCLUSIVE — new account change of −3.0% is not significant (p = 0.292). Needs more data.

<img src="data/pic/conclusion.png" width="550" alt="Conclusion rules table"/>

### `research_conclusion` sheet

- Tracks the same PCM/SCM verdicts across two data pulls, to see how the result holds as the sample grows.
- Breaks the latest pull down **by channel** (Direct, Organic Search, Paid Search, Social Search, Undefined) — each channel gets its own PCM/SCM verdict and p-value.
- **Final verdict:** keep the test running on most channels (not enough data yet); stop for *organic search* (PCM regressed significantly, −19.5%); *undefined* needs a separate business call (PCM +51.9% but SCM loss of −19.4% exceeds the allowed threshold).

![conclusion_total.png](data/pic/conclusion_total.png)

---

## SQL query

Session metrics for the test are extracted from BigQuery with one query — [read the walkthrough and full SQL →](SQL_Query.md)

---

## Skills Demonstrated

`A/B Testing` `SQL (BigQuery)` `Z-test` `Confidence Intervals` `Excel PivotTables` `Decision Rules` `Segmentation` `Tableau`

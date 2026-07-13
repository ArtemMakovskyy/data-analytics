📈 Statistics & A/B Testing Guide
[← Back to Portfolio](../README.md)

**Interactive Decision Map for Statistical Analysis**  
A comprehensive 7-step methodology guide for moving from raw data to statistically sound conclusions. Built as an interactive HTML flowchart with embedded Python code snippets.

🔗 **[Click to view Interactive Guide →](https://artemmakovskyy.github.io/stats-map/)**  

---

### What It Covers
A complete decision tree for statistical analysis, structured as 7 sequential stages:

| # | Stage | Key Decisions |
|---|-------|---------------|
| 0 | **Overview Map** | Full pipeline visualization |
| 1 | **Outlier Detection** | IQR vs Z-score, when to remove vs keep |
| 2 | **Sampling Methods** | Random, stratified, systematic, cluster, bootstrap |
| 3 | **Normality & Significance** | Shapiro-Wilk, D'Agostino-Pearson, p-value interpretation |
| 4 | **Correlation Analysis** | Pearson vs Spearman vs Kendall |
| 5 | **A/B Testing** | t-test, Welch's, Mann-Whitney, Wilcoxon, ANOVA, Kruskal-Wallis, proportions tests |
| 6 | **Sample Size Calculation** | Power analysis, effect size, α/β trade-offs |

---

### Key Features
- **Interactive flowcharts** — click any block for detailed explanation
- **Methodological rigor** — correct handling of paired vs independent samples, variance equality checks, non-parametric alternatives
- **Ready-to-use Python code** — `scipy.stats`, `statsmodels`, `pingouin` snippets
- **Business-oriented** — includes sample size planning with budget/timeline constraints

---

### Why This Matters
Most statistical guides oversimplify test selection. This map addresses real-world complexity:
- Paired t-test checks normality of **differences**, not groups
- Welch's t-test/ANOVA for unequal variances (common in real data)
- Games-Howell post-hoc test for Welch's ANOVA
- Fisher's Exact Test for small sample proportions
- Explicit independence assumptions for ANOVA

---

### Tech Stack
`HTML/CSS/JS` · `Python` (scipy, statsmodels, pingouin) · Statistical methodology

---

### Skills Demonstrated
- Experimental design & hypothesis testing
- Statistical assumptions validation
- A/B testing methodology
- Data-driven decision making
- Technical documentation & visualization
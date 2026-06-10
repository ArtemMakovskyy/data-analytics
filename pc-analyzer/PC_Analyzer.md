# 🖥️ PC Analyzer — Price-to-Performance Analytics Pipeline

> [← Back to Portfolio](../README.md)

*Tech stack:* Java 17 · Spring Boot · MySQL · Jsoup · Selenium · Apache POI · Excel

**Repo:** [GitHub](https://github.com/ArtemMakovskyy/pc_analyzer) · **Sample Report:** - [Link to download pc_configuration 2025-02-09 11-53.zip](https://drive.google.com/file/d/1Qc3C0PZnqo7e8zi6-J41b7_4LBnkwig-/view?usp=sharing)


---

## Goal

Automate the collection, normalization, and analysis of PC hardware data to find the most cost-efficient build configurations available on the Ukrainian market. The output is a ranked Excel report where every configuration is scored by **cost per FPS (₴/FPS)** — a single metric that answers: *which build gives the most performance per hryvnia?*

---

## What the Pipeline Does

```
Hotline.ua (prices)          UserBenchmark.com (benchmarks)
      │                                  │
      ▼                                  ▼
  Jsoup scraper                  Selenium scraper
  (multi-threaded)               (bot protection bypass)
      │                                  │
      └──────────────┬───────────────────┘
                     ▼
          Name normalization & matching
          (longest-to-shortest model sync)
                     ▼
          Compatibility filtering
          (socket, chipset, DDR, PSU wattage)
                     ▼
          Metric calculation
          (predicted FPS, ₴/FPS)
                     ▼
          Ranked Excel report
          (BEST_PRICE labels, color formatting)
```

### Data collected

| Category | Source | Key fields |
|----------|--------|------------|
| CPU | Hotline + UserBenchmark | Price, socket, gaming/desktop/workstation score, cores, threads |
| GPU | Hotline + UserBenchmark | Price, VRAM, PCIe, avg benchmark, power requirement |
| Motherboard | Hotline | Price, socket, chipset, DDR type, form factor |
| RAM | Hotline | Price, DDR type, capacity, frequency |
| SSD | Hotline | Price, type, capacity, read/write speed |
| PSU | Hotline | Price, wattage, standard, connectors |

---

## Key Metrics & Calculations

```
avgPrice         = min((min + max) / 2,  min × 1.15)   # conservative price estimate
predictionFPS    = gamingScore × avgGpuBench / 100      # predicted FPS at Full HD
pricePerFPS      = totalBuildPrice / predictionFPS      # cost-efficiency metric (₴/FPS)
```

Builds with lower FPS *and* higher price than another build are removed as non-competitive. The most cost-efficient remaining builds are labelled `BEST_PRICE`.

---

## Excel Report — Analytics Capabilities

The output file is structured for immediate analytical use in Excel:

- **Cost-efficiency ranking** — sort by ₴/FPS to find the best value at any budget.
- **Budget filtering** — filter by Price column to see all builds under a target (e.g. ₴30,000).
- **Component contribution analysis** — Gaming Score (CPU) and Avg Bench (GPU) columns let you assess which component is the bottleneck.
- **Bottleneck detection** — compare CPU Gaming Score vs GPU Avg Bench ratio across builds.
- **Custom slicing** — built-in AutoFilter allows filtering by any column: specific CPU, GPU, price range, or FPS target.
- **Visual highlights** — `BEST_PRICE` rows are colour-coded for instant identification.

### Completed Analytical Work

The Excel report was analysed using Excel PivotTables, charts, and formulas. All insights are derived from the existing dataset.

- **Price vs FPS scatter plot** — shows a positive correlation with a clear diminishing-returns plateau; the `BEST_PRICE` builds cluster in the optimal ₴/FPS zone before the curve flattens.
- **Top efficient builds** — the top 10 most efficient configurations all fall within ₴45k–₴65k and share the Intel Core i5-14600KF (9 of 10 builds), paired primarily with an RTX 4070 Ti SUPER. The single best build achieves 310 FPS at ₴197/frame.
- **Budget-optimized builds (₴25k–₴30k)** — Intel Core i3 processors dominate in this segment, with AMD's RX 6700 XT outperforming the RTX 4060 on value. The most efficient budget build delivers 222 ₴/FPS at ₴25,334.
- **CPU Performance PivotTable** — aggregates average FPS, price per FPS, and Gaming Score per processor. The i5-14600KF leads at ₴215.50/FPS among CPUs with Gaming Score > 120; no AMD CPU breaks the ₴250/FPS barrier.
- **GPU Performance PivotTable** — the RTX 4070 Ti leads at ₴212/FPS, with AMD's RX 7900 XT as the closest competitor. In the budget segment, AMD's RX 6700 XT clearly beats the RTX 4060.
- **Excel automation** — the report ships with `BEST_PRICE` filtering formulas, budget segmentation helpers, and formatted sheets (frozen headers, conditional formatting, colour-coded best builds).

---

## Compatibility Logic

| Check | Rule |
|-------|------|
| CPU ↔ Motherboard | Socket match + chipset logic (K-series → Z, X-series → X, others → B) |
| Motherboard ↔ RAM | DDR type match (DDR4 / DDR5) |
| GPU ↔ PSU | Cheapest PSU where wattage ≥ GPU power requirement |

---

## Skills Demonstrated

`ETL Pipeline` `Web Scraping` `Data Normalization & Matching` `Metric Design` `Excel Reporting` `Multi-threaded Processing` `Compatibility Logic`

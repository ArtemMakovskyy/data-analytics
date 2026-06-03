# 📂 SQL Projects

> [← Back to Portfolio](../README.md)

---

## Project 1: Web Analytics SQL Playground
*Tech:* PostgreSQL 17, Spring Boot 3.3, Liquibase, Docker, DataFaker

A hands-on SQL practice project built around simulated web analytics data — user sessions, events, A/B tests, email funnels, and orders. The full environment spins up in one command via Docker Compose and auto-generates realistic data on first run, so you can start writing queries immediately.

- **Goal:** Demonstrate practical SQL skills across 13 normalized tables and 15+ query files covering the full spectrum from basic JOINs to advanced window functions and CTEs.
- **Highlights:**
  - Designed a 13-table schema with 1:1, 1:M, and M:N relationships modeling real-world web analytics (sessions → events → orders, email sent → open → visit funnel).
  - Wrote 15 SQL files covering `JOIN`, `CASE WHEN`, `UNION`, subqueries, window functions (`ROW_NUMBER`, `LAG`, `RANK`), CTEs, VIEWs, and temp tables.
  - Built a full REST API (CRUD) for all entities using Spring Boot + JPA + MapStruct.
  - Used Liquibase for 13 versioned DDL migrations and DataFaker for generating 2000+ sessions, A/B test groups, email campaigns, and order histories.
- **Repo:** [GitHub](https://github.com/ArtemMakovskyy/sql-extra)

---

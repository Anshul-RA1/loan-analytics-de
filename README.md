# loan-analytics-de

**Status:** Week 1 — Phase 1 In Progress  
**Database:** PostgreSQL (Supabase)  
**Project:** End-to-end Credit Risk Analysis — German Market  

---

## Project Overview
A complete credit risk analysis pipeline built to demonstrate
professional-grade data engineering, SQL analysis, Python data
science, Power BI reporting, and machine learning — targeting
Risk Data Analyst roles at German financial institutions.

## Tech Stack
| Tool | Purpose |
|---|---|
| PostgreSQL (Supabase) | Database & SQL analysis |
| Python — Pandas | Data manipulation & profiling |
| Python — Matplotlib / Seaborn | Data visualisation & charts |
| Python — Scikit-learn / XGBoost | Credit default ML model |
| Python — SHAP | Model explainability |
| Jupyter Notebook | Documented analysis environment |
| Power BI | Executive risk dashboard |
| GitHub | Version control & portfolio |

---

## Phase 1 — Data Engineering (Weeks 1–2)
- [x] loan_table schema — 11 columns
- [x] 100,000 row data generation (correlated, reproducible)
- [x] 5 verification checks — all passed
- [x] Data quality issue identified and fixed (On-Time standardisation)
- [ ] DTI column
- [ ] CTE deep dive queries
- [ ] Schema documentation

## Phase 2 — Exploratory Data Analysis in SQL (Weeks 3–5)
- [ ] Default rate by loan type, region, age group
- [ ] DPD bucket analysis — IFRS 9 Stage classification
- [ ] DTI vs default correlation proof
- [ ] NPL ratio calculation
- [ ] Window function portfolio — RANK, NTILE, LAG
- [ ] Portfolio KPI summary

## Phase 3 — Python Analysis & Visualisation (Weeks 6–7)
- [ ] PostgreSQL → Python connection via psycopg2
- [ ] Pandas data profiling — 100K rows
- [ ] Feature engineering — DTI bucket, age group, is_defaulted
- [ ] Matplotlib / Seaborn chart suite
- [ ] Correlation heatmap — feature vs default relationship

## Phase 4 — Power BI Dashboard (Week 8)
- [ ] Portfolio overview page — KPI cards
- [ ] Risk breakdown page — default by region and loan type
- [ ] Customer watchlist page — top 50 highest risk
- [ ] Published Power BI Service URL

## Phase 5 — Credit Default ML Model (Weeks 9–10)
- [ ] Logistic Regression baseline model
- [ ] XGBoost high-performance model
- [ ] AUC-ROC and Gini coefficient evaluation
- [ ] SHAP explainability — regulatory compliance layer
- [ ] Final Jupyter Notebook — full documented pipeline

---

## Repository Structure
```
loan-analytics-de/
│
├── README.md
├── phase1_data_engineering/
│   └── week1_loan_table_complete.sql
├── phase2_eda/
│   └── (coming Week 3)
├── phase3_python_analysis/
│   └── (coming Week 6)
├── phase4_powerbi/
│   └── (coming Week 8)
└── phase5_ml_model/
    └── (coming Week 9)
```

-- ============================================================
--  RISK DATA ANALYST PROJECT — Week 1, Day 2
--  File: week1_cte_analysis.sql
--  Phase: 1 — Data Engineering
--  Topic: CTE (Common Table Expression) Deep Dive
--  Author: Anshul
-- ============================================================

-- ────────────────────────────────────────────────────────────
-- CTE 1: Regional Default Rate Analysis
-- Business Question: Which regions have default rate > 5%?
-- Key Learning: HAVING filters on calculated aggregates
--               WHERE cannot do this
-- ────────────────────────────────────────────────────────────

WITH default_counts AS (
    SELECT
        region,
        COUNT(*) AS defaulted_loans
    FROM loan_table
    WHERE loan_status = 'Defaulted'
    GROUP BY region
),
total_defaults AS (
    SELECT COUNT(*) AS grand_total
    FROM loan_table
    WHERE loan_status = 'Defaulted'
)
  
SELECT
    d.region,
    d.defaulted_loans,
    t.grand_total,
    ROUND(100.0 * d.defaulted_loans / t.grand_total, 2) AS pct_of_total_defaults
FROM default_counts d
CROSS JOIN total_defaults t
ORDER BY d.defaulted_loans DESC;
-- RESULT: Brandenburg 13.10%, Berlin 13.04%, Sachsen 12.94%


-- ────────────────────────────────────────────────────────────
-- CTE 2: Regional DTI vs Portfolio Average
-- Business Question: Which regions carry above-average
--                    Debt-to-Income burden?
-- DTI = Debt-to-Income Ratio = loan_amount / income
-- Key Learning: Never round before calculating differences.
--               Precision matters in risk analysis.
-- ────────────────────────────────────────────────────────────

WITH regional_dti AS (
    SELECT
        region,
        ROUND(AVG(loan_amount / income), 4) AS avg_dti
    FROM loan_table
    GROUP BY region
),
portfolio_avg AS (
    SELECT
        ROUND(AVG(loan_amount / income), 4) AS overall_avg_dti
    FROM loan_table
)
  
SELECT
    r.region,
    r.avg_dti,
    p.overall_avg_dti,
    ROUND(r.avg_dti - p.overall_avg_dti, 4) AS difference,
    CASE
        WHEN r.avg_dti > p.overall_avg_dti
        THEN 'Above Average — Higher Risk'
        ELSE 'Below Average — Lower Risk'
    END AS risk_flag
FROM regional_dti r
CROSS JOIN portfolio_avg p
ORDER BY r.avg_dti DESC;
-- RESULT: Sachsen highest DTI (23.0315), Bayern lowest (22.5112)
-- INSIGHT: Narrow spread suggests independent data generation.

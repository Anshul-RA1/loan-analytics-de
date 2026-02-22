-- ============================================================
--  RISK DATA ANALYST PROJECT
--  File: week1_loan_table_complete.sql
--  Phase: 1 — Data Engineering
--  Week: 1 | Author: Anshul Raghuvanshi
--  Description: Complete loan_table setup — schema creation,
--               100K row data generation, and 5 verification
--               checks with expected outputs documented
-- ============================================================


-- ────────────────────────────────────────────────────────────
-- PART 1: DROP & CREATE TABLE
-- ────────────────────────────────────────────────────────────

DROP TABLE IF EXISTS loan_table;

CREATE TABLE loan_table (
    customer_id       VARCHAR        PRIMARY KEY,
    age               INT,
    gender            VARCHAR(1),
    income            NUMERIC,
    loan_id           VARCHAR,
    loan_amount       NUMERIC,
    loan_type         VARCHAR,
    loan_status       VARCHAR,
    repayment_status  VARCHAR,
    region            VARCHAR,
    dpd               INT
);


-- ────────────────────────────────────────────────────────────
-- PART 2: DATA GENERATION — 100,000 ROWS
-- Note: setseed(0.42) ensures same data every run
-- ────────────────────────────────────────────────────────────

SELECT setseed(0.42);

INSERT INTO loan_table (
    customer_id, age, gender, income,
    loan_id, loan_amount, loan_type,
    loan_status, repayment_status, region, dpd
)
WITH base AS (
    SELECT
        gs,
        (20 + floor(random() * 45))::int                              AS age,
        CASE WHEN random() < 0.5 THEN 'M' ELSE 'F' END               AS gender,
        (2000  + floor(random() * 8000))::numeric                     AS income,
        (3000  + floor(random() * 22000))::numeric                    AS loan_amount,
        (ARRAY['Personal','Home','Auto','Education'])
            [floor(random() * 4) + 1]                                 AS loan_type,
        (ARRAY['Bayern','Berlin','Hamburg','Hessen',
               'NRW','Baden-Württemberg','Sachsen','Brandenburg'])
            [floor(random() * 8) + 1]                                 AS region,
        random()                                                       AS r_status
    FROM generate_series(1, 100000) AS gs
),
with_status AS (
    SELECT *,
        CASE
            WHEN r_status < 0.05 THEN 'Defaulted'
            WHEN r_status < 0.20 THEN 'Late'
            WHEN r_status < 0.40 THEN 'Closed'
            ELSE                      'Active'
        END AS loan_status
    FROM base
)
SELECT
    'C' || lpad(gs::text, 6, '0')   AS customer_id,
    age,
    gender,
    income,
    'L' || lpad(gs::text, 6, '0')   AS loan_id,
    loan_amount,
    loan_type,
    loan_status,
    CASE loan_status
        WHEN 'Defaulted' THEN
            CASE WHEN random() < 0.90 THEN 'Missed'   ELSE 'Settled'  END
        WHEN 'Late'      THEN
            CASE WHEN random() < 0.70 THEN 'Late'     ELSE 'Missed'   END
        WHEN 'Closed'    THEN
            CASE WHEN random() < 0.80 THEN 'On-Time'  ELSE 'Settled'  END
        ELSE
            CASE WHEN random() < 0.85 THEN 'On-Time'  ELSE 'Late'     END
    END AS repayment_status,
    region,
    CASE loan_status
        WHEN 'Active'    THEN 0
        WHEN 'Late'      THEN (30  + floor(random() * 60))::int
        WHEN 'Defaulted' THEN (90  + floor(random() * 276))::int
        WHEN 'Closed'    THEN 0
    END AS dpd
FROM with_status
ORDER BY gs;


-- ────────────────────────────────────────────────────────────
-- PART 3: VERIFICATION CHECKS (Run after INSERT completes)
-- ────────────────────────────────────────────────────────────

-- CHECK 1: Total row count — must be exactly 100,000
SELECT COUNT(*) AS total_rows
FROM loan_table;
-- EXPECTED: 100000 | ACTUAL: 100000 ✅

-- CHECK 2: loan_status distribution
-- Expected: Active ~60%, Closed ~20%, Late ~15%, Defaulted ~5%
SELECT
    loan_status,
    COUNT(*)                                                    AS count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1)          AS pct
FROM loan_table
GROUP BY loan_status
ORDER BY count DESC;
-- EXPECTED: Active 59-61% | Closed 19-21% | Late 14-16% | Defaulted 4-6%
-- ACTUAL  : Active 59.9%  | Closed 20.0%  | Late 15.0%  | Defaulted 5.1% ✅

-- CHECK 3: Regional spread — should be ~12,500 per region
SELECT
    region,
    COUNT(*)                    AS total_customers,
    ROUND(AVG(income), 0)       AS avg_income,
    ROUND(AVG(loan_amount), 0)  AS avg_loan
FROM loan_table
GROUP BY region
ORDER BY total_customers DESC;
-- EXPECTED: All regions between 10,000 and 16,000 rows
-- ACTUAL  : Range 12,315 to 12,786 ✅

-- CHECK 4: DPD correlation with loan_status
-- Active/Closed must be 0. Late must be 30-89. Defaulted must be 90-365.
SELECT
    loan_status,
    MIN(dpd)             AS min_dpd,
    MAX(dpd)             AS max_dpd,
    ROUND(AVG(dpd), 1)   AS avg_dpd
FROM loan_table
GROUP BY loan_status
ORDER BY avg_dpd DESC;
-- EXPECTED: Defaulted 90-365 | Late 30-89 | Active 0 | Closed 0
-- ACTUAL  : Defaulted avg 228.2 | Late avg 59.7 | Active 0 | Closed 0 ✅

-- CHECK 5: repayment_status correlation with loan_status
SELECT
    loan_status,
    repayment_status,
    COUNT(*) AS count
FROM loan_table
GROUP BY loan_status, repayment_status
ORDER BY loan_status, count DESC;
Week 1 Day 1: Complete loan_table setup — schema, 100K rows, 5 verification checks

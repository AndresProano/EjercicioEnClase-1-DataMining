-- ============================================================
-- CAPA GOLD
-- ============================================================

USE DATABASE EXERCISE_1;
CREATE SCHEMA IF NOT EXISTS GOLD_TPCH;
USE SCHEMA GOLD_TPCH;

-- ============================================================
-- DIM_DATE
-- ============================================================
CREATE OR REPLACE TABLE DIM_DATE (
    DATE_KEY    NUMBER      NOT NULL,
    FULL_DATE   DATE        NOT NULL,
    YEAR        NUMBER      NOT NULL,
    MONTH       NUMBER      NOT NULL,
    MONTH_NAME  VARCHAR(10) NOT NULL,
    PRIMARY KEY (DATE_KEY)
);

INSERT INTO DIM_DATE
SELECT
    TO_NUMBER(TO_CHAR(datum, 'YYYYMMDD'))   AS DATE_KEY,
    datum                                    AS FULL_DATE,
    YEAR(datum)                              AS YEAR,
    MONTH(datum)                             AS MONTH,
    MONTHNAME(datum)                         AS MONTH_NAME
FROM (
    SELECT DATEADD('day', seq4(), '1992-01-01'::DATE) AS datum
    FROM TABLE(GENERATOR(ROWCOUNT => 2557))  -- 1992-01-01 a 1998-12-31
)
WHERE datum <= '1998-12-31'::DATE;

-- ============================================================
-- DIM_CUSTOMER
-- ============================================================
CREATE OR REPLACE TABLE DIM_CUSTOMER AS
SELECT
    C.C_CUSTKEY      AS CUSTOMER_KEY,
    C.C_NAME         AS CUSTOMER_NAME,
    N.N_NAME         AS NATION_NAME,
    R.R_NAME         AS REGION_NAME
FROM RAW_TPCH.RAW_CUSTOMER   C
JOIN RAW_TPCH.RAW_NATION     N ON C.C_NATIONKEY = N.N_NATIONKEY
JOIN RAW_TPCH.RAW_REGION     R ON N.N_REGIONKEY = R.R_REGIONKEY;

-- ============================================================
-- DIM_PART
-- ============================================================
CREATE OR REPLACE TABLE DIM_PART AS
SELECT
    P.P_PARTKEY  AS PART_KEY,
    P.P_BRAND    AS BRAND,
    P.P_MFGR     AS MANUFACTURER
FROM RAW_TPCH.RAW_PART P;

-- ============================================================
-- FACT_SALES
-- ============================================================
-- Se demora aprox 40 minutos en un WH(X-Small)

CREATE OR REPLACE TABLE FACT_SALES AS
SELECT
    TO_NUMBER(TO_CHAR(O.O_ORDERDATE, 'YYYYMMDD'))      AS DATE_KEY,
    O.O_CUSTKEY                                         AS CUSTOMER_KEY,
    L.L_PARTKEY                                         AS PART_KEY,
    L.L_SHIPMODE                                        AS SHIP_MODE,
    L.L_QUANTITY                                        AS QUANTITY,
    L.L_EXTENDEDPRICE                                   AS EXTENDED_PRICE,
    L.L_DISCOUNT                                        AS DISCOUNT,
    ROUND(L.L_EXTENDEDPRICE * (1 - L.L_DISCOUNT), 2)   AS NET_REVENUE,
    DATEDIFF('day', O.O_ORDERDATE, L.L_SHIPDATE)        AS DISPATCH_DAYS
FROM RAW_TPCH.RAW_LINEITEM  L
JOIN RAW_TPCH.RAW_ORDERS    O ON L.L_ORDERKEY = O.O_ORDERKEY;

-- Clustering key para optimizar queries por fecha y cliente
ALTER TABLE FACT_SALES CLUSTER BY (DATE_KEY, CUSTOMER_KEY);

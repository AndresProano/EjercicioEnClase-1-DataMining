-- ============================================================
-- CAPA RAW — Vistas sobre SNOWFLAKE_SAMPLE_DATA
-- ============================================================

USE DATABASE EXERCISE_1;
CREATE SCHEMA IF NOT EXISTS RAW_TPCH;
USE SCHEMA RAW_TPCH;

-- ─────────────────────────────────────────────────────────────
-- LINEITEM (para el fact)
-- ─────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW RAW_LINEITEM AS
SELECT
    L_ORDERKEY,
    L_PARTKEY,
    L_QUANTITY,
    L_EXTENDEDPRICE,
    L_DISCOUNT,
    L_SHIPDATE,
    L_SHIPMODE
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.LINEITEM;

-- ─────────────────────────────────────────────────────────────
-- ORDERS (para agregar al fact la fecha y cliente)
-- ─────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW RAW_ORDERS AS
SELECT
    O_ORDERKEY,
    O_CUSTKEY,
    O_ORDERDATE
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.ORDERS;

-- ─────────────────────────────────────────────────────────────
-- CUSTOMER (para DIM_CUSTOMER)
-- ─────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW RAW_CUSTOMER AS
SELECT
    C_CUSTKEY,
    C_NAME,
    C_NATIONKEY
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.CUSTOMER;

-- ─────────────────────────────────────────────────────────────
-- NATION (para DIM_CUSTOMER)
-- ─────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW RAW_NATION AS
SELECT
    N_NATIONKEY,
    N_NAME,
    N_REGIONKEY
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.NATION;

-- ─────────────────────────────────────────────────────────────
-- REGION (para DIM_CUSTOMER)
-- ─────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW RAW_REGION AS
SELECT
    R_REGIONKEY,
    R_NAME
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.REGION;

-- ─────────────────────────────────────────────────────────────
-- PART (para DIM_PART)
-- ─────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW RAW_PART AS
SELECT
    P_PARTKEY,
    P_BRAND,
    P_MFGR
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.PART;

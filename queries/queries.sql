-- ============================================================
-- QUERIES
-- ============================================================
USE DATABASE EXERCISE_1;
USE SCHEMA GOLD_TPCH;

-- ─────────────────────────────────────────────────────────────
-- Q1:
-- ¿Cómo evolucionó el revenue neto por mes y región del cliente?
-- ─────────────────────────────────────────────────────────────
SELECT
    C.REGION_NAME,
    D.YEAR,
    D.MONTH,
    D.MONTH_NAME,
    SUM(F.NET_REVENUE)      AS TOTAL_NET_REVENUE
FROM FACT_SALES          F
JOIN DIM_DATE            D ON F.DATE_KEY = D.DATE_KEY
JOIN DIM_CUSTOMER        C ON F.CUSTOMER_KEY = C.CUSTOMER_KEY
GROUP BY C.REGION_NAME, D.YEAR, D.MONTH, D.MONTH_NAME
ORDER BY C.REGION_NAME, D.YEAR, D.MONTH;

-- ─────────────────────────────────────────────────────────────
-- Q2:
-- ¿Quiénes son los 10 clientes con mayor revenue neto en 1996
-- y cuál es su región?
-- ─────────────────────────────────────────────────────────────
SELECT
    C.CUSTOMER_KEY,
    C.CUSTOMER_NAME,
    C.NATION_NAME,
    C.REGION_NAME,
    SUM(F.NET_REVENUE)      AS TOTAL_NET_REVENUE
FROM FACT_SALES          F
JOIN DIM_DATE            D ON F.DATE_KEY = D.DATE_KEY
JOIN DIM_CUSTOMER        C ON F.CUSTOMER_KEY = C.CUSTOMER_KEY
WHERE D.YEAR = 1996
GROUP BY C.CUSTOMER_KEY, C.CUSTOMER_NAME, C.NATION_NAME, C.REGION_NAME
ORDER BY TOTAL_NET_REVENUE DESC
LIMIT 10;

-- ─────────────────────────────────────────────────────────────
-- Q3:
-- ¿Qué brands y manufacturers generan más revenue neto y
-- cuántas unidades vendieron?
-- ─────────────────────────────────────────────────────────────
SELECT
    P.MANUFACTURER,
    P.BRAND,
    SUM(F.NET_REVENUE)     AS TOTAL_NET_REVENUE,
    SUM(F.QUANTITY)        AS TOTAL_UNITS_SOLD
FROM FACT_SALES         F
JOIN DIM_PART           P ON F.PART_KEY = P.PART_KEY
GROUP BY P.MANUFACTURER, P.BRAND
ORDER BY TOTAL_NET_REVENUE DESC;

-- ─────────────────────────────────────────────────────────────
-- Q4:
-- ¿Qué regiones presentan mayor descuento promedio y cómo
-- se relaciona con el revenue neto total?
-- ─────────────────────────────────────────────────────────────
SELECT
    C.REGION_NAME,
    ROUND(AVG(F.DISCOUNT), 4)   AS AVG_DISCOUNT,
    SUM(F.NET_REVENUE)           AS TOTAL_NET_REVENUE,
    SUM(F.EXTENDED_PRICE)        AS TOTAL_GROSS_REVENUE,
    ROUND(SUM(F.EXTENDED_PRICE) - SUM(F.NET_REVENUE), 2) AS TOTAL_DISCOUNT_AMOUNT
FROM FACT_SALES          F
JOIN DIM_CUSTOMER        C ON F.CUSTOMER_KEY = C.CUSTOMER_KEY
GROUP BY C.REGION_NAME
ORDER BY AVG_DISCOUNT DESC;

-- ─────────────────────────────────────────────────────────────
-- Q5:
-- ¿Cuál es el tiempo promedio de despacho por SHIP_MODE
-- y cuál mueve más volumen?
-- ─────────────────────────────────────────────────────────────
SELECT
    F.SHIP_MODE,
    ROUND(AVG(F.DISPATCH_DAYS), 2)  AS AVG_DISPATCH_DAYS,
    SUM(F.QUANTITY)                  AS TOTAL_VOLUME,
    COUNT(*)                         AS TOTAL_SHIPMENTS
FROM FACT_SALES F
GROUP BY F.SHIP_MODE
ORDER BY TOTAL_VOLUME DESC;

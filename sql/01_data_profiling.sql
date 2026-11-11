-- Database: ecommerce_profitability

-- DROP DATABASE IF EXISTS ecommerce_profitability;

CREATE DATABASE ecommerce_profitability
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_India.1252'
    LC_CTYPE = 'English_India.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;


DROP TABLE samplesuperstore;

ALTER TABLE sample
ALTER COLUMN "Order Date" TYPE DATE 
USING TO_DATE("Order Date", 'MM/DD/YYYY');

ALTER TABLE sample
ALTER COLUMN "Ship Date" TYPE DATE 
USING TO_DATE("Ship Date", 'MM/DD/YYYY');

SELECT
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'sample'
ORDER BY ordinal_position;

SELECT *
FROM public.sample
LIMIT 10;


SELECT COUNT(*) AS total_rows
FROM public.sample; 

SELECT
    COUNT(*) FILTER (WHERE "Row ID" IS NULL) AS missing_row_id,
    COUNT(*) FILTER (WHERE "Order ID" IS NULL) AS missing_order_id,
    COUNT(*) FILTER (WHERE "Order Date" IS NULL) AS missing_order_date,
    COUNT(*) FILTER (WHERE "Ship Date" IS NULL) AS missing_ship_date,
    COUNT(*) FILTER (WHERE "Ship Mode" IS NULL) AS missing_ship_mode,
    COUNT(*) FILTER (WHERE "Customer ID" IS NULL) AS missing_customer_id,
    COUNT(*) FILTER (WHERE "Customer Name" IS NULL) AS missing_customer_name,
    COUNT(*) FILTER (WHERE "Segment" IS NULL) AS missing_segment,
    COUNT(*) FILTER (WHERE "Country" IS NULL) AS missing_country,
    COUNT(*) FILTER (WHERE "City" IS NULL) AS missing_city,
    COUNT(*) FILTER (WHERE "State" IS NULL) AS missing_state,
    COUNT(*) FILTER (WHERE "Postal Code" IS NULL) AS missing_postal_code,
    COUNT(*) FILTER (WHERE "Region" IS NULL) AS missing_region,
    COUNT(*) FILTER (WHERE "Product ID" IS NULL) AS missing_product_id,
    COUNT(*) FILTER (WHERE "Category" IS NULL) AS missing_category,
    COUNT(*) FILTER (WHERE "Sub-Category" IS NULL) AS missing_sub_category,
    COUNT(*) FILTER (WHERE "Product Name" IS NULL) AS missing_product_name,
    COUNT(*) FILTER (WHERE "Sales" IS NULL) AS missing_sales,
    COUNT(*) FILTER (WHERE "Quantity" IS NULL) AS missing_quantity,
    COUNT(*) FILTER (WHERE "Discount" IS NULL) AS missing_discount,
    COUNT(*) FILTER (WHERE "Profit" IS NULL) AS missing_profit
FROM public.sample;

SELECT
    column_name,
    SUM(missing_count) AS missing_count
FROM (
    SELECT
        v.column_name,
        v.missing_count
    FROM public.sample s
    CROSS JOIN LATERAL (
        VALUES
            ('Row ID', CASE WHEN "Row ID" IS NULL THEN 1 ELSE 0 END),
            ('Order ID', CASE WHEN "Order ID" IS NULL THEN 1 ELSE 0 END),
            ('Order Date', CASE WHEN "Order Date" IS NULL THEN 1 ELSE 0 END),
            ('Ship Date', CASE WHEN "Ship Date" IS NULL THEN 1 ELSE 0 END),
            ('Ship Mode', CASE WHEN "Ship Mode" IS NULL THEN 1 ELSE 0 END),
            ('Customer ID', CASE WHEN "Customer ID" IS NULL THEN 1 ELSE 0 END),
            ('Customer Name', CASE WHEN "Customer Name" IS NULL THEN 1 ELSE 0 END),
            ('Segment', CASE WHEN "Segment" IS NULL THEN 1 ELSE 0 END),
            ('Country', CASE WHEN "Country" IS NULL THEN 1 ELSE 0 END),
            ('City', CASE WHEN "City" IS NULL THEN 1 ELSE 0 END),
            ('State', CASE WHEN "State" IS NULL THEN 1 ELSE 0 END),
            ('Postal Code', CASE WHEN "Postal Code" IS NULL THEN 1 ELSE 0 END),
            ('Region', CASE WHEN "Region" IS NULL THEN 1 ELSE 0 END),
            ('Product ID', CASE WHEN "Product ID" IS NULL THEN 1 ELSE 0 END),
            ('Category', CASE WHEN "Category" IS NULL THEN 1 ELSE 0 END),
            ('Sub-Category', CASE WHEN "Sub-Category" IS NULL THEN 1 ELSE 0 END),
            ('Product Name', CASE WHEN "Product Name" IS NULL THEN 1 ELSE 0 END),
            ('Sales', CASE WHEN "Sales" IS NULL THEN 1 ELSE 0 END),
            ('Quantity', CASE WHEN "Quantity" IS NULL THEN 1 ELSE 0 END),
            ('Discount', CASE WHEN "Discount" IS NULL THEN 1 ELSE 0 END),
            ('Profit', CASE WHEN "Profit" IS NULL THEN 1 ELSE 0 END)
    ) AS v(column_name, missing_count)
) AS missing_data
GROUP BY column_name
HAVING SUM(missing_count) > 0
ORDER BY column_name;


SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT "Row ID") AS unique_row_ids,
    COUNT(*) - COUNT(DISTINCT "Row ID") AS duplicate_row_ids
FROM public.sample;

SELECT COUNT(*) AS duplicate_groups
FROM (
    SELECT *
    FROM public.sample
    GROUP BY
        "Row ID", "Order ID", "Order Date", "Ship Date",
        "Ship Mode", "Customer ID", "Customer Name",
        "Segment", "Country", "City", "State", "Postal Code",
        "Region", "Product ID", "Category", "Sub-Category",
        "Product Name", "Sales", "Quantity", "Discount", "Profit"
    HAVING COUNT(*) > 1
) AS duplicates;

SELECT
    "Order ID",
    "Product ID",
    COUNT(*) AS occurrence_count
FROM public.sample
GROUP BY "Order ID", "Product ID"
HAVING COUNT(*) > 1
ORDER BY occurrence_count DESC;

SELECT *
FROM public.sample
WHERE("Order ID","Product ID") IN (
 SELECT 
   "Order ID",
   "Product ID"
 FROM public.sample
 GROUP BY "Order ID","Product ID"
 HAVING COUNT(*) >1
)
ORDER BY "Order ID","Product ID","Row ID";

SELECT COUNT(*) AS negative_sales_count
FROM public.sample
WHERE "Sales" <0;

SELECT *
FROM public.sample
WHERE "Sales" < 0;

SELECT
    "Row ID",
    "Order ID",
    "Product ID",
    "Order Date",
    "Ship Date",
    "Quantity",
    "Sales",
    "Discount",
    "Profit"
FROM public.sample
WHERE ("Order ID", "Product ID") IN (
    SELECT
        "Order ID",
        "Product ID"
    FROM public.sample
    GROUP BY "Order ID", "Product ID"
    HAVING COUNT(*) > 1
)
ORDER BY "Order ID", "Product ID", "Row ID";

SELECT
    "Order ID",
    "Product ID",
    "Order Date",
    "Ship Date",
    "Ship Mode",
    "Customer ID",
    "Customer Name",
    "Segment",
    "Country",
    "City",
    "State",
    "Postal Code",
    "Region",
    "Category",
    "Sub-Category",
    "Product Name",
    "Sales",
    "Quantity",
    "Discount",
    "Profit",
    COUNT(*) AS occurrence_count
FROM public.sample
GROUP BY
    "Order ID",
    "Product ID",
    "Order Date",
    "Ship Date",
    "Ship Mode",
    "Customer ID",
    "Customer Name",
    "Segment",
    "Country",
    "City",
    "State",
    "Postal Code",
    "Region",
    "Category",
    "Sub-Category",
    "Product Name",
    "Sales",
    "Quantity",
    "Discount",
    "Profit"
HAVING COUNT(*) > 1;


SELECT 
 COUNT(*) AS negative_sales_count
FROM public.sample
WHERE "Sales" <0;

SELECT
 COUNT(*) AS negative_profit_lines,
 ROUND(SUM("Profit")::numeric,2) AS total_negative_profit
FROM public.sample
WHERE "Profit" < 0;

SELECT
 CASE
  WHEN "Profit" < 0 THEN 'Loss Making'
  WHEN "Profit" = 0 THEN 'Break Even'
  ELSE 'Profitable'
 END AS profit_status,
 COUNT(*) AS order_lines,
 ROUND(SUM("Sales")::numeric,2) AS revenue,
 ROUND(SUM("Profit")::numeric, 2) AS profit
FROM public.sample
GROUP BY profit_status
ORDER BY profit_status;

SELECT 
   "Order ID",
   "Product Name",
   "Category",
   "Sub-Category",
   "Region",
   "Sales",
   "Discount",
   "Profit"
FROM public.sample
WHERE "Profit"<0
ORDER BY "Profit" ASC
LIMIT 10;

SELECT
    MIN("Sales") AS min_sales,
    MAX("Sales") AS max_sales,
    ROUND(AVG("Sales")::numeric, 2) AS avg_sales,

    MIN("Profit") AS min_profit,
    MAX("Profit") AS max_profit,
    ROUND(AVG("Profit")::numeric, 2) AS avg_profit,

    MIN("Discount") AS min_discount,
    MAX("Discount") AS max_discount,

    MIN("Quantity") AS min_quantity,
    MAX("Quantity") AS max_quantity
FROM public.sample;

SELECT
    "Discount",
    COUNT(*) AS order_lines,

    ROUND(SUM("Sales")::numeric, 2) AS revenue,

    ROUND(SUM("Profit")::numeric, 2) AS profit,

    ROUND(
        (
            SUM("Profit") * 100.0 /
            NULLIF(SUM("Sales"), 0)
        )::numeric,
        2
    ) AS margin_percentage

FROM public.sample

GROUP BY "Discount"
ORDER BY "Discount";
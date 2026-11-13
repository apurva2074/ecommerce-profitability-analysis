SELECT
    SUM(CASE
        WHEN "Discount" = 0 THEN "Sales"
        ELSE 0
    END) AS Revenue_Without_Discount,

    SUM(CASE
        WHEN "Discount" = 0 THEN "Profit"
        ELSE 0
    END) AS Profit_Without_Discount,

    SUM(CASE
        WHEN "Discount" > 0 THEN "Sales"
        ELSE 0
    END) AS Revenue_With_Discount,

    SUM(CASE
        WHEN "Discount" > 0 THEN "Profit"
        ELSE 0
    END) AS Profit_With_Discount

FROM public.sample;

WITH discount_analysis AS (
    SELECT
        SUM(CASE WHEN "Discount" = 0
            THEN "Sales" ELSE 0 END) AS no_discount_revenue,

        SUM(CASE WHEN "Discount" = 0
            THEN "Profit" ELSE 0 END) AS no_discount_profit,

        SUM(CASE WHEN "Discount" > 0
            THEN "Sales" ELSE 0 END) AS discounted_revenue,

        SUM(CASE WHEN "Discount" > 0
            THEN "Profit" ELSE 0 END) AS discounted_profit
    FROM public.sample
)
SELECT
    ROUND(
        (no_discount_profit / NULLIF(no_discount_revenue, 0) * 100)::numeric,
        2
    ) AS baseline_margin_pct,

    ROUND(discounted_revenue::numeric, 2) AS discounted_revenue,

    ROUND(discounted_profit::numeric, 2) AS actual_discounted_profit,

    ROUND(
        (discounted_revenue * no_discount_profit /
        NULLIF(no_discount_revenue, 0))::numeric,
        2
    ) AS benchmark_profit,

    ROUND(
        (discounted_revenue * no_discount_profit /
        NULLIF(no_discount_revenue, 0) - discounted_profit)::numeric,
        2
    ) AS estimated_profit_opportunity
FROM discount_analysis;
SELECT 
 "Category",
 SUM("Sales") AS Total_Revenue,
 SUM("Profit") AS Total_Profit,
 ROUND(((SUM("Profit")::numeric / NULLIF(SUM("Sales"), 0)) * 100)::numeric, 2) AS profit_margin_pct,
 COUNT(*) AS Number_Of_rec
FROM public.sample
GROUP BY "Category"
ORDER BY Total_Revenue DESC;

SELECT 
 "Sub-Category",
 SUM("Sales") AS Total_Revenue,
 SUM("Profit") AS Total_Profit,
 ROUND(((SUM("Profit")::numeric / NULLIF(SUM("Sales"), 0)) * 100)::numeric, 2) AS profit_margin_pct,
 COUNT(*) AS Number_Of_rec
FROM public.sample
WHERE "Category" = 'Furniture'
GROUP BY "Sub-Category"
ORDER BY Total_Revenue ASC;

SELECT 
  "Sub-Category",
  "Discount",
  COUNT(*) as no_of_records,
  SUM("Profit") as Total_Profit,
  SUM("Sales") as Tota_Revenue,
  ROUND(((SUM("Profit")::numeric / NULLIF(SUM("Sales"),0)) * 100)::numeric, 2) AS profit_margin
FROM public.sample
WHERE "Category" = 'Furniture'
GROUP BY "Sub-Category","Discount"
ORDER BY "Sub-Category","Discount";

SELECT
  "Sub-Category",
  "Discount",
  COUNT(*) AS Order_lines,
  SUM("Quantity") AS Total_quantity,
  ROUND(((SUM("Quantity")::numeric / NULLIF(COUNT(*),0)) )::numeric, 2) AS Avg_quantity,
  SUM("Profit") as Total_Profit,
  SUM("Sales") as Tota_Revenue,
  ROUND(((SUM("Profit")::numeric / NULLIF(SUM("Sales"),0)) * 100)::numeric, 2) AS profit_margin,
  ROUND(((SUM("Sales")::numeric / NULLIF(COUNT(*),0)) )::numeric, 2) AS Avg_Sale_per_line
FROM public.sample
WHERE "Sub-Category" = 'Tables'
GROUP BY "Sub-Category","Discount";

  
SELECT
    "Category",
    "Sub-Category",
    SUM("Sales") AS Total_Revenue,
    SUM("Profit") AS Total_Profit,

    ROUND((SUM("Profit") / NULLIF(SUM("Sales"), 0) * 100)::numeric,2) AS Profit_Margin,

    COUNT(*) AS Order_Lines,

    CASE
        WHEN SUM("Profit") < 0 THEN 'Loss Making'
        WHEN SUM("Profit") > 0 THEN 'Profitable'
        ELSE 'Break Even'
    END AS Profit_Status

FROM public.sample

GROUP BY "Category", "Sub-Category"

ORDER BY Total_Profit ASC;
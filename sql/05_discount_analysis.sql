SELECT
 ROUND(("Discount" * 100)::numeric, 2) AS Discount_Percentage,
 COUNT(*) AS NO_Of_Order_Lines,
 SUM("Sales") AS Total_Revenue,
 SUM("Profit") AS Total_Profit,
 ROUND((SUM("Profit") / NULLIF(SUM("Sales"), 0) * 100)::numeric,2) AS Profit_Margin
FROM public.sample
GROUP BY "Discount"
ORDER BY Discount_Percentage;

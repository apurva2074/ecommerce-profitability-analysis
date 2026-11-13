SELECT 
 "Region",
 SUM("Sales") AS Total_Revenue,
 SUM("Profit") AS Total_Profit,
 ROUND((SUM("Profit") / NULLIF(SUM("Sales"), 0) * 100)::numeric,2) AS Profit_Margin,
 COUNT(*) AS No_Order_Lines,
 CASE
        WHEN SUM("Profit") < 0 THEN 'Loss Making'
        WHEN SUM("Profit") > 0 THEN 'Profitable'
        ELSE 'Break Even'
  END AS Profit_Status
FROM public.sample
GROUP BY "Region"
ORDER BY Total_Profit DESC;


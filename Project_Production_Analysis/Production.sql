-- Total Production 
SELECT
    SUM(production) as Total_production
FROM
    production



--Monthwise Production 
SELECT 
  DATE_FORMAT(date, '%M') AS Production_Month,
  SUM(production) AS Production_Count,
  SUM(SUM(production)) OVER (ORDER BY MONTH(date) ASC) AS Cumulative_Production
FROM 
  production
GROUP BY
  MONTH(date), DATE_FORMAT(date, '%M')
ORDER BY 
  MONTH(date)
  ;


-- Rank the months from highest to lowest production. 

SELECT 
  DATE_FORMAT(date, '%M') AS Production_Month,
  SUM(production) AS Production_Count,
  RANK() 
  OVER (ORDER BY SUM(production) DESC) AS Production_Rank
FROM 
    production
GROUP BY
    MONTH(date),
    DATE_FORMAT(date, '%M')
ORDER BY 
   Production_Rank ASC
;





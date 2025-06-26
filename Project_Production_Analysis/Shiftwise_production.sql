show columns from production;

--Production vary month to month with ranking assigned to top productive shift
--ranking assigned to shift to know which shift has more productive in production

SELECT 
    shift as Production_Shift,
    sum(production) as Shiftwise_Production
FROM
    production
GROUP BY
    Shift
ORDER BY
    2 DESC
;

-- shiftwise variation in shift to check in every month which shift has more production

SELECT 
  DATE_FORMAT(date, '%M') AS Production_Month,
  shift,
  SUM(production) AS Production_Count,
  RANK() 
  OVER (PARTITION BY DATE_FORMAT(date, '%M') 
  ORDER BY SUM(production) DESC) AS Production_Rank
FROM 
    production
GROUP BY
  shift,
  MONTH(date),
  DATE_FORMAT(date, '%M')
ORDER BY
    MONTH(date);


--Monthwise production
SELECT
    DATE_FORMAT(date,'%Y'),
    DATE_FORMAT(date,'%M'),
    SUM(Production),
    SUM(Production) OVER(ORDER BY SUM(Production) ASC ) as ranking
FROM
    production
GROUP BY
    1,2
;


-- total monthwise with running total

SELECT
    year,
    month_name,
    total_production,
    SUM(total_production) OVER (ORDER BY month_num ASC) AS running_total
FROM (
    SELECT
        DATE_FORMAT(date, '%Y') AS year,
        MONTH(date) AS month_num,                         -- Numeric month for sorting
        DATE_FORMAT(date, '%M') AS month_name,            -- Month name for display
        SUM(Production) AS total_production
    FROM
        production
    GROUP BY
        year, month_num, month_name
) AS sub
ORDER BY
    year, month_num;


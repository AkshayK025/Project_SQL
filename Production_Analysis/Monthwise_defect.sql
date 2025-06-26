-- Display the structure of the table.
show columns from defect;

--  total count of defective quantity for all months.

SELECT
    Sum(Count) as Total_Defective_Qty
FROM 
    defect;


-- Summarize monthly rejection quantities, rank by total

SELECT 
    DATE_FORMAT(date,'%M') as Prod_Month,
    Sum(Count) as Monthwise_Rej_Qty,
    RANK() OVER (ORDER BY Sum(Count) DESC) as Ranking
FROM
    defect
GROUP BY 
    MONTH(date),
    Prod_Month
ORDER BY 
    MONTH(Date)
;
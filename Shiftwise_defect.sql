show columns from defect;


-- Shift wise defective qty 
SELECT
    Shift,
    SUM(count) as defect_Qty_by_Shift,
    RANK() OVER (ORDER BY sum(Count) desc) as Ranking
FROM
    defect
GROUP BY
    Shift
;

-- Monthwise rejction Qty with ranking having which shift has more rejection qty
SELECT
    DATE_FORMAT(date,'%M') as Month,
    Shift,
    Sum(count) as Rejected_Qty,
    RANK() OVER (PARTITION BY  DATE_FORMAT(date,'%M') ORDER BY sum(count) ASC ) as Ranking
FROM 
    defect
GROUP BY
    1,2
;
    
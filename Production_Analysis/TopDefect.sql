/*
Write a SQL query to display the top 10 defect types with the highest total counts from July to December. 
The output should include each defect type with separate columns for the total count in each month, 
and only include defect types where the combined total count across these months exceeds 45.
*/


SELECT
    defect AS Defect_Type,
    SUM(CASE WHEN DATE_FORMAT(date, "%M") = "July" THEN count ELSE 0 END) AS Jul,
    SUM(CASE WHEN DATE_FORMAT(date, "%M") = "August" THEN count ELSE 0 END) AS Aug,
    SUM(CASE WHEN DATE_FORMAT(date, "%M") = "September" THEN count ELSE 0 END) AS Sep,
    SUM(CASE WHEN DATE_FORMAT(date, "%M") = "October" THEN count ELSE 0 END) AS Oct,
    SUM(CASE WHEN DATE_FORMAT(date, "%M") = "November" THEN count ELSE 0 END) AS Nov,
    SUM(CASE WHEN DATE_FORMAT(date, "%M") = "December" THEN count ELSE 0 END) AS Dece
FROM
    defect
GROUP BY
    defect
HAVING
    (Jul + Aug + Sep + Oct + Nov + Dece) > 45
ORDER BY
    Jul + Aug + Sep + Oct + Nov + Dece DESC
LIMIT 10;



/*
This query groups defects by type and uses conditional aggregation to sum counts per month 
from July to December. It filters out defects with zero total counts in these months,
 orders the results by total descending, limits output to top 10.
*/
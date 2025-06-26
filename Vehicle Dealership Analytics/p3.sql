/* 
"  Q3.Get top 3 dealers per region based on profit (revenue - 
cost) for Q1 2025."
*/

WITH dealer_profits AS (
    SELECT
        d.region AS region,
        d.dealer_name AS dealer,
        SUM(p.revenue - p.cost) AS total_profit,
        ROW_NUMBER() OVER (
            PARTITION BY d.region 
            ORDER BY SUM(p.revenue - p.cost) DESC
        ) AS rn
    FROM purchases p
    JOIN dealers d USING(dealer_id)
    WHERE QUARTER(p.purchase_date) = 1
      AND YEAR(p.purchase_date) = 2025
    GROUP BY d.region, d.dealer_name
)
SELECT 
    region, 
    dealer, 
    total_profit
FROM dealer_profits
WHERE rn <= 3;

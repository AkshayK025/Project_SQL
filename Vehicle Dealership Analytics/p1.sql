-- "   Q1. Find customers who purchased the same vehicle model 
-- more than once in the same year."

SELECT
     c.full_name as name,
     m.model_name as model,
     YEAR(p.purchase_date) as purchase_year

    
FROM 
    customers c
JOIN purchases p using(customer_id)
JOIN vehicles v using (vehicle_id)
JOIN models m using (model_id)

GROUP BY 
    name,model,purchase_year

HAVING
    count(*) > 1
-- "Q6. Find customers who bought both Toyota Corolla and Honda Civic"



SELECT 
    c.full_name
FROM 
    customers c
JOIN purchases p USING(customer_id)
JOIN vehicles v USING(vehicle_id)
JOIN models m USING(model_id)
WHERE 
    m.model_name IN ('Corolla', 'Civic')
GROUP BY 
    c.customer_id, c.full_name
HAVING 
    COUNT(DISTINCT m.model_name) = 2;

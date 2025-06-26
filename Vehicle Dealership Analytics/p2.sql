-- "Q2. Identify vehicles not serviced in the last 12 months."


SELECT
    v.vehicle_id,
    MAX(s.service_date) AS last_service_date
FROM 
    vehicles v
LEFT JOIN services s USING(vehicle_id)
GROUP BY v.vehicle_id
HAVING 
    MAX(s.service_date) IS NULL
    OR MAX(s.service_date) < DATE_SUB(CURDATE(), INTERVAL 12 MONTH);

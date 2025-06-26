-- "Q7. Get the latest service record for each vehicle along with cost."



WITH latest_services AS (
    SELECT
        vehicle_id,
        service_date,
        cost,
        ROW_NUMBER() OVER (
            PARTITION BY vehicle_id 
            ORDER BY service_date DESC
        ) AS rn
    FROM 
        services
)
SELECT 
    vehicle_id,
    service_date AS latest_service_date,
    cost
FROM 
    latest_services
WHERE 
    rn = 1;

/*
"Q4. Calculate the month-over-month % growth in service 
appointments in 2024."
*/

WITH cte AS (
    SELECT 
        MONTH(appointment_date) AS month_num,
        MONTHNAME(appointment_date) AS Month,
        COUNT(appointment_id) AS Total_Appointment
    FROM 
        service_appointments
    WHERE 
        YEAR(appointment_date) = 2024
    GROUP BY 
        MONTH(appointment_date), MONTHNAME(appointment_date)
)
SELECT
    Month, 
    Total_Appointment,
    LAG(Total_Appointment) OVER (ORDER BY month_num) AS previous_total_appointment,
    ROUND(
        (Total_Appointment - LAG(Total_Appointment) OVER (ORDER BY month_num)) 
        / NULLIF(LAG(Total_Appointment) OVER (ORDER BY month_num), 0) * 100, 2
    ) AS percentage_change
FROM
    cte
ORDER BY
    month_num;

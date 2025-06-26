/*
" Q5. Flag older records where customer email and phone are 
duplicated."
*/

WITH cte as
    (SELECT
        full_name, 
        email,
        phone,
        ROW_NUMBER() OVER(PARTITION BY email ORDER BY email) as rn_mail,
        ROW_NUMBER() OVER(PARTITION BY phone ORDER BY phone) as rn_phone
    FROM 
        customers
    )
SELECT 
    full_name,
    email,
    phone,
    CASE
    WHEN rn_mail > 1 OR rn_phone > 1 THEN 'Duplicate'
    ELSE 'Not Duplicate'
END

FROM
    cte
ORDER BY
    full_name;
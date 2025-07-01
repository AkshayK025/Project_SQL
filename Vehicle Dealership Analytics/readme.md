# 🚗 Vehicle Dealership Analytics – SQL Query Solutions

This repository contains SQL queries and sample datasets for analyzing a vehicle dealership business. The dataset is structured in MySQL and supports complex analytical queries related to purchases, services, and customer behavior.

---
![Database Schema](/Vechical/image/vechicle.png)
---
## 📌 Question 1  
**Find customers who purchased the same vehicle model more than once in the same year.**

---

### ✅ Objective

Identify customers who have made multiple purchases of the **same vehicle model** within the **same calendar year**.

---

### 🧠 Logic

We group the data by:

- Customer name  
- Vehicle model name  
- Year of purchase  

Then, we use `HAVING COUNT(*) > 1` to filter for customers who purchased the same model more than once in that year.

---

### 🛠️ SQL Query

```sql
SELECT
    c.full_name AS name,
    m.model_name AS model,
    YEAR(p.purchase_date) AS purchase_year
FROM 
    customers c
JOIN purchases p USING(customer_id)
JOIN vehicles v USING(vehicle_id)
JOIN models m USING(model_id)
GROUP BY 
    c.full_name, m.model_name, YEAR(p.purchase_date)
HAVING 
    COUNT(*) > 1;
```

## Result
| Name         | Model   | Purchase Year |
|--------------|---------|----------------|
| Alice Smith  | Corolla | 2024           |

---
## 📌 Question 2  
**Identify vehicles not serviced in the last 12 months**

---

### ✅ Objective

Find vehicles that either:
- Have **never been serviced**
- Or were **last serviced more than 12 months ago**

---

### 🧠 Logic

- Use `LEFT JOIN` to include vehicles with no service history.
- Use `MAX(service_date)` to get the latest service per vehicle.
- Filter using `HAVING` to find services older than 12 months or `NULL`.

---

### 🛠️ SQL Query

```sql
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
```
## Result:

| Vehicle ID | Last Service Date |
|------------|-------------------|
| 1          | 2024-06-01        |
| 2          | 2023-01-15        |
| 3          | 2023-06-20        |
| 4          | *(Not Available)* |
| 6          | *(Not Available)* |

---
## 📌 Question 3  
**Get top 3 dealers per region based on profit (revenue - cost) for Q1 2025**

---

### ✅ Objective

Identify the **top 3 dealers in each region** who generated the **most profit** during **Q1 of 2025**. Profit is calculated as the difference between **revenue and cost**.

---

### 🧠 Logic

- Filter purchases to include only those in **Q1 2025**.
- Aggregate total profit per dealer per region.
- Use `ROW_NUMBER()` to rank dealers within each region based on profit.
- Select only the **top 3 per region**.

---

### 🛠️ SQL Query

```sql
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
```
## Result:
| Region | Dealer      | Total Profit |
|--------|-------------|--------------|
| South  | SpeedMotors | 2000.00      |
| West   | DriveAway   | 2000.00      |

---
## 📌 Question 4  
**Calculate the month-over-month % growth in service appointments in 2024**

---

### ✅ Objective

Track how service demand changes each month in 2024 by computing the **month-over-month percentage growth** in service appointments.

---

### 🧠 Logic

- Filter records to only include the year 2024.
- Use `COUNT()` to get monthly totals.
- Use the `LAG()` window function to compare each month with the previous month.
- Use `ROUND(...)` and `NULLIF(...)` to compute and format the percentage change safely.

---

### 🛠️ SQL Query

```sql
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
```
## Result

| Month    | Total Appointment | Previous Total Appointment | Percentage Change |
|----------|-------------------|-----------------------------|-------------------|
| January  | 1                 |                             |                   |
| February | 1                 | 1                           | 0.00%             |
| March    | 2                 | 1                           | 100.00%           |
| April    | 1                 | 2                           | -50.00%           |
| May      | 1                 | 1                           | 0.00%             |
| June     | 2                 | 1                           | 100.00%           |

---
## 📌 Question 5  
**Flag older records where customer email and phone are duplicated**

---

### ✅ Objective

Detect and flag **duplicate customer entries** based on matching **email** or **phone number** values. Only the first occurrence should be considered the original, while others are marked as duplicates.

---

### 🧠 Logic

- Use `ROW_NUMBER()` to identify multiple entries with the same email or phone.
- `ROW_NUMBER() > 1` flags entries that are **not the first occurrence**.
- Combine both checks using `OR` in a `CASE` statement.

---

### 🛠️ SQL Query

```sql
WITH cte AS (
    SELECT
        full_name, 
        email,
        phone,
        ROW_NUMBER() OVER (PARTITION BY email ORDER BY email) AS rn_mail,
        ROW_NUMBER() OVER (PARTITION BY phone ORDER BY phone) AS rn_phone
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
    END AS status
FROM
    cte
ORDER BY
    full_name;
```
## Result:
## Duplicate Detection Report

This table shows a check for duplicate entries based on email or phone number.

| Full Name    | Email              | Phone       | Duplicate Status |
|--------------|--------------------|-------------|------------------|
| Alice Smith  | alice@example.com  | 1234567890  | Not Duplicate    |
| Bob Johnson  | bob@example.com    | 2345678901  | Not Duplicate    |
| Carol King   | alice@example.com  | 1234567890  | Duplicate        |
| Dan Lee      | dan@example.com    | 3456789012  | Not Duplicate    |

---
## 📌 Question 6  
**Find customers who bought both Toyota Corolla and Honda Civic**

---

### ✅ Objective

Identify customers who purchased **at least one** of each:
- Toyota Corolla
- Honda Civic

---

### 🧠 Logic

- Filter purchase records for only *Corolla* and *Civic*.
- Group by customer.
- Use `COUNT(DISTINCT model_name)` to ensure both models were purchased.
  - `= 2` means the customer bought both.

---

### 🛠️ SQL Query

```sql
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
```
## 📌 Question 7  
**Get the latest service record for each vehicle along with cost**

---

### ✅ Objective

Return the **most recent service record** for every vehicle in the system, showing the **service date** and the **service cost**.

---

### 🧠 Logic

- Use `ROW_NUMBER()` to rank service records by service date (newest first) for each vehicle.
- Select only the **latest service record** (`rn = 1`) per vehicle.

---

### 🛠️ SQL Query

```sql
WITH latest_services AS (
    SELECT
        vehicle_id,
        service_date,
        service_cost,
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
    service_cost
FROM 
    latest_services
WHERE 
    rn = 1;
```
### Result:
This table lists each vehicle's most recent service date and the associated cost.

| Vehicle ID | Latest Service Date | Cost   |
|------------|----------------------|--------|
| 1          | 2024-06-01           | 200.00 |
| 2          | 2023-01-15           | 150.00 |
| 3          | 2023-06-20           | 180.00 |
| 5          | 2024-10-10           | 250.00 |



## Disclaimer
Note: This dataset is made up for practice and learning with the help of AI tools. It’s inspired by real-life examples but doesn’t represent any actual company data.

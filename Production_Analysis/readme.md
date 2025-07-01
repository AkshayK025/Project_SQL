1. Monthly rejected quantities and rank the months from highest to lowest rejection.

```sql
SELECT 
  DATE_FORMAT(date, '%M') AS Production_Month,
  SUM(production) AS Production_Count,
  RANK() 
  OVER (ORDER BY SUM(production) DESC) AS Production_Rank
FROM 
    production
GROUP BY
    MONTH(date),
    DATE_FORMAT(date, '%M')
ORDER BY 
   Production_Rank ASC
;
```

### Output
| Production Month | Rejection Quantity | Rank |
|------------------|--------------------|------|
| **August**       | 6,275              | 1    |
| **July**         | 3,941              | 2    |
| **September**    | 3,827              | 3    |
| **December**     | 2,854              | 4    |
| **October**      | 2,833              | 5    |
| **November**     | 2,204              | 6    |



## 📈 Insight: Monthly Rejection Analysis

- **August** recorded the **highest rejection quantity** with **6,275 units**, indicating potential production or quality issues during that period.

- **July** and **September** followed closely, suggesting that the **third quarter** experienced higher rejection rates overall.

- The **lowest rejection** was observed in **November** with **2,204 units**, possibly due to better production quality or improved processes.

- Overall, there is a **noticeable decline** in rejection quantity from **August to November**, which may reflect **corrective actions** or **seasonal factors** impacting quality.

---
```sql
SELECT 
  DATE_FORMAT(date, '%M') AS Production_Month,
  SUM(production) AS Production_Count,
  SUM(SUM(production)) OVER (ORDER BY MONTH(date) ASC) AS Cumulative_Production
FROM 
  production
GROUP BY
  MONTH(date), DATE_FORMAT(date, '%M')
ORDER BY 
  MONTH(date)
  ;
```
###  Output
| Production Month | Monthly Production | Cumulative Production |
|------------------|--------------------|------------------------|
| **July**         | 46,481             | 46,481                 |
| **August**       | 53,306             | 99,787                 |
| **September**    | 50,558             | 150,345                |
| **October**      | 41,433             | 191,778                |
| **November**     | 40,507             | 232,285                |
| **December**     | 40,573             | 272,858                |

## 📊 Insight: Monthly Production Trend

- **August** recorded the **highest production** with **53,306 units**, contributing significantly to the overall output.

- **Production volume declined steadily** after August, possibly due to **seasonal factors**, **capacity limits**, or **reduced demand**.

- Despite the dip, **cumulative production** crossed **270,000 units** by **December**, reflecting **consistent output** over the second half of the year.

---
```sql
SELECT
    Shift,
    SUM(count) as defect_Qty_by_Shift,
    RANK() OVER (ORDER BY sum(Count) desc) as Ranking
FROM
    defect
GROUP BY
    Shift
;
```
### Output

| Shift | Total Defect Quantity | Rank |
|-------|------------------------|------|
| **I** | 13,425                | 1    |
| **II**| 8,509                 | 2    |

## 🔍 Insight: Shift-Wise Defect Analysis
- **Shift I** has a **significantly higher defect count** than **Shift II**, suggesting potential differences in **workforce performance**, **equipment usage**, or **quality control practices** between shifts.

---
```sql
SELECT 
  DATE_FORMAT(date, '%M') AS Production_Month,
  shift,
  SUM(production) AS Production_Count,
  RANK() 
  OVER (PARTITION BY DATE_FORMAT(date, '%M') 
  ORDER BY SUM(production) DESC) AS Production_Rank
FROM 
    production
GROUP BY
  shift,
  MONTH(date),
  DATE_FORMAT(date, '%M')
ORDER BY
    MONTH(date);
```
### Output:

| Production Month | Shift | Production Count | Production Rank |
|------------------|-------|------------------|-----------------|
| July             | I     | 31,027           | 1               |
| July             | II    | 15,454           | 2               |
| August           | I     | 35,353           | 1               |
| August           | II    | 17,953           | 2               |
| September        | I     | 35,001           | 1               |
| September        | II    | 15,557           | 2               |
| October          | I     | 27,270           | 1               |
| October          | II    | 14,163           | 2               |
| November         | I     | 27,895           | 1               |
| November         | II    | 12,612           | 2               |
| December         | I     | 25,952           | 1               |
| December         | II    | 14,621           | 2               |

## 📊 Analysis: Shift-wise Production Performance
- **Shift I consistently outperforms Shift II** in production volume every month, often producing roughly **double the units**.
- The **highest monthly production** for Shift I was in **August** with **35,353 units**.
- Shift II’s production remains **steady but significantly lower**, indicating a potential imbalance in **workload**, **resources**, or **shift scheduling**.
- This pattern highlights an opportunity to **investigate Shift II’s processes** for **efficiency improvements** or **better resource allocation**.

---
### Write a SQL query to display the top 10 defect types with the highest total counts from July to December. The output should include each defect type with separate columns for the total count in each month, and only include defect types where the combined total count across these months exceeds 45.

```sql
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
```
### Output:

| Defect Type             | Jul  | Aug  | Sep  | Oct  | Nov  | Dec  |
|------------------------|-------|-------|-------|-------|-------|-------|
| Poor Paintwork (F)      | 2,585 | 4,240 | 2,327 | 1,734 | 1,027 | 1,598 |
| Crimp Nut Leak (F)      | 680   | 1,022 | 772   | 556   | 572   | 375   |
| Dent (F)                | 407   | 666   | 439   | 408   | 286   | 397   |
| Screen Fail (F)         | 160   | 296   | 160   | 67    | 57    | 132   |
| Casting Leak (R)        | 59    | 37    | 70    | 40    | 29    | 28    |
| DV Torque Marking Miss (F) | 0     | 0     | 0     | 0     | 42    | 166   |
| DV Loose (F)            | 0     | 0     | 0     | 0     | 44    | 33    |
| DV O-ring Leak (F)      | 5     | 0     | 0     | 1     | 35    | 19    |
| Gauge Fail (R)          | 0     | 1     | 0     | 1     | 32    | 23    |
| DV Damage (F)           | 2     | 0     | 17    | 3     | 15    | 13    |


## This query groups defects by type and uses conditional aggregation to sum counts per month from July to December.orders the results by total descending, limits output to top 10.

## 🔍 Analysis: Defect Trends
- **Poor Paintwork defects** dominate across all months, **peaking sharply in August** with **4,240 defects** before declining towards December.




## Disclaimer
Note: This dataset is made up for practice and learning with the help of AI tools. It’s inspired by real-life examples but doesn’t represent any actual company or production data.

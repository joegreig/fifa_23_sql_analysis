###### Peak Ages by Position Type 

The objective of this analysis is to determine at what age players in each position type tend to reach their peak performance. To achieve this goal, we will be using data on player attributes such as age, position type, and overall rating. In an effort to rule out any exceptional outliers in terms of overall rating, it was decided to exclude any ages where there was less than 3 players in any given position type.

To start, we will group players by position type and calculate the average overall rating for each age group. Then, we will identify the age at which the average overall rating is highest for each position  type, and we will consider this age to be the peak age for that  position.

To show how the script results look, with rankings factored in, we will run it for the 'Defender' position_type group, with no WHERE clause on the rank 

```postgresql
WITH averages_by_age AS (
    SELECT 
        position_type, 
        age, 
        ROUND(AVG(overall), 1) AS average_overall, 
        COUNT(*) AS player_count
    FROM players
    GROUP BY position_type, age 
    HAVING COUNT(*) >= 3
)    

SELECT 
        position_type,
        age,
        average_overall,
        ROW_NUMBER() OVER (PARTITION BY position_type ORDER BY average_overall DESC) AS rank
FROM averages_by_age
WHERE position_type = 'Forward' 
ORDER BY position_type, rank ASC;

```

| position_type | age  | average_overall | rank |
| ------------- | ---- | --------------- | ---- |
| Forward       | 34   | 82              | 1    |
| Forward       | 33   | 82              | 2    |
| Forward       | 23   | 81.7            | 3    |
| Forward       | 35   | 81.4            | 4    |
| Forward       | 30   | 81.3            | 5    |
| Forward       | 31   | 80.6            | 6    |
| Forward       | 28   | 80.6            | 7    |
| Forward       | 29   | 80.3            | 8    |
| Forward       | 27   | 80.1            | 9    |
| Forward       | 26   | 80              | 10   |
| Forward       | 25   | 79.8            | 11   |
| Forward       | 22   | 79.6            | 12   |
| Forward       | 24   | 79.5            | 13   |
| Forward       | 36   | 79.3            | 14   |
| Forward       | 32   | 79.3            | 15   |

The full script was written to exclusively return only the highest ranked ages, per position type 

```postgresql
-- This CTE calculates the average overall rating for each position and age
-- It filters out any age/position group with less than 3 players
WITH averages_by_age AS (
SELECT
    position_type,
    age,
    ROUND(AVG(overall), 1) AS average_overall,
    COUNT(*) AS player_count
FROM players
GROUP BY position_type, age
HAVING COUNT(*) >= 3
)

-- This query selects the position, age, average overall rating, and rank for each position group
-- The rank is based on the average overall rating within each position group, with 1 being the highest
-- The results are sorted first by position type, then by rank
SELECT * 
FROM (
    SELECT
        position_type,
        age,
        average_overall,
        ROW_NUMBER() OVER (PARTITION BY position_type ORDER BY average_overall DESC) AS rank
    FROM averages_by_age
) AS rankings
WHERE rank = 1 
ORDER BY 
    position_type != 'Goalkeeper',
    position_type != 'Defender',
    position_type != 'Midfielder',
    position_type != 'Forward';
```

| position_type | age  | average_overall | rank |
| ------------- | ---- | --------------- | ---- |
| Goalkeeper    | 32   | 83.6            | 1    |
| Defender      | 36   | 81.5            | 1    |
| Midfielder    | 36   | 81.8            | 1    |
| Forward       | 33   | 82              | 1    |
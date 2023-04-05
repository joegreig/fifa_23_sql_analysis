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

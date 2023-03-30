WITH target_club AS (
    SELECT 
        club_name,
        ROUND(AVG(overall), 1) AS average_overall, 
        ROUND(AVG(value / 1000000), 1) AS average_value_millions,
        ROUND(AVG(age), 1) AS average_age
    FROM players 
    WHERE club_name = 'Real Madrid CF'
    GROUP BY club_name 
), 

average_by_position AS (
    SELECT 
        players.club_name, 
        position_type,
        position, 
        ROUND(AVG(overall), 1) AS average_overall
    FROM players 
    JOIN target_club USING (club_name)
    GROUP BY position, position_type, players.club_name
),

club_weaknesses AS (
    SELECT 
        position_type, 
        position, 
        abp.average_overall AS position_average, 
        tc.average_overall, 
        abp.club_name
    FROM average_by_position abp
    JOIN target_club tc USING (club_name)
    WHERE abp.average_overall < tc.average_overall
    ORDER BY position_type
) 

SELECT 
    name, 
    (value / 1000000) AS value_millions, 
    position_type, 
    position, 
    overall, 
    potential
FROM players 
WHERE age < (SELECT average_age FROM target_club) 
    AND (value / 1000000) < (SELECT average_value_millions FROM target_club)
    AND overall > (SELECT average_overall FROM target_club)
    AND club_name != (SELECT club_name FROM target_club)
ORDER BY position_type, position


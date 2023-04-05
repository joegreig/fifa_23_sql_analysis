### Dream Team

###### Objective

In the "Dream Team" part of this project, the objective is to create a team of 11 players within the constraints of a budget of 250 million. The team will consist of one goalkeeper, four defenders, four midfielders, and two forwards. The goal is to select the best players in their respective positions while staying within budget.

To select the best players, I will hand-pick a few key attributes for each position type. The players I choose should have higher than average ratings in these areas. For example, a goalkeeper's attributes may include diving, reflexes, and handling, while a forward's attributes may include finishing, pace, and dribbling. I will use SQL queries to filter the players based on these attributes and their market value, allowing for a strategic balance between cost and quality.

As forwards and midfielders are, generally speaking, more valuable than defenders and goalkeepers I have broken down the budget as follows: 15 million for 1 goalkeeper, 55 million for 4 defenders, 70 million for 4 midfielders, 60 million for 2 forwards.

The resulting Dream Team will provide insights into the most desirable and cost-effective players in FIFA 23, based on their attributes and market value. This will be a valuable resource for team managers and fans alike who are looking to create the best possible team within their budget.

------

I started by writing SQL to find my Goalkeeper 

```postgresql
-- This temporary table contains the average height, gk_positioning, gk_reflexes, and gk_diving values for all players with the position_type 'Goalkeeper'
with all_gks AS (
    SELECT 
        position_type, 
        ROUND(AVG(height_cm), 0) AS average_height, 
        ROUND(AVG(gk_positioning), 0) AS average_positioning,
        ROUND(AVG(gk_reflexes), 0) AS average_reflexes,
        ROUND(AVG(gk_diving), 0) AS average_diving
    FROM players p 
    JOIN goalkeeping_stats gs USING (player_id)
    WHERE position_type = 'Goalkeeper' 
    GROUP BY position_type
)

-- This query selects the name, overall rating, and market value in millions for goalkeepers who meet certain criteria
SELECT 
    position_type, 
    name, 
    overall, 
    (value / 1000000) AS value_millions
FROM players 
JOIN goalkeeping_stats USING (player_id) 
WHERE position_type = 'Goalkeeper' 
	-- Check key attributes are above-average 
    AND height_cm > (SELECT average_height FROM all_gks) 
    AND gk_positioning > (SELECT average_positioning FROM all_gks) s
    AND gk_reflexes > (SELECT average_reflexes FROM all_gks) 
    AND (value / 1000000) <= 20 -- Their market value is less than or equal to 20 million
ORDER BY overall DESC, value ASC 
LIMIT 1 
```

| position_type | name     | overall | value_millions |
| ------------- | -------- | ------- | -------------- |
| Goalkeeper    | M. Neuer | 90      | 13             |



For the remaining positions, to avoid writing recurring SQL, I wrote multiple CTEs and used UNIONs in the final SELECT 

```postgresql
-- This temporary table contains the average height, gk_positioning, gk_reflexes, and gk_diving values for all players with the position_type 'Goalkeeper'
with all_gks AS (
    SELECT 
        position_type, 
        ROUND(AVG(height_cm), 0) AS average_height, 
        ROUND(AVG(gk_positioning), 0) AS average_positioning,
        ROUND(AVG(gk_reflexes), 0) AS average_reflexes,
        ROUND(AVG(gk_diving), 0) AS average_diving
    FROM players p 
    JOIN goalkeeping_stats gs USING (player_id)
    WHERE position_type = 'Goalkeeper' 
    GROUP BY position_type
), 

-- This temporary table contains the average marking, stand tackle and slide tackle values for all players with the position_type 'Defender'
all_defenders AS (
    SELECT 
        position_type, 
        ROUND(AVG(marking), 0) AS average_marking,
        ROUND(AVG(stand_tackle), 0) AS average_stand_tackle, 
        ROUND(AVG(slide_tackle), 0) AS average_slide_tackle
    FROM players p 
    JOIN defending_stats ds USING (player_id)
    JOIN physicality_stats ps USING (player_id)
    WHERE position_type = 'Defender' 
    GROUP BY position_type   
), 

-- This temporary table contains the average stamina, short passing and interceptions values for all players with the position_type 'Midfielder'
all_midfielders AS (
    SELECT 
        position_type, 
        ROUND(AVG(stamina), 0) AS average_stamina,
        ROUND(AVG(short_passing), 0) AS average_short_passing, 
        ROUND(AVG(interceptions), 0) AS average_interceptions
    FROM players p 
    JOIN defending_stats ds USING (player_id)
    JOIN physicality_stats ps USING (player_id)
    JOIN passing_stats pas USING (player_id)
    WHERE position_type = 'Midfielder' 
    GROUP BY position_type   
),

-- This temporary table contains the average finishing, ball control and composure values for all players with the position_type 'Forward'
all_forwards AS (
    SELECT 
        position_type, 
        ROUND(AVG(finishing), 0) AS average_finishing,
        ROUND(AVG(ball_control), 0) AS average_ball_control, 
        ROUND(AVG(composure), 0) AS average_composure
    FROM players p 
    JOIN dribbling_stats ds USING (player_id)
    JOIN shooting_stats ss USING (player_id)
    WHERE position_type = 'Forward' 
    GROUP BY position_type   
)

-- GOALKEEPERS
-- This query selects the name, overall rating, and market value in millions for goalkeepers who meet certain criteria
SELECT 
    *, 
    1 AS position_order
FROM (
    SELECT 
        position_type, 
        name, 
        overall, 
        (value / 1000000) AS value_millions
    FROM players 
    JOIN goalkeeping_stats USING (player_id) 
    WHERE position_type = 'Goalkeeper' 
    	-- Check key attributes are above-average 
        AND height_cm > (SELECT average_height FROM all_gks) 
        AND gk_positioning > (SELECT average_positioning FROM all_gks) 
        AND gk_reflexes > (SELECT average_reflexes FROM all_gks) 
        AND (value / 1000000) <= 15 -- Their market value is less than or equal to 20 million
    ORDER BY overall DESC, value ASC 
    LIMIT 1  
) AS goalkeepers

UNION 

-- DEFENDERS
-- This query selects the name, overall rating, and market value in millions for defenders who meet certain criteria
SELECT 
    *, 
    2 AS position_order
FROM (
    SELECT 
        position_type, 
        name, 
        overall, 
        (value / 1000000) AS value_millions
    FROM players 
    JOIN defending_stats ds USING (player_id)
    JOIN physicality_stats ps USING (player_id)
    WHERE position_type = 'Defender' 
        -- Check key attributes are above-average 
        AND marking > (SELECT average_marking FROM all_defenders) 
        AND stand_tackle > (SELECT average_stand_tackle FROM all_defenders)
        AND slide_tackle > (SELECT average_slide_tackle FROM all_defenders)
        AND (value / 1000000) <= 13.75 
    ORDER BY overall DESC, value ASC 
    LIMIT 4 
) AS defenders

UNION

-- MIDFIELDERS
-- This query selects the name, overall rating, and market value in millions for midfielders who meet certain criteria
SELECT 
    *, 
    3 AS position_order
FROM (
    SELECT 
        position_type, 
        name, 
        overall, 
        (value / 1000000) AS value_millions
    FROM players 
    JOIN defending_stats ds USING (player_id)
    JOIN physicality_stats ps USING (player_id)
    JOIN passing_stats pas USING (player_id)
    WHERE position_type = 'Midfielder' 
        -- Check key attributes are above-average 
        AND stamina > (SELECT average_stamina FROM all_midfielders) 
        AND short_passing > (SELECT average_short_passing FROM all_midfielders)
        AND interceptions > (SELECT average_interceptions FROM all_midfielders)
        AND (value / 1000000) <= 30 
    ORDER BY overall DESC, value ASC 
    LIMIT 4 
) AS midfielders

UNION 

-- FORWARDS
-- This query selects the name, overall rating, and market value in millions for forwards who meet certain criteria
SELECT 
    *, 
    4 AS position_order
FROM (
    SELECT 
        position_type, 
        name, 
        overall, 
        (value / 1000000) AS value_millions
    FROM players 
    JOIN dribbling_stats ds USING (player_id)
    JOIN shooting_stats ss USING (player_id)
    WHERE position_type = 'Forward' 
        -- Check key attributes are above-average 
        AND finishing > (SELECT average_finishing FROM all_forwards) 
        AND ball_control > (SELECT average_ball_control FROM all_forwards)
        AND composure > (SELECT average_composure FROM all_forwards)
        AND (value / 1000000) <= 30 
    ORDER BY overall DESC, value ASC 
    LIMIT 2 
) AS attackers
ORDER BY position_order ASC
```

The final SELECT had to be wrapped in subqueries so I could use the **LIMIT** feature (which doesn't function when using UNIONs) to get the correct number of players for each position type. I also created a new field called **position_order** so I could create a custom order for the results - This allowed my to have the Goalkeeper at the top and Forwards at the bottom. 

| position_type | name           | overall | value_millions | position_order |
| ------------- | -------------- | ------- | -------------- | -------------- |
| Goalkeeper    | M. Neuer       | 90      | 13             | 1              |
| Defender      | F. Acerbi      | 82      | 10             | 2              |
| Defender      | G. Chiellini   | 84      | 7              | 2              |
| Defender      | Raul Albiol    | 82      | 5              | 2              |
| Defender      | Thiago Silva   | 86      | 12             | 2              |
| Midfielder    | J. Ward-Prowse | 81      | 29             | 3              |
| Midfielder    | L. Modric      | 88      | 29             | 3              |
| Midfielder    | Sergi Darder   | 82      | 30             | 3              |
| Midfielder    | J. Henderson   | 83      | 28             | 3              |
| Forward       | J. Vardy       | 85      | 23             | 4              |
| Forward       | Iago Aspas     | 85      | 26             | 4              |
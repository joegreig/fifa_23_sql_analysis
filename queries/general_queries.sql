-- Select top 5 overall rated players 
SELECT 
  	name, 
     	overall, 
    	position, 
    	club_name
FROM players
ORDER BY overall DESC
LIMIT 5;


-- Select top players in each position 
SELECT
	name, 
	overall, 
    	p.position 
FROM players p
JOIN (SELECT MAX(overall) AS max_overall, position FROM players GROUP BY position) a 
	ON a.max_overall = p.overall AND a.position = p.position 
ORDER BY position ASC; 


-- Add position_type column, then look for forwards, under 24 years old, with a value lower than 30 million who have the highest growth potential (potential minus overall) 
ALTER TABLE players ADD COLUMN position_type VARCHAR( 20 ) CHECK (position_type IN ('Goalkeeper', 'Defender', 'Midfielder', 'Forward'));

UPDATE players
SET position_type = 
	CASE 
	  	WHEN position IN ('RWB', 'RB', 'CB', 'LB', 'LWB') THEN 
	            'Defender'
	        WHEN position IN ('RM', 'CDM', 'CM', 'CAM', 'LM') THEN 
	            'Midfielder'
	        WHEN position IN ('RW', 'LW', 'CF', 'ST') THEN 
	            'Forward'
	        ELSE
	            'Goalkeeper'
	END;

SELECT 
   	name, 
    	overall, 
    	potential - overall AS growth,
    	age,
    	value / 1000000 AS value_millions
FROM players
WHERE 
    	age < 24 
    	AND value < 30000000
    	AND position_type = 'Forward' 
    	AND (potential - overall) > 5 
ORDER BY 
    	growth DESC, 
    	age ASC, 
    	value_millions ASC 


-- Find the top 10 most well-rounded players, judged by overall stats 
SELECT 
    	name, 
    	pace_total + shooting_total + passing_total + dribbling_total + defending_total + physicality_total AS total_stats, 
    	club_name, 
    	value / 1000000 AS value_millions
FROM players 
JOIN pace_stats USING (player_id)
JOIN shooting_stats USING (player_id)
JOIN passing_stats USING (player_id)
JOIN dribbling_stats USING (player_id)
JOIN defending_stats USING (player_id)
JOIN physicality_stats USING (player_id)
WHERE position_type IN('Defender', 'Midfielder', 'Forward')
ORDER BY total_stats DESC 
LIMIT 10 

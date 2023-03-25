##### Jump To 

- Dream Team
- Club Weaknesses
- Age Peaks

### General Queries

I decided to create and run a few simpler queries, before diving into the main projects, as a means to showcase some of the data across the tables  

###### Top 5 Overall Rated Players

```postgresql
SELECT 
	name, 
    overall, 
    position, 
    club_name
FROM players
ORDER BY overall DESC
LIMIT 5;
```

| name           | overall | position | club_name           |
| -------------- | ------- | -------- | ------------------- |
| K. Benzema     | 91      | CF       | Real Madrid CF      |
| R. Lewandowski | 91      | ST       | FC Barcelona        |
| K. De Bruyne   | 91      | CM       | Manchester City     |
| K. Mbappe      | 91      | ST       | Paris Saint-Germain |
| L. Messi       | 91      | CAM      | Paris Saint-Germain |



###### Top Players in Each Position

```postgresql
SELECT
	name, 
	overall, 
    p.position 
FROM players p
JOIN (SELECT MAX(overall) AS max_overall, position FROM players GROUP BY position) a 
	ON a.max_overall = p.overall AND a.position = p.position 
ORDER BY position ASC;
```

| name           | overall | position |
| -------------- | ------- | -------- |
| L. Messi       | 91      | CAM      |
| V. van Dijk    | 90      | CB       |
| J. Kimmich     | 89      | CDM      |
| N. Kante       | 89      | CDM      |
| Casemiro       | 89      | CDM      |
| K. Benzema     | 91      | CF       |
| K. De Bruyne   | 91      | CM       |
| T. Courtois    | 90      | GK       |
| M. Neuer       | 90      | GK       |
| Joao Cancelo   | 88      | LB       |
| S. Mane        | 89      | LM       |
| H. Son         | 89      | LW       |
| Neymar Jr      | 89      | LW       |
| T. Hernandez   | 85      | LWB      |
| K. Walker      | 85      | RB       |
| S. Gnabry      | 85      | RM       |
| M. Salah       | 90      | RW       |
| R. James       | 84      | RWB      |
| R. Lewandowski | 91      | ST       |
| K. Mbappe      | 91      | ST       |

###### 

###### Scouting Targets

I wanted to imagine I was a scouting agent, and had been given instructions to find players who fit a certain criteria; 

- Under 24 years old 
- Value lower than 30 million
- High growth potential
- Plays in a forward position 

I started by adding a new column to the existing `players` table called `position_type`

```postgresql
ALTER TABLE players ADD COLUMN position_type VARCHAR( 20 ) CHECK (position_type IN ('Goalkeeper', 'Defender', 'Midfielder', 'Forward'));
```

Then updating existing records. This will allow me to easily filter the table by the different positional areas in future

```postgresql
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
```

Query to find scouting targets

```postgresql
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
```

| name          | overall | growth | age  | value_millions |
| ------------- | ------- | ------ | ---- | -------------- |
| A. Hlozek     | 77      | 10     | 19   | 23             |
| J. David      | 79      | 6      | 22   | 28             |
| R. Kolo Muani | 78      | 6      | 23   | 22             |
| D. Malen      | 79      | 6      | 23   | 28             |



###### Most well-rounded players

Using the _total value from each of the _stats tables, I wanted to find out the top 10 most well-rounded outfield (not goalkeepers) players are 

```postgresql
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
```

| name            | total_stats | club_name           | value_millions |
| --------------- | ----------- | ------------------- | -------------- |
| L. Goretzka     | 492         | FC Bayern Munchen   | 91             |
| Marcos Llorente | 489         | Atletico de Madrid  | 48             |
| M. Acuna        | 483         | Sevilla FC          | 46             |
| E. Can          | 483         | Borussia Dortmund   | 30             |
| K. De Bruyne    | 483         | Manchester City     | 107            |
| T. Hernandez    | 483         | AC Milan            | 76             |
| Joao Cancelo    | 482         | Manchester City     | 82             |
| N. Barella      | 480         | Inter               | 89             |
| A. Hakimi       | 479         | Paris Saint-Germain | 53             |
| F. de Jong      | 479         | FC Barcelona        | 116            |
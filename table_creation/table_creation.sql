-- Create players table 
CREATE TABLE players (
	player_id serial PRIMARY KEY,
    name VARCHAR(50) NOT NULL, 
	overall INTEGER NOT NULL CHECK (overall BETWEEN 1 AND 99),
	potential INTEGER NOT NULL CHECK (potential BETWEEN 1 AND 99),
	value INTEGER NOT NULL,
	position VARCHAR(3) NOT NULL CHECK (position IN ('GK', 'RWB', 'RB', 'CB', 'LB', 'LWB', 'RM', 'RW', 'LM', 'LW', 'CDM', 'CM', 'CAM', 'CF', 'ST')),
    nationality VARCHAR(50) NOT NULL, 
    age INTEGER NOT NULL, 
    height_cm INTEGER NOT NULL, 
    weight_kg INTEGER NOT NULL, 
    club_name VARCHAR(50) NOT NULL, 
    preferred_foot VARCHAR(5) NOT NULL CHECK (preferred_foot IN ('Left', 'Right'))

	CONSTRAINT overall_potential_check CHECK (overall >= potential)
);


-- Create pace stats table
CREATE TABLE pace_stats (
	player_id INTEGER,
	pace_total INTEGER NOT NULL, 
	acceleration INTEGER NOT NULL, 
	sprint_speed INTEGER NOT NULL, 

	CONSTRAINT FK_player_id FOREIGN KEY(player_id)
        REFERENCES players(player_id),

    CONSTRAINT pace_stats_range CHECK (
        pace_total >= 1 AND pace_total <= 99 AND
        acceleration >= 1 AND acceleration <= 99 AND
        sprint_speed >= 1 AND sprint_speed <= 99
    )
);

-- Create shooting stats table
CREATE TABLE shooting_stats (
	player_id INTEGER,
	shooting_total INTEGER NOT NULL, 
	finishing INTEGER NOT NULL, 
	volleys INTEGER NOT NULL,
	shot_power INTEGER NOT NULL,
	long_shots INTEGER NOT NULL,
	positioning INTEGER NOT NULL,
	penalties INTEGER NOT NULL, 

	CONSTRAINT FK_player_id FOREIGN KEY(player_id)
        REFERENCES players(player_id),


    CONSTRAINT shooting_stats_range CHECK (
        shooting_total >= 1 AND shooting_total <= 99 AND
        finishing >= 1 AND finishing <= 99 AND
        volleys >= 1 AND volleys <= 99 AND
        shot_power >= 1 AND shot_power <= 99 AND
        long_shots >= 1 AND long_shots <= 99 AND
        positioning >= 1 AND positioning <= 99 AND
        penalties >= 1 AND penalties <= 99
    )
);

-- Create passing stats table
CREATE TABLE passing_stats (
	player_id INTEGER,
	passing_total INTEGER NOT NULL, 
	crossing INTEGER NOT NULL, 
	short_passing INTEGER NOT NULL,
	curve INTEGER NOT NULL,
	fk_accuracy INTEGER NOT NULL,
	long_passing INTEGER NOT NULL,
	vision INTEGER NOT NULL, 

	CONSTRAINT FK_player_id FOREIGN KEY(player_id)
        REFERENCES players(player_id),

    CONSTRAINT passing_stats_range CHECK (
        passing_total >= 1 AND passing_total <= 99 AND
        crossing >= 1 AND crossing <= 99 AND
        short_passing >= 1 AND short_passing <= 99 AND
        curve >= 1 AND curve <= 99 AND
        fk_accuracy >= 1 AND fk_accuracy <= 99 AND
        long_passing >= 1 AND long_passing <= 99 AND
        vision >= 1 AND vision <= 99
    ) 
);

-- Create dribbling stats table
CREATE TABLE dribbling_stats (
	player_id INTEGER,
	dribbling_total INTEGER NOT NULL, 
	dribbling INTEGER NOT NULL, 
	ball_control INTEGER NOT NULL,
	agility INTEGER NOT NULL,
	reactions INTEGER NOT NULL,
	balance INTEGER NOT NULL,
	composure INTEGER NOT NULL, 

	CONSTRAINT FK_player_id FOREIGN KEY(player_id)
        REFERENCES players(player_id),

    CONSTRAINT dribbling_stats_range CHECK (
        dribbling_total >= 1 AND dribbling_total <= 99 AND
        dribbling >= 1 AND dribbling <= 99 AND
        ball_control >= 1 AND ball_control <= 99 AND
        agility >= 1 AND agility <= 99 AND
        reactions >= 1 AND reactions <= 99 AND
        balance >= 1 AND balance <= 99 AND
        composure >= 1 AND composure <= 99
    )	
);

-- Create defending stats table
CREATE TABLE defending_stats (
	player_id INTEGER,
	defending_total INTEGER NOT NULL, 
	heading_acc INTEGER NOT NULL, 
	interceptions INTEGER NOT NULL,
	marking INTEGER NOT NULL,
	stand_tackle INTEGER NOT NULL,
	slide_tackle INTEGER NOT NULL,
    
	CONSTRAINT FK_player_id FOREIGN KEY(player_id)
        REFERENCES players(player_id),

    CONSTRAINT defending_stats_range CHECK (
        defending_total >= 1 AND defending_total <= 99 AND
        heading_acc >= 1 AND heading_acc <= 99 AND
        interceptions >= 1 AND interceptions <= 99 AND
        marking >= 1 AND marking <= 99 AND
        stand_tackle >= 1 AND stand_tackle <= 99 AND
        slide_tackle >= 1 AND slide_tackle <= 99 
    )	
);

-- Create physicality stats table
CREATE TABLE physicality_stats (
	player_id INTEGER,
	physicality_total INTEGER NOT NULL, 
	jumping INTEGER NOT NULL, 
	stamina INTEGER NOT NULL,
	strength INTEGER NOT NULL,
	aggression INTEGER NOT NULL,

	CONSTRAINT FK_player_id FOREIGN KEY(player_id)
        REFERENCES players(player_id),

    CONSTRAINT physicality_stats_range CHECK (
        physicality_total >= 1 AND physicality_total <= 99 AND
        jumping >= 1 AND jumping <= 99 AND
        stamina >= 1 AND stamina <= 99 AND
        strength >= 1 AND strength <= 99 AND
        aggression >= 1 AND aggression <= 99 
    )	
);

-- Create goalkeeping stats table 
CREATE TABLE goalkeeping_stats (
	player_id INTEGER,
	gk_diving INTEGER NOT NULL, 
	gk_kicking INTEGER NOT NULL, 
	gk_positioning INTEGER NOT NULL,
	gk_reflexes INTEGER NOT NULL,

	CONSTRAINT FK_player_id FOREIGN KEY(player_id)
        REFERENCES players(player_id),

    CONSTRAINT goalkeeping_stats_range CHECK (
        gk_diving >= 1 AND gk_diving <= 99 AND
        gk_kicking >= 1 AND gk_kicking <= 99 AND
        gk_positioning >= 1 AND gk_positioning <= 99 AND
        gk_reflexes >= 1 AND gk_reflexes <= 99 
    )	
);

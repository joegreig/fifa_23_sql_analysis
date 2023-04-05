# **fifa_23_sql_analysis**

I decided to work on a project using SQL to analyse a dataset containing player information from the FIFA 23 video game. 

I split the dataset into separate tables, imported the dataset into a PostgreSQL database and wrote SQL queries to extract valuable insights such as top players by position, potential scouting targets and areas of weakness for specific clubs. 

## About 

The dataset used for this project is a collection of CSV files containing information on players and teams in the popular FIFA 23 video game. The main CSV file contains detailed player information, while the rest of the files contain attribute stats for each player, such as shooting and defending. The dataset has been curated to include only the top 1000 rated players.

FIFA 23 is a popular video game in which players can create and manage their own virtual football teams. The game includes real-life players and teams, with each player assigned a rating based on their performance in the real world.

To explore the data, three main questions were posed:

1. Create a "Dream Team" containing the best possible 11 players in the correct positions, with a 250,000,000 budget. [[1]](https://github.com/joegreig/fifa_23_sql_analysis/tree/main/queries/dream_team)
2. Identify a club's areas of weakness by position and recommend new players based on that club's average player age, overall rating, potential, and value.
3. At which age do players in each type of position tend to peak?

## Acknowledgements 

Dataset acquired from Kaggle: https://www.kaggle.com/datasets/sanjeetsinghnaik/fifa-23-players-dataset

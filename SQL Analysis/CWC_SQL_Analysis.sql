USE cwc2023; # Using Cwc2023 as new db
SHOW TABLES; # For Checkig How many tables
DESC cwc2023.final_batting_df;
DESC cwc2023.final_bowling_df;
DESC cwc2023.schedule;
#*******************************************Changing Table_Names*********************************

ALTER TABLE cwc2023.final_batting_df RENAME TO batting_df;
ALTER TABLE cwc2023.final_bowling_df RENAME TO bowling_df;

#********************************************Data Inspection***************************************
SELECT distinct * FROM cwc2023.batting_df; # No Duplicates count (876 players) ✅

SELECT distinct Team FROM cwc2023.batting_df; # 10 Teams in the Tournament ✅

SELECT distinct Opposite_Team  FROM cwc2023.batting_df; # 10 Teams in the Tournament ✅

SELECT distinct Batsman FROM cwc2023.batting_df ORDER BY 1; # 148 Batsman ❌

# Batsman Fix
UPDATE cwc2023.batting_df
SET Batsman = 'Hashmatullah Shahidi'
WHERE  Batsman IN('Hashmatullah Shahidi','Hashmatullah Shahidi (C)');
SELECT distinct Batsman FROM cwc2023.batting_df ORDER BY 1; # 147 Batsman ✅

SELECT distinct `Dismissal Type`  FROM cwc2023.batting_df; # 10 Types of Dismissals ✅

#*****************************************Team Analysis*********************************************
#1 Venue distribution
SELECT Venue, COUNT(1) AS match_cnt
FROM cwc2023.schedule
GROUP BY Venue
ORDER BY 2 DESC;
## Inference : Except Hyderabad in all stadiums 5 matches conducted 

#2 Team Vs Venue
#3 Team Victory Margin 
#4 Player_of_Match_Individual
SELECT Player_of_the_Match,COUNT(Player_of_the_Match) as cnt FROM cwc2023.schedule
GROUP BY Player_of_the_Match
ORDER BY cnt DESC;

# Player_of_Match_Team_wise
SELECT Winner,COUNT(Player_of_the_Match) as cnt FROM cwc2023.schedule
GROUP BY Winner
ORDER BY cnt DESC ;

# Toss Percentage102
WITH Team AS(
SELECT Team1 FROM cwc2023.schedule
UNION ALL
SELECT Team2 FROM cwc2023.schedule),
Team_2 AS(SELECT Team1,COUNT(Team1) as total_mat FROM Team group by Team1)
SELECT Toss as Team,ROUND(100*COUNT(Toss)/t2.total_mat,2)as Toss_Won_pct FROM cwc2023.schedule t1 JOIN Team_2 as t2 ON t1.Toss = t2.Team1	
group by Team
ORDER BY Toss_Won_pct DESC;


SELECT * FROM cwc2023.schedule;

#***************************************Views***********************************************************
CREATE VIEW Batsman_Stats AS(
SELECT Batsman,Team,SUM(Runs) as Total_Runs,SUM(Balls) as Total_Balls,SUM(Boundaries) as Total_Boundaries,SUM(Sixes)as Total_sixess,ROUND(AVG(StrikeRate),2) AS StrikeRate
FROM cwc2023.batting_df
GROUP BY Batsman,Team
ORDER BY Total_Runs DESC);

SELECT * FROM Batsman_Stats


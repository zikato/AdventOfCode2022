/*
USE AoC2022
GO
CREATE SCHEMA day2
GO
*/

DROP TABLE IF EXISTS #Stage
CREATE TABLE #Stage
(
	Opponent char(1) NOT NULL
	, Me char(1) NOT NULL
)

DROP TABLE IF EXISTS day2.Input
CREATE TABLE day2.Input
(
	Id int IDENTITY NOT NULL
	, Opponent char(1) NOT NULL
	, Me char(1) NOT NULL
	, CONSTRAINT Day2_PK PRIMARY KEY (Id)
)

/* UTF8 encoding, lineends = CRLF */
BULK INSERT #Stage
FROM 'D:\AdventOfCode2022\Day2\input.txt'
WITH
(
	FIRSTROW = 1
	, FIELDTERMINATOR = ' '
	, ROWTERMINATOR = '\n'
	, TABLOCK
)

INSERT INTO day2.Input WITH (TABLOCKX)
(Opponent, Me)
SELECT 
	s.Opponent, s.Me
FROM #Stage AS s
OPTION (MAXDOP 1)

 /*
 ###############################################################################
 	Helper
 ###############################################################################
 */

 DROP TABLE IF EXISTS  day2.ShapeMapping
 DROP TABLE IF EXISTS day2.Shape
 CREATE TABLE day2.Shape
 (
	Score tinyint PRIMARY KEY
	, Shape varchar(8) NOT NULL UNIQUE
 )	

 INSERT INTO day2.Shape (Score, Shape)
 VALUES 
 (1, 'Rock'), (2, 'Paper'), (3, 'Scissors')
 
 CREATE TABLE day2.ShapeMapping
 (
	Letter char(1) PRIMARY KEY
	, ShapeId tinyint REFERENCES day2.Shape
 )

 INSERT INTO day2.ShapeMapping (Letter, ShapeId)
 VALUES 
 ('A', 1)
 , ('B', 2)
 , ('C', 3)

 DROP TABLE IF EXISTS day2.Scoring
 CREATE TABLE day2.Scoring
 (
	ShapeId1 tinyint NOT NULL
	, ShapeId2 tinyint NOT NULL
	, ResultScore tinyint NOT NULL
	, CONSTRAINT PK_day2_Scoring PRIMARY KEY (ShapeId1, ShapeId2)
 )

 INSERT INTO day2.Scoring 
 (ShapeId1, ShapeId2, ResultScore)
 SELECT 
 	s1.Score
	, s2.Score
	, Case
		WHEN s1.Score = s2.Score THEN 3 /* draw*/ 
		WHEN s1.Score = 1 AND s2.Score = 3 THEN 6 /* s1 won */
		WHEN s1.Score = 1 AND s2.Score = 2 THEN 0 /* s1 lost*/
		WHEN s1.Score = 2 AND s2.Score = 1 THEN 6 /* s1 won */
		WHEN s1.Score = 2 AND s2.Score = 3 THEN 0 /* s1 lost */
		WHEN s1.Score = 3 AND s2.Score = 2 THEN 6 /* s1 won */
		WHEN s1.Score = 3 AND s2.Score = 1 THEN 0 /* s1 lost */
		ELSE NULL
	End
 FROM day2.Shape AS s1
 CROSS JOIN day2.Shape AS s2    /* generate all combinations */


/*
###############################################################################
	Part 1
###############################################################################
*/

 INSERT INTO day2.ShapeMapping (Letter, ShapeId)
 VALUES 
 ('X', 1)
 , ('Y', 2)
 , ('Z', 3)

SELECT 
	SUM(m.ShapeId + s.ResultScore) AS Result
FROM day2.Input AS i
JOIN day2.ShapeMapping AS o /* opponent */
	ON i.Opponent = o.Letter
JOIN day2.ShapeMapping AS m /* me */
	ON i.Me = m.Letter
JOIN day2.Scoring AS s
	ON s.ShapeId1 = m.ShapeId
	AND s.ShapeId2 = o.ShapeId


/*
###############################################################################
	Part 2
###############################################################################
*/

/* 
X = lost (0)
Y = draw (3)
Z = win (6)

*/

; -- Previous statement must be properly terminated
SELECT 
	SUM(s.ShapeId1 + s.ResultScore) AS Result
FROM day2.Input AS i
JOIN day2.ShapeMapping AS o /* opponent */
	ON i.Opponent = o.Letter
JOIN day2.Scoring AS s
    ON s.ShapeId2 = o.ShapeId
    AND s.ResultScore = CASE i.Me
                        WHEN 'X' THEN 0
                        WHEN 'Y' THEN 3
                        WHEN 'Z' THEN 6
                        end


/*
USE AoC2022

CREATE SCHEMA day1
*/

DROP TABLE IF EXISTS #Stage
CREATE TABLE #Stage
(
	Input int NULL
)

DROP TABLE IF EXISTS day1.Input
CREATE TABLE day1.Input
(
	Id int IDENTITY NOT NULL
	, Calories  int NULL
	, CONSTRAINT Day1_PK PRIMARY KEY (Id)
)

/* UTF8 encoding, lineends = CRLF */
BULK INSERT #Stage
FROM 'D:\AdventOfCode2022\Day1\input.txt'
WITH
(
	FIRSTROW = 1
	,ROWTERMINATOR = '\n'
	,TABLOCK
)

INSERT INTO day1.Input WITH (TABLOCKX)
(Calories)
SELECT s.Input
FROM #Stage AS s
OPTION (MAXDOP 1)

/*
###############################################################################
	Part 1
###############################################################################
*/

;WITH grouped
AS
(
	SELECT 
		*
		, SUM(IIF(i.Calories IS NULL, 1, 0)) OVER (ORDER BY i.Id) AS GroupId /* rolling ISNULL sum to separte elfs into groups */
	FROM day1.Input AS i 
)
SELECT TOP (1)
	SUM(g.Calories) AS CaloriesSum
FROM grouped AS g
GROUP BY g.GroupId
ORDER BY CaloriesSum DESC

/*
###############################################################################
	Part 2
###############################################################################
*/
;WITH grouped
AS
(
	SELECT 
		*
		, SUM(IIF(i.Calories IS NULL, 1, 0)) OVER (ORDER BY i.Id) AS GroupId /* rolling ISNULL sum to separte elfs into groups */
	FROM day1.Input AS i 
)
, topThreeElves
AS
(
	SELECT TOP (3)
		SUM(g.Calories) AS CaloriesSum
	FROM grouped AS g
	GROUP BY g.GroupId
	ORDER BY CaloriesSum DESC
)
SELECT 
	SUM(CaloriesSum) AS Result
FROM topThreeElves 
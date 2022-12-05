/*
USE AoC2022
GO
CREATE SCHEMA day4
GO
*/

DROP TABLE IF EXISTS #Stage
CREATE TABLE #Stage
(
	FirstElf varchar(10)
	, SecondElf varchar(10)
)

DROP TABLE IF EXISTS day4.Input
CREATE TABLE day4.Input
(
	Id int IDENTITY NOT NULL
	, FirstElfLow smallint NOT NULL
	, FirstElfHigh smallint NOT NULL
	, SecondElfLow smallint NOT NULL
	, SecondElfHigh smallint NOT NULL
)

/* UTF8 encoding, lineends = CRLF */
BULK INSERT #Stage
FROM 'D:\AdventOfCode2022\day4\input.txt'
WITH
(
	FIRSTROW = 1
	, FIELDTERMINATOR = ','
	, ROWTERMINATOR = '\n'
	, TABLOCK
)


INSERT INTO day4.Input WITH (TABLOCKX)
(FirstElfLow, FirstElfHigh, SecondElfLow, SecondElfHigh)
SELECT 
	SUBSTRING(s.FirstElf, 0, CHARINDEX('-', s.FirstElf))
	, SUBSTRING(s.FirstElf, CHARINDEX('-', s.FirstElf)+1, LEN(s.FirstElf))
	, SUBSTRING(s.SecondElf, 0, CHARINDEX('-', s.SecondElf))
	, SUBSTRING(s.SecondElf, CHARINDEX('-', s.SecondElf)+1, LEN(s.SecondElf))
FROM #Stage AS s
OPTION (MAXDOP 1)

/*
###############################################################################
	Part 1
###############################################################################
*/

SELECT COUNT(1) AS Result
FROM day4.Input AS i
WHERE 
	(
		i.FirstElfLow <= i.SecondElfLow
		AND i.FirstElfHigh >= i.SecondElfHigh
	)
	OR
	(
		i.SecondElfLow <= i.FirstElfLow
		AND i.SecondElfHigh >= i.FirstElfHigh
	)


/*
###############################################################################
	Part 2
###############################################################################
*/

/*
		5	6	7
				7	8	9

			6
	4	5	6
*/

SELECT 
	COUNT(1) AS Result
FROM day4.Input AS i
WHERE 
	(
		i.FirstElfHigh >= i.SecondElfLow
		AND i.FirstElfLow <= i.SecondElfHigh
	)
	OR
	(
		i.SecondElfHigh >= i.FirstElfLow
		AND i.SecondElfLow <= i.FirstElfHigh
	)
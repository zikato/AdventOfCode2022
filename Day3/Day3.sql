/*
USE AoC2022
GO
CREATE SCHEMA day3
GO
*/

DROP TABLE IF EXISTS #Stage
CREATE TABLE #Stage
(
	Input varchar(100)
)

DROP TABLE IF EXISTS day3.Input
CREATE TABLE day3.Input
(
	Id int IDENTITY NOT NULL
	, Input varchar(100) NOT NULL
)

/* UTF8 encoding, lineends = CRLF */
BULK INSERT #Stage
FROM 'D:\AdventOfCode2022\day3\input.txt'
WITH
(
	FIRSTROW = 1
	, ROWTERMINATOR = '\n'
	, TABLOCK
)

INSERT INTO day3.Input WITH (TABLOCKX)
(Input)
SELECT 
	s.Input
FROM #Stage AS s
OPTION (MAXDOP 1)

/*
###############################################################################
	Part 1
###############################################################################
*/
GO
CREATE OR ALTER FUNCTION day3.FindSameLetters
(
	@Input1 varchar(50)
	, @Input2 varchar(50)
)
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN 
	WITH
	  L0   AS(SELECT 1 AS c UNION ALL SELECT 1),
	  L1   AS(SELECT 1 AS c FROM L0 CROSS JOIN L0 AS B),
	  L2   AS(SELECT 1 AS c FROM L1 CROSS JOIN L1 AS B),
	  L3   AS(SELECT 1 AS c FROM L2 CROSS JOIN L2 AS B),
	  Nums AS(SELECT ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS n FROM L3)
	, tally AS (SELECT TOP (50) n FROM Nums ORDER BY n)
	, splitIntoChars
	AS
    (
		SELECT 
			SUBSTRING(@Input1, n, 1) AS FirstRucksack
			, SUBSTRING(@Input2, n, 1) AS SecondRucksack
		FROM tally AS t
	)
	SELECT DISTINCT /* If a letter is repeated, I only want the first occurance */
		f.FirstRucksack AS CommonLetters
	FROM splitIntoChars AS f
	WHERE EXISTS /* to prevent row explosion */
	(
		SELECT 1
		FROM splitIntoChars AS s
		WHERE f.FirstRucksack = s.SecondRucksack COLLATE Latin1_General_CS_AS
	)
	AND f.FirstRucksack <> ''
	
GO



;WITH splitIntoRucksack
AS
(
SELECT 
	i.Id
	, LEFT(i.Input, LEN(i.Input)/2) AS FirstRucksack
	, RIGHT(i.Input, LEN(i.Input)/2) AS SecondRucksack
FROM day3.Input AS i
)
, calculatePriority
AS
(
SELECT
	sir.*
	, fsl.CommonLetters
	, CASE
		WHEN ca.asciiValue <= 90 THEN ca.asciiValue - 38 /* uppercase */
		WHEN ca.asciiValue > 90 THEN ca.asciiValue - 96 /* lowercase */
	END AS itemPriority
FROM splitIntoRucksack AS sir 
CROSS APPLY day3.FindSameLetters(sir.FirstRucksack, sir.SecondRucksack) AS fsl
CROSS APPLY (VALUES (ASCII(fsl.CommonLetters))) ca (asciiValue)
)
SELECT 
	SUM(calculatePriority.itemPriority) AS Result
FROM calculatePriority


/*
###############################################################################
	Part 2
###############################################################################
*/
/* this approach seems better and would work for Part 1 as well */

DROP TABLE IF EXISTS day3.Alphabet
CREATE TABLE day3.Alphabet
(
	id tinyint IDENTITY (1,1) PRIMARY KEY
	, Letter char(1) NOT NULL
)

/* insert all unique Alphabet letters (both cases) and their value into a table */
INSERT INTO day3.Alphabet (Letter)
SELECT 
	ss.value
FROM STRING_SPLIT('a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z', ',') AS ss 

;WITH mapping 
AS
(
	SELECT 
		i.Id
		, i.Input
		, (i.Id - 1) / 3 AS GroupOfThree
		, a.Letter
		, a.id AS LetterValue
	FROM day3.Input AS i
	LEFT JOIN day3.Alphabet AS a 
		ON CHARINDEX(a.Letter, i.Input COLLATE Latin1_General_CS_AS) > 0
)
, findBadgePerGroup
AS
(
	SELECT 
		m.GroupOfThree, m.LetterValue
	FROM mapping AS m
	GROUP BY m.GroupOfThree, m.LetterValue
	HAVING COUNT(1) = 3
)
SELECT 
	SUM(fbpg.LetterValue) AS Result
FROM findBadgePerGroup  AS fbpg
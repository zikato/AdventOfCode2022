/*
USE AoC2022
GO
CREATE SCHEMA day5
GO
*/

DROP TABLE IF EXISTS #Stage
CREATE TABLE #Stage
(
	MoveText char(4)
	, CrateCount tinyint 
	, FromText char(4)
	, FromCol tinyint 
	, ToText char(2)
	, ToCol tinyint 
)

GO
DROP TABLE IF EXISTS Day5.Crane
CREATE TABLE Day5.Crane
(
	Id tinyint NOT NULL
    , Crates varchar(80)
)
GO

DROP TABLE IF EXISTS day5.Input
CREATE TABLE day5.Input
(
	Id int IDENTITY NOT NULL PRIMARY KEY
	, CrateCount tinyint NOT NULL
	, FromCol tinyint NOT NULL
	, ToCol tinyint NOT NULL
)

/* UTF8 encoding, lineends = CRLF */
BULK INSERT #Stage
FROM 'D:\AdventOfCode2022\day5\input.txt'
WITH
(
	FIRSTROW = 1
	, FIELDTERMINATOR = ' '
	, ROWTERMINATOR = '\n'
	, KEEPNULLS
	, TABLOCK
)

/* Inserting the crane schema manually instead of dynamically - might get back to it later */
INSERT INTO Day5.Crane 
(Id, Crates)
VALUES 
	(1, 'MJCBFRLH')
	, (2, 'ZCD')
	, (3, 'HJFCNGW')
	, (4, 'PJDMTSB')
	, (5, 'NCDRJ')
	, (6, 'WLDQPJGZ')
	, (7, 'PZTFRH')
	, (8, 'LVMG')
	, (9, 'CBGPFQRJ')


INSERT INTO day5.Input WITH (TABLOCKX)
(CrateCount, FromCol, ToCol)
SELECT 
	s.CrateCount
	, s.FromCol
	, s.ToCol
FROM #Stage AS s
OPTION (MAXDOP 1)

SELECT @@ROWCOUNT /* plug into the @totalRows variable  */

/*
###############################################################################
	Part 1
###############################################################################
*/

/* since I need a previous result, either I have to loop or recurse */


DECLARE
	@totalRows int = 503
	, @currentRowId int = 1
	, @CrateCount tinyint
	, @FromCol tinyint
	, @ToCol tinyint

DROP TABLE IF EXISTS #Crane
SELECT 
	c.Id, c.Crates
INTO #Crane
FROM day5.Crane AS c



WHILE @currentRowId <= @totalRows
BEGIN

	--SELECT 'Before' AS Timepoint,  * FROM #Crane AS c 

	SELECT 
		@CrateCount = i.CrateCount
		, @FromCol = i.FromCol
		, @ToCol = i.ToCol
	FROM day5.Input AS i
	WHERE i.Id = @currentRowId

	UPDATE #Crane
		SET Crates += (SELECT reverse (RIGHT(c.Crates, @CrateCount)) FROM #Crane AS c WHERE c.Id = @FromCol)
	WHERE Id = @ToCol

	--SELECT 'CopyTo' AS Timepoint,  * FROM #Crane AS c 

	UPDATE #Crane
		SET Crates = SUBSTRING(Crates, 1, LEN(Crates) - @CrateCount)
	WHERE Id = @FromCol

	--SELECT 'RemoveFrom' AS Timepoint,  * FROM #Crane AS c 
	SET @currentRowId +=1
END 

SELECT 
	STRING_AGG(RIGHT(c.Crates, 1),'') WITHIN GROUP (ORDER BY c.Id)
FROM #Crane AS c 

/*
###############################################################################
	Part 2 - just remove the reverse
###############################################################################
*/

GO

DECLARE
	@totalRows int = 503
	, @currentRowId int = 1
	, @CrateCount tinyint
	, @FromCol tinyint
	, @ToCol tinyint

DROP TABLE IF EXISTS #Crane
SELECT 
	c.Id, c.Crates
INTO #Crane
FROM day5.Crane AS c



WHILE @currentRowId <= @totalRows
BEGIN

	--SELECT 'Before' AS Timepoint,  * FROM #Crane AS c 

	SELECT 
		@CrateCount = i.CrateCount
		, @FromCol = i.FromCol
		, @ToCol = i.ToCol
	FROM day5.Input AS i
	WHERE i.Id = @currentRowId

	UPDATE #Crane
		SET Crates += (SELECT RIGHT(c.Crates, @CrateCount) FROM #Crane AS c WHERE c.Id = @FromCol)
	WHERE Id = @ToCol

	--SELECT 'CopyTo' AS Timepoint,  * FROM #Crane AS c 

	UPDATE #Crane
		SET Crates = SUBSTRING(Crates, 1, LEN(Crates) - @CrateCount)
	WHERE Id = @FromCol

	--SELECT 'RemoveFrom' AS Timepoint,  * FROM #Crane AS c 
	SET @currentRowId +=1
END 

SELECT 
	STRING_AGG(RIGHT(c.Crates, 1),'') WITHIN GROUP (ORDER BY c.Id)
FROM #Crane AS c 
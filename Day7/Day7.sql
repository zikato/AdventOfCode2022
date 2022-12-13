/*
USE AoC2022
GO
CREATE SCHEMA day7
GO
*/

DROP TABLE IF EXISTS #Stage
CREATE TABLE #Stage
(
	Input varchar(50)
)

DROP TABLE IF EXISTS day7.Input
CREATE TABLE day7.Input
(
    Id int IDENTITY(1,1)
    , Terminal varchar(50) NOT NULL
    , Command varchar( 20) NULL
)

GO

/* UTF8 encoding, lineends = CRLF */
BULK INSERT #Stage
FROM 'D:\AdventOfCode2022\day7\input.txt'
WITH
(
	FIRSTROW = 1
	, FIELDTERMINATOR = ' '
	, ROWTERMINATOR = '\n'
	, KEEPNULLS
	, TABLOCK
)

TRUNCATE TABLE #Stage
INSERT INTO #Stage (Input)
VALUES 
('$ cd /')
,('$ ls')
,('dir a')
,('14848514 b.txt')
,('8504156 c.dat')
,('dir d')
,('$ cd a')
,('$ ls')
,('dir e')
,('29116 f')
,('2557 g')
,('62596 h.lst')
,('$ cd e')
,('$ ls')
,('584 i')
,('$ cd ..')
,('$ cd ..')
,('$ cd d')
,('$ ls')
,('4060174 j')
,('8033020 d.log')
,('5626152 d.ext')
,('7214296 k')




INSERT INTO day7.Input WITH (TABLOCKX)
(Terminal, Command)
SELECT 
	s.Input
    , IIF(LEFT(s.Input, 1) = '$', s.Input, NULL)
FROM #Stage AS s
WHERE s.Input <> '$ ls'
OPTION (MAXDOP 1)


/*
###############################################################################
	Part 1
###############################################################################
*/



; WITH shredding
AS
(
    SELECT 
	    *
        , SUM
        (
            CASE
                WHEN i.Command = '$ cd /' THEN 0
                WHEN i.Command = '$ cd ..' THEN -1 
                WHEN LEFT(i.Command, 4) = '$ cd' THEN 1
                ELSE NULL
            END
        ) OVER (ORDER BY Id) AS Lvl
        , IIF (LEFT(i.Command, 4) = '$ cd', SUBSTRING(i.Command, 6, LEN(i.Command)), null) AS ParentFolder
        , IIF (LEFT(i.Terminal, 4) = 'dir ', SUBSTRING(i.Terminal, 5, LEN(i.Terminal)), null) AS ChildFolder
        , IIF (TRY_CAST(LEFT(i.Terminal, 1) AS int) IS NOT NULL, CAST(SUBSTRING(i.Terminal,1, CHARINDEX(' ', i.Terminal)) AS int), NULL) AS FileSize
        , IIF (TRY_CAST(LEFT(i.Terminal, 1) AS int) IS NOT NULL, SUBSTRING(i.Terminal, CHARINDEX(' ', i.Terminal)+1, LEN(i.Terminal)), NULL) AS FileName
    FROM day7.Input AS i 

)
SELECT 
	*
    , ROW_NUMBER() OVER (PARTITION BY shredding.Lvl ORDER BY Id) AS rn
    /*  when lvl changes from lower to higer (next > current) 
        when lvl changes from higher to lower (current > lower) 
    */
FROM shredding
ORDER BY shredding.Id

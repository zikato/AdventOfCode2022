/*
USE AoC2022
GO
CREATE SCHEMA day8
GO
*/


DROP TABLE IF EXISTS #Stage
CREATE TABLE #Stage
(
	TreeLine char(100)
	)

DROP TABLE IF EXISTS day8.Input
CREATE TABLE day8.Input
(
	RowId int IDENTITY NOT NULL
	, TreeLine char(100) NOT NULL
)

DROP TABLE IF EXISTS day8.TreeMap
CREATE TABLE day8.TreeMap
(
	RowId smallint NOT NULL
	, ColId smallint NOT NULL
	, Tree smallint NOT NULL
    , CONSTRAINT PK_day8_TreeMap PRIMARY KEY  (ColId, RowId)
)



BULK INSERT #Stage
FROM 'D:\AdventOfCode2022\day8\input.txt'
WITH
(
	FIRSTROW = 1
	, ROWTERMINATOR = '\n'
	, KEEPNULLS
	, TABLOCK
)


-- uncomment to use the Table from Example 
    TRUNCATE TABLE #Stage

    INSERT INTO #Stage (TreeLine)
    VALUES 
          ('30373')
        , ('25512')
        , ('65332')
        , ('33549')
        , ('35390')



INSERT INTO day8.Input WITH (TABLOCKX)
(TreeLine)
SELECT 
    s.TreeLine
FROM #Stage AS s
OPTION (MAXDOP 1)

DECLARE @rowLength int;

SET @rowLength = (SELECT LEN(i.TreeLine) FROM day8.Input AS i WHERE i.RowId = 1)
SELECT @rowLength AS RowLength

/*
30373
25512
65332
33549
35390
	R	C
3	1	1		L	T				1
0	1	2			T				2
3	1	3			T				3
7	1	4			T	R			4
3	1	5			T	R			5
2	2	1		L					@rowLength +1
5   2   2		L	T				7
5   2   3			T				8
1   2   4					
2   2   5				R			9
@rowLength +1	3	1		L					10
5   3   2
3   3   3
3   3   4				R			11
2   3   5				R			12
3	4	1		L					13
3   4   2
5   4   3					B		14
4   4   4
9   4   5				R	B		15
3	5	1		L			B		16
5   5   2					B		17
3   5   3					B		18
9   5   4					B		19
0   5   5				R	B		20

*/

/*
###############################################################################
	One manual level of nesting
###############################################################################
*/
; -- Previous statement must be properly terminated
WITH
  L0   AS(SELECT 1 AS c UNION ALL SELECT 1),
  L1   AS(SELECT 1 AS c FROM L0 CROSS JOIN L0 AS B),
  L2   AS(SELECT 1 AS c FROM L1 CROSS JOIN L1 AS B),
  L3   AS(SELECT 1 AS c FROM L2 CROSS JOIN L2 AS B),
  L4   AS(SELECT 1 AS c FROM L3 CROSS JOIN L3 AS B),
  L5   AS(SELECT 1 AS c FROM L4 CROSS JOIN L4 AS B),
  Nums AS(SELECT ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS n FROM L5)
, tally AS (SELECT TOP (@rowLength) n AS ColId FROM Nums ORDER BY n)
INSERT INTO day8.TreeMap WITH (TABLOCKX)
(RowId, ColId, Tree) 
SELECT 
	i.RowId AS TreeRow
        , t.ColId AS TreeCol
        , CAST(SUBSTRING(i.TreeLine, t.ColId, 1) AS smallint) AS Tree
FROM tally AS t 
CROSS JOIN day8.Input AS i




; -- Previous statement must be properly terminated
WITH leftToRight
AS
(
    SELECT 
	    tm.ColId AS CurrentCol
        , tm.RowId AS CurrentRow
        , tm.Tree AS TallestTree
        , CAST(1 AS tinyint) AS IsVisible
    FROM day8.TreeMap AS tm
    WHERE tm.ColId = 1
)
SELECT 
	*
FROM leftToRight AS ltr
UNION ALL
SELECT 
	tm.ColId
    , tm.RowId
    , IIF(tm.Tree > ltr.TallestTree, tm.Tree, ltr.TallestTree) AS TallestTree
    , IIF(tm.Tree > ltr.TallestTree, 1, 0) AS IsVisible
FROM leftToRight AS ltr
JOIN day8.TreeMap AS tm
    ON tm.ColId = ltr.CurrentCol +1
    AND tm.RowId = ltr.CurrentRow
ORDER BY ltr.CurrentCol


/*
###############################################################################
	Recursion from a single direction
###############################################################################
*/

; -- Previous statement must be properly terminated
WITH leftToRight
AS
(
    SELECT 
	    tm.ColId AS CurrentCol
        , tm.RowId AS CurrentRow
        , tm.Tree AS TallestTree
        , tm.Tree AS CurrentTree
        , 1 AS IsVisible
    FROM day8.TreeMap AS tm
    WHERE tm.ColId = 1
    UNION ALL
    SELECT 
	    tm.ColId
        , tm.RowId
        , IIF(tm.Tree > ltr.TallestTree, tm.Tree, ltr.TallestTree) AS TallestTree
        , tm.Tree AS TallestTree
        , IIF(tm.Tree > ltr.TallestTree, 1, 0) AS IsVisible
    FROM leftToRight AS ltr
    JOIN day8.TreeMap AS tm
        ON tm.ColId = ltr.CurrentCol +1
        AND tm.RowId = ltr.CurrentRow
    WHERE ltr.CurrentCol <= 5
)
SELECT 
	COUNT(1)
FROM leftToRight AS ltr
WHERE ltr.IsVisible = 1
GROUP BY currentCol, ltr.CurrentRow
ORDER BY ltr.CurrentCol, ltr.CurrentRow

/*
###############################################################################
	transform the directions
###############################################################################
*/

DROP TABLE IF EXISTS day8.Transformation
CREATE TABLE day8.Transformation
( 
    Direction tinyint         NOT NULL
    , OrigRow smallint        NOT NULL
    , OrigCol smallint        NOT NULL
    , Tree smallint           NOT NULL
    , DirectionCol smallint   NOT NULL
    , DirectionRow smallint   NOT NULL
    , CONSTRAINT PK_day8_Transformation PRIMARY KEY
        (DirectionCol, DirectionRow, Direction)
)

INSERT INTO day8.Transformation WITH (TABLOCKX)
(Direction, OrigRow, OrigCol, Tree, DirectionCol, DirectionRow)
SELECT 
        direction.Direction
	    , tm.RowId
        , tm.ColId 
        , tm.Tree
        , CASE direction.Direction 
            WHEN 1 THEN tm.ColId
            WHEN 2 THEN tm.RowId /* col = row */
            WHEN 3 THEN @rowLength + 1 - tm.ColId  /* reverse order */
            WHEN 4 THEN @rowLength + 1 - tm.RowId    /* reverse order */
          END AS DirectionCol
        , CASE direction.Direction
            WHEN 1 THEN tm.RowId
            WHEN 2 THEN tm.ColId /* row = col */
            WHEN 3 THEN tm.RowId
            WHEN 4 THEN tm.ColId
          END AS DirectionRow
    FROM day8.TreeMap AS tm
    CROSS JOIN (VALUES(1), (2), (3), (4)) direction (Direction) /* 1 = LeftToRight, 2 = TopToBottom , 3 = RightToLeft, 4 = BottomToTop */

/*
###############################################################################
	Testing the transformation
###############################################################################
*/

SELECT 
	*
FROM day8.Transformation AS t
/* Testing to check if the transformations are correct */
WHERE 1=1
AND t.Direction = 1
AND t.DirectionCol = 2
ORDER BY t.DirectionCol, t.DirectionRow


/*
###############################################################################
	One manual level of transformed nesting
###############################################################################
*/

; -- Previous statement must be properly terminated
WITH anchor
AS
(
    SELECT
        tm.Direction
        , tm.OrigRow
        , tm.OrigCol
        , tm.DirectionCol
        , tm.DirectionRow
        , tm.Tree AS TallestTree
        , 1 AS IsVisible
    FROM day8.Transformation AS tm
    WHERE tm.DirectionCol = 1
)
SELECT 
	*
FROM anchor AS a
UNION ALL
SELECT 
	tm.Direction
    , tm.OrigRow
    , tm.OrigCol
    , tm.DirectionCol
    , tm.DirectionRow
    , IIF(tm.Tree > a.TallestTree, tm.Tree, a.TallestTree) AS TallestTree
    , IIF(tm.Tree > a.TallestTree, 1, 0) AS IsVisible      
FROM anchor AS a
JOIN day8.Transformation AS tm
    ON tm.Direction = a.Direction
    AND tm.DirectionRow = a.DirectionRow
    AND tm.DirectionCol = a.DirectionCol + 1
WHERE tm.DirectionCol < @rowLength +1

/*
###############################################################################
	Final version part 1
###############################################################################
*/

; -- Previous statement must be properly terminated
WITH anchor
AS
(
    SELECT
        tm.Direction
        , tm.OrigRow
        , tm.OrigCol
        , tm.DirectionCol
        , tm.DirectionRow
        , tm.Tree AS TallestTree
        , 1 AS IsVisible
    FROM day8.Transformation AS tm
    WHERE tm.DirectionCol = 1
    UNION ALL
    SELECT 
	    tm.Direction
        , tm.OrigRow
        , tm.OrigCol
        , tm.DirectionCol
        , tm.DirectionRow
        , IIF(tm.Tree > a.TallestTree, tm.Tree, a.TallestTree) AS TallestTree
        , IIF(tm.Tree > a.TallestTree, 1, 0) AS IsVisible      
    FROM anchor AS a
    JOIN day8.Transformation AS tm
        ON tm.Direction = a.Direction
        AND tm.DirectionRow = a.DirectionRow
        AND tm.DirectionCol = a.DirectionCol + 1
    WHERE tm.DirectionCol < @rowLength +1
), distinctTrees
AS
(
    SELECT 
	    a.OrigRow, a.OrigCol
    FROM anchor AS a
    WHERE a.IsVisible = 1
    GROUP BY a.OrigRow, a.OrigCol
)
SELECT COUNT(1) AS Result
FROM distinctTrees AS dt


/*
###############################################################################
	Part 2
###############################################################################
*/

/* find the ideal spot from the example */
SELECT 
	*
FROM day8.Transformation AS t
WHERE 1=1
AND t.OrigCol = 3
AND t.OrigRow = 4

/* Left to Right    33549 */
SELECT 
	*
FROM day8.Transformation AS t
WHERE 1=1
AND Direction = 1
AND t.OrigRow = 4
ORDER BY t.DirectionCol

/* Right to Left    94533 */
SELECT 
	*
FROM day8.Transformation AS t
WHERE 1=1
AND Direction = 3
AND t.OrigRow = 4
ORDER BY t.DirectionCol

/* Top to Bottom    35353 */
SELECT 
	*
FROM day8.Transformation AS t
WHERE 1=1
AND Direction = 2
AND t.OrigCol = 3
ORDER BY t.DirectionRow

/* Bottom to Top    35353 */
SELECT 
	*
FROM day8.Transformation AS t
WHERE 1=1
AND Direction = 4
AND t.OrigCol = 3
ORDER BY t.DirectionRow


/* find the ideal spot from the example */
SELECT 
	*
FROM day8.Transformation AS t
WHERE 1=1
AND t.DirectionRow = 4
ORDER BY t.Direction, t.DirectionCol


SELECT 
	*
FROM day8.TreeMap AS tm 
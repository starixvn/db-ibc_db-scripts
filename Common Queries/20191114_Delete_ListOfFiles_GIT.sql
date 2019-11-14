/*
	Created: 20191114@Percy
	Run on local PC
*/

DECLARE @rootPath VARCHAR(50) = 'D:\GIT\' -- GIT folder

DECLARE @fileName TABLE ([fileName] NVARCHAR(260))
INSERT INTO @fileName ([fileName])
SELECT 'Task_DailyRptPokerGamesSumWinLoss' UNION ALL
SELECT 'Task_DailyRptPokerGamesSumWinLoss_Job' UNION ALL
SELECT 'Task_DailyRptPokerGamesSumWinLoss_CheckData' UNION ALL
SELECT 'Task_DailyRptPokerGamesSumWinLoss_CheckData_Job'

-- get all subdirectory (sub folder)
IF OBJECT_ID('tempdb..#subdirectory') IS NOT NULL
	DROP TABLE #subdirectory;

CREATE TABLE #subdirectory
(
	id				INT IDENTITY(1,1)
	,subdirectory	NVARCHAR(260)
	,depth			INT
	,is_file		BIT
	,parentId		INT
);

INSERT INTO #subdirectory (subdirectory,depth,is_file)
EXEC master.sys.xp_dirtree @rootPath,0,1;

UPDATE T1
SET T1.ParentId = (SELECT MAX(Id) FROM #subdirectory T2 WHERE T2.Depth = T1.Depth - 1 AND T2.Id < T1.Id)
FROM #subdirectory T1

DELETE T
FROM #subdirectory T
	LEFT JOIN @fileName f ON T.subdirectory LIKE '%' + f.[fileName] + '[.]%'
							OR T.subdirectory LIKE '%' + f.[fileName] + ']' + '[.]%'
WHERE T.is_file = 1
	AND f.[fileName] IS NULL

;WITH CTE_subdirectory AS (
	SELECT t.id,t.subdirectory,t.depth,t.is_file
	FROM #subdirectory t
	WHERE is_file = 0
	
	UNION ALL
	SELECT t.id, CAST(c.subdirectory + '\' + t.subdirectory AS NVARCHAR(260)),t.depth,t.is_file
	FROM #subdirectory t
		INNER JOIN CTE_subdirectory c ON c.id = t.parentId

)
SELECT c.id, c.subdirectory, c.depth, c.is_file
INTO #__tmpResult
FROM CTE_subdirectory c
	INNER JOIN #subdirectory t ON c.subdirectory LIKE t.subdirectory + '[\]%'
WHERE c.is_file = 1 AND t.depth = 1

UNION ALL
SELECT id, subdirectory, depth, is_file
FROM #subdirectory
WHERE is_file = 1 AND depth = 1

--------
declare @sql varchar(max) = ''
select  @sql = @sql + 'del ' + @rootPath + subdirectory + char(10)
from #__tmpResult

select cast(@sql as xml)

-- get result then copy and paste to command line --> done :)

drop table #__tmpResult
drop table #subdirectory

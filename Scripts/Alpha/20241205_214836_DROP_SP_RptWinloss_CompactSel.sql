/*<info serverAlias="DBAGE-bodb02"></info>*/
/*
	Created: 20241205@Lewis
	DB: DBAGE
	Task: ALPHA - RPT Winloss - Drop SPs _CompactSel [Redmine: #214836]
*/

USE BODB02

GO
---------STEP 1: Mark delete for Tables -----------------------------------
DECLARE @end INT = 1, @start INT = 1

CREATE TABLE #Tables_MarkDelete (ID INT IDENTITY (1,1),ObjectName VARCHAR (200))

INSERT INTO #Tables_MarkDelete (ObjectName)
VALUES
('Age_Rpt_WinLoss_Master_CompactSel'),
('Age_Rpt_WinLoss_Agent_CompactSel'),
('Age_Rpt_WinLoss_Member_CompactSel')

SET @end = (SELECT MAX(ID) FROM #Tables_MarkDelete)
DECLARE @sql NVARCHAR(MAX) = ''

WHILE @start < = @end
BEGIN
	SELECT @sql = 'sp_rename '''	+  ObjectName + ''',''' + 'DEL_' + ObjectName + ''
	FROM #Tables_MarkDelete
	WHERE ID = @start
	
	PRINT 'In progress:' + @sql
	
	BEGIN TRY
		EXEC (@sql)
		PRINT 'Done: ' + @sql
	END TRY
	BEGIN CATCH
		PRINT 'Failed: OBJECT NOT EXISTS - ' + @sql 
	END CATCH
	
	SET @start = @start + 1
	
END

DROP TABLE #Tables_MarkDelete

GO


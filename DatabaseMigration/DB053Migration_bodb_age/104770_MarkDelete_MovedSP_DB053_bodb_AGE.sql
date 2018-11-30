/*
	Created: 20181122@Helen
	Task: DB053.bodb_AGE/BODB02 & DB052.bodb_Summary Migration - [Redmine:104770]
	SERVER: DB053/bodb_AGE
*/
USE bodb_AGE

GO	
---------STEP 1: Mark delete for Tables -----------------------------------
DECLARE @end INT = 1, @start INT = 1

CREATE TABLE #Tables_MarkDelete (ID INT IDENTITY (1,1),ObjectName VARCHAR (200))

INSERT INTO #Tables_MarkDelete (ObjectName)
VALUES
('Acc_CustGroupAddByUsername'),
('Acc_CustGroupAddByUsername_Multiple'),
('Acc_CustGroupDel'),
('Acc_CustGroupSel'),
('Acc_CustomerDateLimitDel'),
('Acc_CustomerDateLimitIns'),
('Acc_CustomerDateLimitSel'),
('Age_CustomerSelDateLimit'),
('Age_CustomerSelProfilePicture'),
('Age_CustomerSelSuggestUsername'),
('Age_CustomerUpdProfilePicture'),
('EAS_CustomerDateLimitMultipleUpd'),
('EAS_CustomerDateLimitSel'),
-- SP not use anymore after release
('Acc_CustGroupSelGroup')

SET @end = (SELECT MAX(ID) FROM #Tables_MarkDelete)
DECLARE @sql NVARCHAR(MAX) = ''

WHILE @start < = @end
BEGIN
	SELECT @sql = 'sp_rename '''	+  ObjectName + ''',''' + ObjectName + '_delete'''
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


/*
	Created: 20181122@Helen
	Task: DB053.bodb_AGE/BODB02 & DB052.bodb_Summary Migration - [Redmine:104770]
	DB: DB053/bodb02; DB052/bodb02
*/
USE bodb02

GO
---------STEP 1: Mark delete for Tables -----------------------------------
DECLARE @end INT = 1, @start INT = 1

CREATE TABLE #Tables_MarkDelete_SP (ID INT IDENTITY (1,1),ObjectName VARCHAR (200))
CREATE TABLE #Tables_MarkDelete_View (ID INT IDENTITY (1,1),ObjectName VARCHAR (200))

------------------ SP process --------------
INSERT INTO #Tables_MarkDelete_SP (ObjectName)
SELECT 'DataSync' + '.[' + name + ']' as ObjectName
FROM sys.procedures (nolock)
WHERE OBJECT_SCHEMA_NAME([object_id]) = 'DataSync'

SET @end = (SELECT MAX(ID) FROM #Tables_MarkDelete_SP)
DECLARE @sql NVARCHAR(MAX) = ''

WHILE @start < = @end
BEGIN
	SELECT @sql = 'DROP PROC ' + ObjectName 
	FROM #Tables_MarkDelete_SP
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

------------------ VIEW process --------------
INSERT INTO #Tables_MarkDelete_View (ObjectName)
SELECT 'DataSync' + '.[' + name + ']' as ObjectName
FROM sys.procedures (nolock)
WHERE OBJECT_SCHEMA_NAME([object_id]) = 'DataSync'

SET @start = 1
SET @end = (SELECT MAX(ID) FROM #Tables_MarkDelete_View)

DECLARE @sql_view NVARCHAR(MAX) = ''

WHILE @start < = @end
BEGIN
	SELECT @sql = 'DROP VIEW ' + ObjectName 
	FROM #Tables_MarkDelete_View
	WHERE ID = @start
	
	PRINT 'In progress:' + @sql_view
	
	BEGIN TRY
		EXEC (@sql_view)
		PRINT 'Done: ' + @sql_view
	END TRY
	BEGIN CATCH
		PRINT 'Failed: OBJECT NOT EXISTS - ' + @sql_view 
	END CATCH

	SET @start = @start + 1
	
END

DROP TABLE #Tables_MarkDelete_SP
DROP TABLE #Tables_MarkDelete_View

GO


/*
	Created: 20181002@Helen
	Task: DB052.bodb_NAP migration - [Redmine:100493]
	SERVER: DB052/bodb_NAP
*/
USE bodb_NAP

GO
---------STEP 1: Mark delete for Tables -----------------------------------
DECLARE @end INT = 1, @start INT = 1

CREATE TABLE #Tables_MarkDelete (ID INT IDENTITY (1,1),ObjectName VARCHAR (200))

INSERT INTO #Tables_MarkDelete (ObjectName)
VALUES
('UserMarkedMenus'),
('MenuItems'),
('Sites'),
('SiteURL'),
('UserFunction'),
('Users'),
('UserSite'),
('Functions'),
('OnUser'),
--('UserFunction_20171004'),
--('UserSite_20171004'),
('ObjectType'),
('GroupFunction'),
('Groups')

SET @end = (SELECT MAX(ID) FROM #Tables_MarkDelete)
DECLARE @sql NVARCHAR(MAX) = ''

WHILE @start < = @end
BEGIN
	SELECT @sql = 'DROP TABLE ' + ObjectName 
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


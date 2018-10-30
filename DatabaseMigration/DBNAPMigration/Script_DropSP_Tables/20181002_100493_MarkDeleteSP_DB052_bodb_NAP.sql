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
('NAP_AdminGeneralInfo_Update'),
('NAP_AdminIns'),
('NAP_Cust_GetByUsername'),
('NAP_Home_CheckPermissionByMenuUserId'),
('NAP_Home_GetMarkedMenus'),
('NAP_Home_GetMenusBySiteUserId'),
('NAP_Home_GetTopMarkedMenus'),
('NAP_Home_GetUserSites'),
('NAP_Home_SearchMenus'),
('NAP_Home_UpdateMarkedMenu'),
('NAP_LogExecSp_Insert'),
('NAP_LogFunction_Insert'),
('NAP_LogFunction_Search'),
('NAP_User_AssignSite'),
('NAP_User_DeleteUserFromNAPAdmin'),
('Task_NAP_SyncUserFunction'),
('Task_STDBY_Sync_NAP'),
('Task_STDBY_Sync_OddsFeed')

SET @end = (SELECT MAX(ID) FROM #Tables_MarkDelete)
DECLARE @sql NVARCHAR(MAX) = ''

WHILE @start < = @end
BEGIN
	SELECT @sql = 'DROP PROC ' + ObjectName + '_delete'
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


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
('NAP_Cust_Insert'),
('NAP_Cust_Update'),
('NAP_Function_AssignFunctionToGroups'),
('NAP_Function_AssignFunctionToUsers'),
('NAP_Function_Duplicate'),
('NAP_Function_GetAll'),
('NAP_Function_GetByGroup'),
('NAP_Function_GetByGroupAndSite'),
('NAP_Function_GetById'),
('NAP_Function_GetByKeyAndSite'),
('NAP_Function_GetByNameAndSite'),
('NAP_Function_GetBySite'),
('NAP_Function_GetByUser'),
('NAP_Function_GetByUserAndFunctionKeyIncludeGroup'),
('NAP_Function_GetByUserAndSite'),
('NAP_Function_GetByUserAndSiteIncludeGroup'),
('NAP_Function_GetParentById'),
('NAP_Function_Insert'),
('NAP_Function_Update'),
('NAP_Function_UpdateStatus'),
('NAP_Functions_GenerateNAPFunction'),
('NAP_Group_AssignFunction'),
('NAP_Group_GetAll'),
('NAP_Group_GetAllWithNumOfUser'),
('NAP_Group_GetById'),
('NAP_Group_GetByName'),
('NAP_Group_GetByUser'),
('NAP_Group_GetGroupByFunctionAndSite'),
('NAP_Group_Insert'),
('NAP_Group_SearchExcludeFunction'),
('NAP_Group_Update'),
('NAP_Group_UpdateStatus'),
('NAP_Home_CheckUserPermissionByMenu'),
('NAP_Home_CheckUserPermissionBySite'),
('NAP_Home_CheckUserSiteAccess'),
('NAP_Home_MainPage'),
('NAP_LogExecSp_GetById'),
('NAP_LogExecSp_Search'),
('NAP_LogUserLogin_Insert'),
('NAP_LogUserLogin_Insert_MNL'),
('NAP_LogUserLogin_Search'),
('NAP_MenuItem_GetAll'),
('NAP_MenuItem_GetById'),
('NAP_MenuItem_GetByNameAndSite'),
('NAP_MenuItem_GetBySite'),
('NAP_MenuItem_GetByUserAndSiteIncludeGroup'),
('NAP_MenuItem_GetParentById'),
('NAP_MenuItem_Insert'),
('NAP_MenuItem_Search'),
('NAP_MenuItem_Update'),
('NAP_MenuItem_UpdateStatus'),
('NAP_Site_GetAll'),
('NAP_Site_GetAllSiteUrl'),
('NAP_Site_GetAllWithNumOfUser'),
('NAP_Site_GetById'),
('NAP_Site_GetByKey'),
('NAP_Site_GetByName'),
('NAP_Site_GetByUser'),
('NAP_Site_GetSiteURLById'),
('NAP_Site_GetSiteURLBySiteId'),
('NAP_Site_GetSiteURLByUser'),
('NAP_Site_GetUserSiteLevel'),
('NAP_Site_InsertSiteURL'),
('NAP_Site_InsertWithSiteURL'),
('NAP_Site_Update'),
('NAP_Site_UpdateDefaultSiteURL'),
('NAP_Site_UpdateSiteURL'),
('NAP_Site_UpdateStatus'),
('NAP_User_AssignFunction'),
('NAP_User_AssignNewSite'),
('NAP_User_ChangeUserSiteStatus'),
('NAP_User_CheckIn'),
('NAP_User_CheckIn_MNL'),
('NAP_User_CheckPermission'),
('NAP_User_GetAll'),
('NAP_User_GetAllByUsernameGroupSite'),
('NAP_User_GetAvailableSites'),
('NAP_User_GetByGroupAndSite'),
('NAP_User_GetById'),
('NAP_User_GetBySite'),
('NAP_User_GetByUsername'),
('NAP_User_GetUserByFunctionAndSite'),
('NAP_User_GetUserFunctionPolicy'),
('NAP_User_GetUserListSiteFunctionKeyPolicy'),
('NAP_User_GetUserSiteFunctionKeyPolicy'),
('NAP_User_GetUserSiteLevel'),
('NAP_User_Insert'),
('NAP_User_Logout'),
('NAP_User_ReCheckIn'),
('NAP_User_Search'),
('NAP_User_SearchByUsername'),
('NAP_User_SearchExcludeFunction'),
('NAP_User_SSOCheckIn'),
('NAP_User_SSOCheckIn_MNL'),
('NAP_User_SSOGetTime'),
('NAP_User_UpdateSite'),
('NAP_User_UpgradeUserToPortalAdmin'),
('Task_NAP_RevokeUserPermission')

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


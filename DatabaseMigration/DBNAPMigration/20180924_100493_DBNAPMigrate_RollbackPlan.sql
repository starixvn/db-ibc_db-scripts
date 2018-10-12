/*
	Created: 20180806@Helen
	Task: DB05.DBPOLICY migration - [Redmine:99462]
	SERVER: DB052/bodb_NAP
	
	Tables:
		1.UserMarkedMenus
		2. MenuItems
		3. Sites
		4. SiteURL
		5. UserFunction
		6. Users
		7. UserSite
		8. Functions
--		OnUser
		9. ObjectType
		10. GroupFunction
		11. Groups

*/
USE bodb_NAP
GO
-- Table 1: UserMarkedMenus
MERGE dbo.UserMarkedMenus TARGET
USING (
	SELECT   UserId, MenuItemId, IsMarked, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate
	FROM	DBPOL.NAP_UserControl.dbo.NAP_UserMarkedMenus t1 WITH (NOLOCK)
) AS SOURCE
	ON	TARGET.UserId = SOURCE.UserId AND TARGET.MenuItemId = SOURCE.MenuItemId
WHEN	MATCHED THEN
	UPDATE SET 
		IsMarked = SOURCE.IsMarked
		,CreatedBy = SOURCE.CreatedBy
		,CreatedDate = SOURCE.CreatedDate
		,ModifiedBy = SOURCE.ModifiedBy
		
WHEN NOT MATCHED BY TARGET THEN	
	INSERT (UserId, MenuItemId, IsMarked, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	VALUES(SOURCE.UserId, SOURCE.MenuItemId, SOURCE.IsMarked, SOURCE.CreatedBy, SOURCE.CreatedDate, SOURCE.ModifiedBy, SOURCE.ModifiedDate)	

WHEN NOT MATCHED BY SOURCE THEN DELETE ;

GO	
-- Table 2: MenuItems	
SET IDENTITY_INSERT MenuItems ON
MERGE dbo.MenuItems TARGET
USING (
	SELECT   MenuItemId, FunctionId, SiteId, MenuItemName, Description, ParentId, ParentName, Policy, URL, DisplayOrder, IsActive, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, Environment
	FROM	DBPOL.NAP_UserControl.dbo.NAP_MenuItems t1 WITH (NOLOCK)
) AS SOURCE
	ON	TARGET.MenuItemId = SOURCE.MenuItemId
WHEN	MATCHED THEN
	UPDATE SET 
		FunctionId = SOURCE.FunctionId
		, SiteId = SOURCE.SiteId
		, MenuItemName = SOURCE.MenuItemName
		, Description = SOURCE.Description
		, ParentId = SOURCE.ParentId
		, ParentName = SOURCE.ParentName
		, Policy = SOURCE.Policy
		, URL = SOURCE.URL
		, DisplayOrder = SOURCE.DisplayOrder
		, IsActive = SOURCE.IsActive
		, CreatedBy = SOURCE.CreatedBy
		, CreatedDate = SOURCE.CreatedDate
		, ModifiedBy = SOURCE.ModifiedBy
		, ModifiedDate = SOURCE.ModifiedDate
		, Environment = SOURCE.Environment
		
WHEN NOT MATCHED BY TARGET THEN	
	INSERT (MenuItemId, FunctionId, SiteId, MenuItemName, Description, ParentId, ParentName, Policy, URL, DisplayOrder, IsActive, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, Environment)
	VALUES(SOURCE.MenuItemId, SOURCE.FunctionId, SOURCE.SiteId, SOURCE.MenuItemName, SOURCE.Description, SOURCE.ParentId, SOURCE.ParentName, SOURCE.Policy, SOURCE.URL, SOURCE.DisplayOrder, SOURCE.IsActive, SOURCE.CreatedBy, SOURCE.CreatedDate, SOURCE.ModifiedBy, SOURCE.ModifiedDate, SOURCE.Environment)	
WHEN NOT MATCHED BY SOURCE THEN DELETE ;
	
SET IDENTITY_INSERT MenuItems OFF

GO

-- Table 3: Sites
SET IDENTITY_INSERT Sites ON
MERGE dbo.Sites TARGET
USING (
	SELECT   SiteId, SiteName, Description, URL, TestURL, IsActive, Environment, SecretAccessKey, SiteKey
	FROM	DBPOL.NAP_UserControl.dbo.NAP_Sites t1 WITH (NOLOCK)
) AS SOURCE
	ON	TARGET.SiteId = SOURCE.SiteId
WHEN	MATCHED THEN
	UPDATE SET 
		SiteName =  SOURCE.SiteName, Description = SOURCE.Description, URL = SOURCE.URL, TestURL = SOURCE.TestURL
		, IsActive = SOURCE.IsActive, Environment = SOURCE.Environment, SecretAccessKey= SOURCE.SecretAccessKey, SiteKey = SOURCE.SiteKey
		
WHEN NOT MATCHED BY TARGET THEN	
	INSERT (SiteId, SiteName, Description, URL, TestURL, IsActive, Environment, SecretAccessKey, SiteKey)
	VALUES(SOURCE.SiteId, SOURCE.SiteName, SOURCE.Description, SOURCE.URL, SOURCE.TestURL, SOURCE.IsActive, SOURCE.Environment, SOURCE.SecretAccessKey, SOURCE.SiteKey)	
WHEN NOT MATCHED BY SOURCE THEN DELETE ;
SET IDENTITY_INSERT Sites OFF

GO
-- Table 4: SiteURL	
SET IDENTITY_INSERT SiteURL ON
MERGE dbo.SiteURL TARGET
USING (
	SELECT SiteURLId, SiteId, URL, Environment, IsDefault, IsActive
	FROM DBPOL.NAP_UserControl.dbo.NAP_SiteURL WITH (NOLOCK)
) AS SOURCE
	ON	TARGET.SiteURLId = SOURCE.SiteURLId
WHEN	MATCHED THEN
	UPDATE SET 
		SiteId = SOURCE.SiteId, URL = SOURCE.URL, Environment = SOURCE.Environment, IsDefault= SOURCE.IsDefault, IsActive = SOURCE.IsActive
		
WHEN NOT MATCHED BY TARGET THEN	
	INSERT ( SiteURLId, SiteId, URL, Environment, IsDefault, IsActive)
	VALUES( SOURCE.SiteURLId, SOURCE.SiteId, SOURCE.URL, SOURCE.Environment, SOURCE.IsDefault, SOURCE.IsActive)	
WHEN NOT MATCHED BY SOURCE THEN DELETE ;
SET IDENTITY_INSERT SiteURL OFF	
GO
-- Table 5: UserFunction
MERGE dbo.UserFunction TARGET
USING (
	SELECT UserId, FunctionId, SiteId, Policy, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate 
	FROM DBPOL.NAP_UserControl.dbo.NAP_UserFunction WITH (NOLOCK)
) AS SOURCE
	ON	TARGET.UserId = SOURCE.UserId AND TARGET.FunctionId = SOURCE.FunctionId
WHEN	MATCHED THEN
	UPDATE SET 
		SiteId = SOURCE.SiteId , Policy= SOURCE.Policy, CreatedBy= SOURCE.CreatedBy, CreatedDate= SOURCE.CreatedDate
		, ModifiedBy= SOURCE.ModifiedBy, ModifiedDate= SOURCE.ModifiedDate
		
WHEN NOT MATCHED BY TARGET THEN	
	INSERT (UserId, FunctionId, SiteId, Policy, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate )
	VALUES(SOURCE.UserId, SOURCE.FunctionId, SOURCE.SiteId, SOURCE.Policy, SOURCE.CreatedBy, SOURCE.CreatedDate, SOURCE.ModifiedBy, SOURCE.ModifiedDate )	

WHEN NOT MATCHED BY SOURCE THEN DELETE ;

GO
-- Table 6: Users

MERGE dbo.Users TARGET
USING (
	SELECT UserId, GroupId, LastLoginDate, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate
	FROM DBPOL.NAP_UserControl.dbo.NAP_Users WITH (NOLOCK)
) AS SOURCE
	ON	TARGET.UserId = SOURCE.UserId
WHEN	MATCHED THEN
	UPDATE SET 
		 GroupId= SOURCE.GroupId, LastLoginDate= SOURCE.LastLoginDate, CreatedBy= SOURCE.CreatedBy, CreatedDate= SOURCE.CreatedDate
		 , ModifiedBy= SOURCE.ModifiedBy, ModifiedDate= SOURCE.ModifiedDate
		
WHEN NOT MATCHED BY TARGET THEN	
	INSERT (UserId, GroupId, LastLoginDate, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	VALUES(UserId, GroupId, LastLoginDate, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)	

WHEN NOT MATCHED BY SOURCE THEN DELETE ;


GO
-- Table 7: UserSite
MERGE dbo.UserSite TARGET
USING (
	SELECT UserId, SiteId, Level, IsActive, LastLoginDate, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ExpiredDate, IsNeverExpired
	FROM DBPOL.NAP_UserControl.dbo.NAP_UserSite WITH (NOLOCK)
) AS SOURCE
	ON	TARGET.UserId = SOURCE.UserId AND TARGET.SiteId = SOURCE.SiteId
WHEN	MATCHED THEN
	UPDATE SET 
		Level= SOURCE.Level, IsActive= SOURCE.IsActive, LastLoginDate= SOURCE.LastLoginDate, CreatedBy= SOURCE.CreatedBy, CreatedDate= SOURCE.CreatedDate, ModifiedBy= SOURCE.ModifiedBy, ModifiedDate= SOURCE.ModifiedDate, ExpiredDate= SOURCE.ExpiredDate, IsNeverExpired= SOURCE.IsNeverExpired
		
WHEN NOT MATCHED BY TARGET THEN	
	INSERT (UserId, SiteId, Level, IsActive, LastLoginDate, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ExpiredDate, IsNeverExpired)
	VALUES(SOURCE.UserId, SOURCE.SiteId, SOURCE.Level, SOURCE.IsActive, SOURCE.LastLoginDate, SOURCE.CreatedBy, SOURCE.CreatedDate, SOURCE.ModifiedBy, SOURCE.ModifiedDate, SOURCE.ExpiredDate, SOURCE.IsNeverExpired)	
WHEN NOT MATCHED BY SOURCE THEN DELETE ;	

GO
-- Table 8: Functions
SET IDENTITY_INSERT Functions ON
MERGE dbo.Functions TARGET
USING (
	SELECT FunctionId, SiteId, FunctionName, FunctionKey, Description, ParentId, ParentName, CRUD, DisplayOrder, IsActive, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, Environment
	FROM DBPOL.NAP_UserControl.dbo.NAP_Functions WITH (NOLOCK)
) AS SOURCE
	ON	TARGET.FunctionId = SOURCE.FunctionId
WHEN	MATCHED THEN
	UPDATE SET 
		SiteId = SOURCE.SiteId, FunctionName= SOURCE.FunctionName, FunctionKey= SOURCE.FunctionKey, Description= SOURCE.Description, ParentId= SOURCE.ParentId
		, ParentName= SOURCE.ParentName, CRUD= SOURCE.CRUD
		, DisplayOrder= SOURCE.DisplayOrder, IsActive= SOURCE.IsActive, CreatedBy= SOURCE.CreatedBy, CreatedDate= SOURCE.CreatedDate, ModifiedBy= SOURCE.ModifiedBy, ModifiedDate= SOURCE.ModifiedDate, Environment= SOURCE.Environment
		
WHEN NOT MATCHED BY TARGET THEN	
	INSERT (FunctionId, SiteId, FunctionName, FunctionKey, Description, ParentId, ParentName, CRUD, DisplayOrder, IsActive, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, Environment)
	VALUES(SOURCE.FunctionId, SOURCE.SiteId, SOURCE.FunctionName, SOURCE.FunctionKey, SOURCE.Description, SOURCE.ParentId, SOURCE.ParentName, SOURCE.CRUD, SOURCE.DisplayOrder, SOURCE.IsActive, SOURCE.CreatedBy, SOURCE.CreatedDate, SOURCE.ModifiedBy, SOURCE.ModifiedDate, SOURCE.Environment)	
WHEN NOT MATCHED BY SOURCE THEN DELETE ;	
SET IDENTITY_INSERT Functions OFF

GO
-- Table 9: ObjectType
MERGE dbo.ObjectType TARGET
USING (
	SELECT ObjectTypeId, ObjectTypeName
	FROM DBPOL.NAP_UserControl.dbo.NAP_ObjectType WITH (NOLOCK)
) AS SOURCE
	ON	TARGET.ObjectTypeId = SOURCE.ObjectTypeId
WHEN	MATCHED THEN
	UPDATE SET 
		ObjectTypeName=SOURCE.ObjectTypeName
		
WHEN NOT MATCHED BY TARGET THEN	
	INSERT (ObjectTypeId, ObjectTypeName)
	VALUES(SOURCE.ObjectTypeId, SOURCE.ObjectTypeName)	

WHEN NOT MATCHED BY SOURCE THEN DELETE ;			

-- Table 10: GroupFunction
MERGE dbo.GroupFunction TARGET
USING (
	SELECT GroupId, FunctionId, SiteId, Policy, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate
	FROM DBPOL.NAP_UserControl.dbo.NAP_GroupFunction WITH (NOLOCK)
) AS SOURCE
	ON	TARGET.GroupId = SOURCE.GroupId AND TARGET.FunctionId = SOURCE.FunctionId
WHEN	MATCHED THEN
	UPDATE SET 
		SiteId= SOURCE.SiteId, Policy= SOURCE.Policy, CreatedBy= SOURCE.CreatedBy, CreatedDate= SOURCE.CreatedDate, ModifiedBy= SOURCE.ModifiedBy, ModifiedDate= SOURCE.ModifiedDate
		
WHEN NOT MATCHED BY TARGET THEN	
	INSERT (GroupId, FunctionId, SiteId, Policy, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	VALUES(SOURCE.GroupId, SOURCE.FunctionId, SOURCE.SiteId, SOURCE.Policy, SOURCE.CreatedBy, SOURCE.CreatedDate, SOURCE.ModifiedBy, SOURCE.ModifiedDate)	

WHEN NOT MATCHED BY SOURCE THEN DELETE ;

-- Table 11: Groups
MERGE dbo.Groups TARGET
USING (
	SELECT GroupId, GroupName, Description, IsActive, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate
	FROM DBPOL.NAP_UserControl.dbo.NAP_Groups WITH (NOLOCK)
) AS SOURCE
	ON	TARGET.GroupId = SOURCE.GroupId 
WHEN	MATCHED THEN
	UPDATE SET 
		GroupName =SOURCE.GroupName , Description=SOURCE.Description, IsActive=SOURCE.IsActive, CreatedBy=SOURCE.CreatedBy, CreatedDate=SOURCE.CreatedDate, ModifiedBy=SOURCE.ModifiedBy, ModifiedDate=SOURCE.ModifiedDate
		
WHEN NOT MATCHED BY TARGET THEN	
	INSERT (GroupId, GroupName, Description, IsActive, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	VALUES(SOURCE.GroupId, SOURCE.GroupName, SOURCE.Description, SOURCE.IsActive, SOURCE.CreatedBy, SOURCE.CreatedDate, SOURCE.ModifiedBy, SOURCE.ModifiedDate)	

WHEN NOT MATCHED BY SOURCE THEN DELETE ;

/*
CHECKING DATA


SELECT COUNT(1) FROM AccCustomer_1 WITH (NOLOCK) 
SELECT COUNT(1) FROM DBCUST.NAP_UserControl.dbo.AccCustomer with (nolock)

SELECT COUNT(1) FROM Acc_Menu WITH (NOLOCK)
SELECT COUNT(1) FROM DBCUST.NAP_UserControl.dbo.Acc_Menu with (nolock)

SELECT COUNT(1) FROM Acc_MemberPolicy_1 WITH (NOLOCK)
SELECT COUNT(1) FROM DBCUST.NAP_UserControl.dbo.Acc_MemberPolicy with (nolock)

SELECT COUNT(1) FROM Acc_GroupPolicy_1 WITH (NOLOCK)
SELECT COUNT(1) FROM DBCUST.NAP_UserControl.dbo.Acc_GroupPolicy with (nolock)

SELECT COUNT(1) FROM Acc_GroupInfo_1 WITH (NOLOCK)
SELECT COUNT(1) FROM DBCUST.NAP_UserControl.dbo.Acc_GroupInfo with (nolock)

SELECT COUNT(1) FROM Acc_FunctionInfo WITH (NOLOCK)
SELECT COUNT(1) FROM DBCUST.NAP_UserControl.dbo.Acc_FunctionInfo with (nolock)

SELECT COUNT(1) FROM Acc_ExchangeRate WITH (NOLOCK)
SELECT COUNT(1) FROM DBTRANS.bodb02.dbo.Acc_ExchangeRate WITH (NOLOCK)

SELECT COUNT(1) FROM Acc_ExchangeRate_History WITH (NOLOCK)
SELECT COUNT(1) FROM DBTRANS.bodb02.dbo.Acc_ExchangeRate_History WITH (NOLOCK)

SELECT COUNT(1) FROM Acc_ExchangeRate_InvalidTransfer WITH (NOLOCK)
SELECT COUNT(1) FROM DBTRANS.bodb02.dbo.Acc_ExchangeRate_InvalidTransfer WITH (NOLOCK)

*/




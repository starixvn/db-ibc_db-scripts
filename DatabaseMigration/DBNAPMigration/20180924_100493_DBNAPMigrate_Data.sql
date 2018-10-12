/*
	Created: 20180924@Helen
	Task: DB052.bodb_NAP Migration to DBCust - [Redmine:100493]
	DB:DBCUST/NAP_UserControl
	
	Tables: 12 - DBNAP
		UserMarkedMenus
		MenuItems
		Sites
		SiteURL
		UserFunction: ~100K
		Users
		UserSite
		Functions
		OnUser: ~800K, ignore
		ObjectType
		GroupFunction
		Groups

*/
USE NAP_UserControl
GO
TRUNCATE TABLE	dbo.NAP_UserMarkedMenus
GO
TRUNCATE TABLE	dbo.NAP_MenuItems
GO
TRUNCATE TABLE	dbo.NAP_Sites
GO
TRUNCATE TABLE	dbo.NAP_SiteURL
GO
TRUNCATE TABLE	dbo.NAP_UserFunction
GO
TRUNCATE TABLE	dbo.NAP_Users
GO
TRUNCATE TABLE	dbo.NAP_UserSite
GO
TRUNCATE TABLE	dbo.NAP_Functions
GO
TRUNCATE TABLE	dbo.NAP_OnUser
GO
TRUNCATE TABLE	dbo.NAP_ObjectType
GO
TRUNCATE TABLE	dbo.NAP_GroupFunction
GO
TRUNCATE TABLE	dbo.NAP_Groups
GO
		
INSERT INTO NAP_UserMarkedMenus (UserId, MenuItemId, IsMarked, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
SELECT UserId, MenuItemId, IsMarked, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate
FROM DBNAP.bodb_NAP.dbo.UserMarkedMenus WITH (NOLOCK)
GO
SET IDENTITY_INSERT NAP_MenuItems ON 
INSERT INTO NAP_MenuItems (MenuItemId, FunctionId, SiteId, MenuItemName, [Description], ParentId, ParentName, Policy, URL, DisplayOrder, IsActive, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, Environment)
SELECT MenuItemId, FunctionId, SiteId, MenuItemName, [Description], ParentId, ParentName, Policy, URL, DisplayOrder, IsActive, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, Environment 
FROM DBNAP.bodb_NAP.dbo.MenuItems WITH (NOLOCK)
SET IDENTITY_INSERT NAP_MenuItems OFF
GO
SET IDENTITY_INSERT NAP_Sites ON 
INSERT INTO NAP_Sites (SiteId, SiteName, [Description], URL, TestURL, IsActive, Environment, SecretAccessKey, SiteKey)
SELECT SiteId, SiteName, [Description], URL, TestURL, IsActive, Environment, SecretAccessKey, SiteKey
FROM DBNAP.bodb_NAP.dbo.Sites WITH (NOLOCK)
SET IDENTITY_INSERT NAP_Sites OFF 
GO
SET IDENTITY_INSERT NAP_SiteURL ON 
INSERT INTO NAP_SiteURL (SiteURLId, SiteId, URL, Environment, IsDefault, IsActive)
SELECT SiteURLId, SiteId, URL, Environment, IsDefault, IsActive
FROM DBNAP.bodb_NAP.dbo.SiteURL WITH (NOLOCK)
SET IDENTITY_INSERT NAP_SiteURL OFF
GO
INSERT INTO NAP_UserFunction (UserId, FunctionId, SiteId, Policy, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
SELECT UserId, FunctionId, SiteId, Policy, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate
FROM DBNAP.bodb_NAP.dbo.UserFunction WITH (NOLOCK)
GO
INSERT INTO NAP_Users (UserId, GroupId, LastLoginDate, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
SELECT UserId, GroupId, LastLoginDate, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate
FROM DBNAP.bodb_NAP.dbo.Users WITH (NOLOCK)
GO
INSERT INTO NAP_UserSite (UserId, SiteId, Level, IsActive, LastLoginDate, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ExpiredDate, IsNeverExpired)
SELECT UserId, SiteId, Level, IsActive, LastLoginDate, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ExpiredDate, IsNeverExpired
FROM DBNAP.bodb_NAP.dbo.UserSite WITH (NOLOCK)
GO
SET IDENTITY_INSERT NAP_Functions ON 
INSERT INTO NAP_Functions (FunctionId, SiteId, FunctionName, FunctionKey, [Description], ParentId, ParentName, CRUD, DisplayOrder, IsActive, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, Environment)
SELECT FunctionId, SiteId, FunctionName, FunctionKey, [Description], ParentId, ParentName, CRUD, DisplayOrder, IsActive, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, Environment
FROM DBNAP.bodb_NAP.dbo.Functions WITH (NOLOCK)
SET IDENTITY_INSERT NAP_Functions OFF
GO
--INSERT INTO NAP_OnUser (Id, UserId, SiteId, ReloadTime, IsKickedOut, IP, NetSessionId)
--SELECT Id, UserId, SiteId, ReloadTime, IsKickedOut, IP, NetSessionId
--FROM DBNAP.bodb_NAP.dbo.OnUser WITH (NOLOCK)
--GO
INSERT INTO NAP_ObjectType (ObjectTypeId, ObjectTypeName)
SELECT ObjectTypeId, ObjectTypeName
FROM DBNAP.bodb_NAP.dbo.ObjectType WITH (NOLOCK)
GO
INSERT INTO NAP_GroupFunction (GroupId, FunctionId, SiteId, Policy, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
SELECT GroupId, FunctionId, SiteId, Policy, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate
FROM DBNAP.bodb_NAP.dbo.GroupFunction WITH (NOLOCK)
GO
SET IDENTITY_INSERT NAP_Groups ON
INSERT INTO NAP_Groups (GroupId, GroupName, [Description], IsActive, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
SELECT GroupId, GroupName, [Description], IsActive, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate
FROM DBNAP.bodb_NAP.dbo.Groups WITH (NOLOCK)
SET IDENTITY_INSERT NAP_Groups OFF
GO
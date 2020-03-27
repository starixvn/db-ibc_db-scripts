/*
	Created by: Kos
	Date: 20200327
	Task: Initialize data for bodb_N88Log [RedmineID: #129873]
	DB: DB052.bodb_N88Log
*/

USE [bodb_N88Log]
GO

INSERT INTO N88Log_Action(ActionId, ActionTypeId, SPName, ActionName, Items, SubItems)
SELECT 3,6,'N88_User_UpdatePassword','Update password of user','<root><xml path="r" /><row item="UserId" alias="ui" /><row item="Password" alias="p" /></root>',NULL
UNION SELECT 27,1,'N88_User_CheckIn','User login',NULL,NULL
UNION SELECT 28,1,'N88_User_SSOCheckIn','User single sign on',NULL,NULL
UNION SELECT 100,6,'N88_User_Insert','Insert new users','<root><xml path="r" /><row item="Username" alias="u" /><row item="UserId" alias="ui" /><row item="GroupId" alias="gi" /><row item="GroupName" alias="g" /><row item="FirstName" alias="f" /><row item="LastName" alias="l" /><row item="Email" alias="e" /></root>',NULL
UNION SELECT 101,3,'N88_Function_Insert','Insert new function','<root><xml path="r" /><row item="FunctionId" alias="fi" /><row item="FunctionName" alias="f" /><row item="SiteId" alias="si" /><row item="SiteName" alias="s" /><row item="FunctionKey" alias="fk" /><row item="Description" alias="d" /><row item="ParentId" alias="pi" /><row item="ParentName" alias="p" /><row item="CRUD" alias="c" /><row item="DisplayOrder" alias="o" /><row item="IsActive" alias="i" /><row item="Environment" alias="e" /></root>',NULL
UNION SELECT 102,5,'N88_Group_Insert','Insert new group','<root><xml path="r" /><row item="GroupId" alias="gi" /><row item="GroupName" alias="g" /><row item="Description" alias="d" /><row item="IsActive" alias="i" /></root>',NULL
UNION SELECT 103,2,'N88_Site_Insert','Insert new site',NULL,NULL
UNION SELECT 104,4,'N88_MenuItem_Insert','Insert new menu item','<root><xml path="r" /><row item="MenuItemId" alias="mi" /><row item="MenuItemName" alias="m" /><row item="FunctionId" alias="fi" /><row item="FunctionName" alias="f" /><row item="SiteId" alias="si" /><row item="SiteName" alias="s" /><row item="Description" alias="d" /><row item="ParentId" alias="pi" /><row item="ParentName" alias="p" /><row item="Policy" alias="pl" /><row item="URL" alias="u" /><row item="DisplayOrder" alias="o" /><row item="IsActive" alias="i" /></root>',NULL
UNION SELECT 105,2,'N88_Site_InsertSiteURL','Insert new site and url','<root><xml path="r" /><row item="SiteId" alias="s" /></root>','<root><xml path="r/z" /><row item="SiteURLId" alias="si" /><row item="URL" alias="u" /><row item="Environment" alias="e" /><row item="IsDefault" alias="id" /><row item="IsActive" alias="ia" /></root>'
UNION SELECT 106,2,'N88_Site_InsertWithSiteURL','Insert new site and url','<root><xml path="r" /><row item="SiteId" alias="si" /><row item="SiteName" alias="s" /><row item="SiteKey" alias="sk" /><row item="SecretAccessKey" alias="sak" /><row item="Description" alias="d" /><row item="IsActive" alias="i" /><row item="Environment" alias="e" /></root>','<root><xml path="r/z" /><row item="SiteURLId" alias="si" /><row item="URL" alias="u" /><row item="Environment" alias="e" /><row item="IsDefault" alias="id" /><row item="IsActive" alias="ia" /></root>'
UNION SELECT 107,6,'N88_User_Insert','Add user to group','<root><xml path="r" /><row item="Username" alias="u" /><row item="UserId" alias="ui" /><row item="GroupId" alias="gi" /><row item="GroupName" alias="g" /></root>',NULL
UNION SELECT 200,6,'N88_User_Update','Update user information','<root><xml path="r" /><row item="Username" alias="u" /><row item="UserId" alias="ui" /><row item="GroupId" alias="gi" /><row item="GroupName" alias="g" /><row item="FirstName" alias="f" /><row item="LastName" alias="l" /><row item="Email" alias="e" /></root>',NULL
UNION SELECT 201,3,'N88_Function_Update','Update function information','<root><xml path="r" /><row item="FunctionId" alias="fi" /><row item="FunctionName" alias="f" /><row item="SiteId" alias="si" /><row item="SiteName" alias="s" /><row item="FunctionKey" alias="fk" /><row item="Description" alias="d" /><row item="ParentId" alias="pi" /><row item="ParentName" alias="p" /><row item="CRUD" alias="c" /><row item="DisplayOrder" alias="o" /><row item="IsActive" alias="i" /><row item="Environment" alias="e" /></root>',NULL
UNION SELECT 202,3,'N88_Function_UpdateStatus','Update status of functions','<root><xml path="r" /><row item="FunctionId" alias="fi" /><row item="IsActive" alias="i" /></root>',NULL
UNION SELECT 203,5,'N88_Group_Update','Update group information','<root><xml path="r" /><row item="GroupId" alias="gi" /><row item="GroupName" alias="g" /><row item="Description" alias="d" /><row item="IsActive" alias="i" /></root>',NULL
UNION SELECT 204,5,'N88_Group_UpdateStatus','Update group status','<root><xml path="r" /><row item="GroupId" alias="gi" /><row item="IsActive" alias="i" /></root>',NULL
UNION SELECT 205,4,'N88_MenuItem_Update','Update menu item information','<root><xml path="r" /><row item="MenuItemId" alias="mi" /><row item="MenuItemName" alias="m" /><row item="FunctionId" alias="fi" /><row item="FunctionName" alias="f" /><row item="SiteId" alias="si" /><row item="SiteName" alias="s" /><row item="Description" alias="d" /><row item="ParentId" alias="pi" /><row item="ParentName" alias="p" /><row item="Policy" alias="pl" /><row item="URL" alias="u" /><row item="DisplayOrder" alias="o" /><row item="IsActive" alias="i" /></root>',NULL
UNION SELECT 206,4,'N88_MenuItem_UpdateStatus','Update status of menu item','<root><xml path="r" /><row item="MenuItemId" alias="mi" /><row item="IsActive" alias="i" /></root>',NULL
UNION SELECT 207,2,'N88_Site_Update','Update site information','<root><xml path="r" /><row item="SiteId" alias="si" /><row item="SiteName" alias="s" /><row item="SiteKey" alias="sk" /><row item="SecretAccessKey" alias="sak" /><row item="Description" alias="d" /><row item="IsActive" alias="i" /><row item="Environment" alias="e" /></root>',NULL
UNION SELECT 208,2,'N88_Site_UpdateDefaultSiteURL','Update default url of site','<root><xml path="r" /><row item="SiteId" alias="s" /></root>','<root><xml path="r/z" /><row item="SiteURLId" alias="si" /><row item="URL" alias="u" /><row item="Environment" alias="e" /><row item="IsDefault" alias="id" /><row item="IsActive" alias="ia" /></root>'
UNION SELECT 209,2,'N88_Site_UpdateSiteURL','Update url of site','<root><xml path="r" /><row item="SiteId" alias="s" /></root>','<root><xml path="r/z" /><row item="SiteURLId" alias="si" /><row item="URL" alias="u" /><row item="Environment" alias="e" /><row item="IsDefault" alias="id" /><row item="IsActive" alias="ia" /></root>'
UNION SELECT 210,6,'N88_User_ChangeUserSiteStatus','Change user site status',NULL,NULL
UNION SELECT 211,2,'N88_Site_UpdateStatus','Update status of site','<root><xml path="r" /><row item="SiteId" alias="s" /><row item="IsActive" alias="i" /></root>',NULL
UNION SELECT 212,3,'N88_Function_Duplicate','Duplicate function','<root><xml path="r" /><row item="FunctionId" alias="fi" /><row item="FunctionName" alias="f" /><row item="SiteId" alias="si" /><row item="SiteName" alias="s" /><row item="FunctionKey" alias="fk" /><row item="Description" alias="d" /><row item="ParentId" alias="pi" /><row item="ParentName" alias="p" /><row item="CRUD" alias="c" /><row item="DisplayOrder" alias="o" /><row item="IsActive" alias="i" /><row item="Environment" alias="e" /></root>',NULL
UNION SELECT 300,3,'N88_Function_AssignFunctionToGroups','Add groups to function','<root><xml path="r" /><row item="FunctionId" alias="f" /></root>','<root><xml path="r/z" /><row item="GroupId" alias="gi" /><row item="Policy" alias="p" /><row item="GroupName" alias="g" /></root>'
UNION SELECT 301,3,'N88_Function_AssignFunctionToUsers','Add users to function','<root><xml path="r" /><row item="FunctionId" alias="f" /></root>','<root><xml path="r/z" /><row item="UserId" alias="ui" /><row item="Policy" alias="p" /><row item="UserName" alias="u" /></root>'
UNION SELECT 302,5,'N88_Group_AssignFunction','Assign permission to groups','<root><xml path="r" /><row item="SiteId" alias="s" /><row item="GroupId" alias="g" /></root>','<root><xml path="r/z" /><row item="FunctionId" alias="f" /><row item="Policy" alias="p" /></root>'
UNION SELECT 304,6,'N88_User_AssignFunction','Assign permission to user','<root><xml path="r" /><row item="SiteId" alias="s" /><row item="UserId" alias="u" /></root>','<root><xml path="r/z" /><row item="FunctionId" alias="f" /><row item="Policy" alias="p" /></root>'
UNION SELECT 400,6,'N88_User_AssignSite','Assign site to user','<root><xml path="r" /><row item="UserId" alias="u" /></root>','<root><xml path="r/z" /><row item="SiteId" alias="si" /><row item="SiteName" alias="s" /><row item="Level" alias="l" /><row item="IsActive" alias="i" /></root>'
UNION SELECT 403,6,'N88_User_AssignNewSite','Assign new site to user','<root><xml path="r" /><row item="UserId" alias="u" /><row item="SiteId" alias="si" /><row item="SiteName" alias="s" /><row item="Level" alias="l" /><row item="IsActive" alias="i" /></root>',NULL
UNION SELECT 404,6,'N88_User_UpdateSite','Update assigned site','<root><xml path="r" /><row item="UserId" alias="u" /><row item="SiteId" alias="si" /><row item="SiteName" alias="s" /><row item="Level" alias="l" /><row item="IsActive" alias="i" /><row item="ExpiredDate" alias="ed" /><row item="IsNeverExpired" alias="ine" /></root>',NULL
UNION SELECT 405,6,'Task_N88_RevokeUserPermission','Revoke user permission','<root><xml path="r" /></root>','<root><xml path="r/z" /><row item="SiteId" alias="si" /><row item="SiteName" alias="s" /></root>'
UNION SELECT 406,3,'N88_Function_CopyPermission','Copy function permission','<root><xml path="r" /><row item="SiteId" alias="s" /><row item="UserId" alias="u" /></root>','<root><xml path="r/z" /><row item="FunctionId" alias="f" /><row item="Policy" alias="p" /></root>'


GO
INSERT INTO N88Log_ActionType(ActionTypeId, ActionTypeName)
SELECT 1,'User Login'
UNION SELECT 2,'Manage Site'
UNION SELECT 3,'Manage Function'
UNION SELECT 4,'Manage Menu'
UNION SELECT 5,'Manage Group'
UNION SELECT 6,'Manage User'
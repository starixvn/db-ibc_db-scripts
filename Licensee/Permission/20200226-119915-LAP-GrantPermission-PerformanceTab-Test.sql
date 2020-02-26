/*
	Created by: Kos
	Date: 20200226
	Task: GRANT PERMISSION to access Performance Tab of Dashboard for test user
	DB: DBCUST.SiteConfig
*/

USE [SiteConfig]
GO

INSERT INTO UserFuncPermission (UserSEQ, FunctionKey, SubFunctionKeys, SiteName, IsAllow, SystemType)
VALUES (16338, 'db_per_tab', NULL, 'Athena000', 1, 3) 
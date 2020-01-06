/*
    Created: 20200102@Malcolm
	Task: Separate setting and notification into Live/Non-Live and bettypes - [Redmine: #126348]
	DB: DBCUST/CustDB
*/
USE CustDB
GO

DELETE TOControl_GlobalSetting 
GO
DELETE TOControl_Setting
GO
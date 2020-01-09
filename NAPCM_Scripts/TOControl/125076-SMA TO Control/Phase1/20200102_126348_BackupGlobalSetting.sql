/*
    Created: 20200108@Malcolm
	Task: Separate setting and notification into Live/Non-Live and bettypes - [Redmine: #126348]
	DB: DBCUST/CustDB
*/
USE CustDB
GO
SELECT * INTO TOControl_GlobalSetting_temp 
FROM TOControl_GlobalSetting WITH (NOLOCK)
GO

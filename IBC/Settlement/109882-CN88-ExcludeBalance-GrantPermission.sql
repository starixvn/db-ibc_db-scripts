/*
	Created:20190329@Kathy
	DB:DBTXN/CustDB
	Task: grant select permission to 3 logins [Redmine:#109882]

*/
USE [CustDB]
GO
GRANT SELECT ON [dbo].[Customer] TO [API_Vender]
GO
GRANT SELECT ON [dbo].[Customer] TO [Dot_InfoSite]
GO
GRANT SELECT ON [dbo].[Customer] TO [Dot_Intg]
GO

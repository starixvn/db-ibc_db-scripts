/*
	Created:20190329@Kathy
	DB:DBTXN/CustDB
	Task: grant select permission to Dot_InfoSite [Redmine:#109882]

*/
USE [CustDB]
GO
GRANT SELECT ON [dbo].[CustInfo] TO [Dot_InfoSite]
GO

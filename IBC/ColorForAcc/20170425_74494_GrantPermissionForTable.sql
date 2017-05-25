/*	Created: Winnie	
	Task:  grant permission RedmineID:74494
	DB: DBCUST/CustDB
	Date: 20170525
*/ 

GRANT SELECT ON [dbo].CustLoginInfo_Member TO [bodbDownlineNet] AS [dbo]
GO

GRANT SELECT ON [dbo].CustLoginInfo_Member TO [bodbDownlineNetView] AS [dbo]
GO

GRANT SELECT ON [dbo].CustLoginInfo TO [bodbDownlineNet] AS [dbo]
GO

GRANT SELECT ON [dbo].CustLoginInfo TO [bodbDownlineNetView] AS [dbo]
GO


GRANT SELECT ON [dbo].CustLoginInfoSub TO [bodbDownlineNet] AS [dbo]
GO

GRANT SELECT ON [dbo].CustLoginInfoSub TO [bodbDownlineNetView] AS [dbo]
GO
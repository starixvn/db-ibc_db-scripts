/*<info serverAlias="DBAGE-bodb02"></info>*/

/*
	Created: 20200602@Percy
	DB: DBAGE-bodb02
	Task: Grant selection permission on SMP_ tables to bodbRMSNet account
*/

USE bodb02
GO

GRANT SELECT ON dbo.SMP_MarketSelection TO bodbRMSNet AS dbo
GO

GRANT SELECT ON dbo.SMP_MarketSelection14 TO bodbRMSNet AS dbo
GO

GRANT SELECT ON dbo.SMP_Market TO bodbRMSNet AS dbo
GO

GRANT SELECT ON dbo.SMP_Market14 TO bodbRMSNet AS dbo
GO

GRANT SELECT ON dbo.SMP_Selection TO bodbRMSNet AS dbo
GO

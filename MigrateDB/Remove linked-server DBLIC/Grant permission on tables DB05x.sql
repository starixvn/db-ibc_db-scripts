USE [bodb_licensee]
GO

/*
	Created: 20181212@Percy
	DB: DB052, DB053 - bodb_Licensee
	Task: Grant permission due to remove linked-server DBLIC [RedmineID: #103660]
*/

GRANT SELECT ON dbo.LicenseeBAHistory TO bodbAdminNet AS dbo
GO

GRANT SELECT ON dbo.LicenseeBAHistory TO bodbDownlineNet AS dbo
GO

GRANT SELECT ON dbo.LicenseeBAHistory TO bodbExtAccNet AS dbo
GO
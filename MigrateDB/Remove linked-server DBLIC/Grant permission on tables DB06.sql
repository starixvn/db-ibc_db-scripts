USE [bodb_licensee]
GO

/*
	Created: 20181212@Percy
	DB: DB06 - bodb_Licensee
	Task: Grant permission due to remove linked-server DBLIC [RedmineID: #103660]
*/

GRANT SELECT ON LicenseeBATransaction_active TO bodbLicenseeNet
GO

GRANT SELECT ON LicenseeBATransaction_bk TO bodbLicenseeNet
GO

GRANT SELECT ON LicenseeProduct3rd TO bodbAdminNet AS dbo
GO

GRANT SELECT ON Licensees TO bodbAdminNet AS dbo
GO

GRANT SELECT ON Product3rd TO bodbAdminNet AS dbo
GO

GRANT SELECT ON SystemLicensee TO bodbAdminNet AS dbo
GO

GRANT SELECT ON Exchange TO bodbAdminNet AS dbo
GO

GRANT SELECT ON Exchange TO bodbLicenseeNet AS dbo
GO

GRANT SELECT ON LicenseeCust TO bodbAdminNet AS dbo
GO

GRANT SELECT ON LicenseeBATransaction_bk TO bodbAdminNet AS dbo
GO
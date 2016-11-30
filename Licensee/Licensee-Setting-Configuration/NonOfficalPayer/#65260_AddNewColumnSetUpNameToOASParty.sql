USE bodb_licensee
GO
/*
	Created:	20161009@Harper
	Task:		#65260 - Invoice - Implement Setup fee
	DB:			DBEXT/bodb_licensee
*/
ALTER TABLE dbo.OAS_Party ADD SetupName VARCHAR(50) NULL
GO
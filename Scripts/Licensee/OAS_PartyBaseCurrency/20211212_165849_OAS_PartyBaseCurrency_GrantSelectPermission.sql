/*<info serverAlias="DBLIC-bodb_licensee"></info>*/
/*
	Created: 20211212@Percy
	DB: DBLIC-bodb_licensee
	Task: Grant select permission on OAS_PartyBaseCurrency table
*/
USE bodb_Licensee
GO

GRANT SELECT ON dbo.OAS_PartyBaseCurrency TO bodbAdminNet AS dbo
GO
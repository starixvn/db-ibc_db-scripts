/*<info serverAlias="DBCUST-bodb_Licensee"></info>*/
/*
	Created: 20220118@Percy
	DB: DBCUST-bodb_Licensee
	Task: LA - Add Licensee Status Setting - Date Setting
	https://nexdev.net/issues/166751
	
	Step 1: Add new column
*/
USE bodb_Licensee
GO

ALTER TABLE dbo.OAS_PartyDetail
	ADD LaunchDate DATE, SuspendedDate DATE, TerminatedDate DATE
GO
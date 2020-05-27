/*<info serverAlias="DBCUST-Licensee"></info>*/

/*
	Created: 20200527@Percy
	DB: DBCUST-Licensee
	Task: Add IBCIndo under FDL group (IBC, LicenseeID = 13)
*/

USE bodb_Licensee
GO

INSERT INTO dbo.Labels (LicenseeID, LabelID, LabelName, IsKPISummary)
VALUES (13, 1487, 'IBCIndo', 0)
GO
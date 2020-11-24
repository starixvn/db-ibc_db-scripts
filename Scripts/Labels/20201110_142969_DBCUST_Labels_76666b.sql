/*<info serverAlias="DBCUST-Licensee"></info>*/

/*
	Created: 20201110@Sophia
	DB: DBCUST-Licensee
	Task: Add 76666b under FDL group (IBC, LicenseeID = 13) [redmine: #142969]
*/

USE bodb_Licensee
GO

INSERT INTO dbo.Labels (LicenseeID, LabelID, LabelName, IsKPISummary)
VALUES (13, 1547, '76666b', 0)
GO
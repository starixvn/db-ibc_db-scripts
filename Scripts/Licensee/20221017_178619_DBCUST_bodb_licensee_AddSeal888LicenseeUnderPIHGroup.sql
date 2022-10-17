/*<info serverAlias="DBCUST-bodb_licensee"></info>*/

/*
	Created: 20221017@Danny
	DB: DBCUST.bodb_licensee
	Description: Add Seal888 to Label table
*/

INSERT INTO Labels(LicenseeID, LabelID, LabelName, AffectedDate, IsKPISummary)
SELECT 18, -- PIH
		825, --LabelID
		'Seal888', --LabelName
		'2022-09-01', -- AffectedDate
		0 


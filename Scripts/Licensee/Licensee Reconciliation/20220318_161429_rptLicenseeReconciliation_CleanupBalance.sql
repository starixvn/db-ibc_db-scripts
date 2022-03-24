/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20220318@Percy
	DB: DBLIC-bodb_LicenseeReport
	Task: https://nexdev.net/issues/170165
*/
USE bodb_LicenseeReport
GO

/*
SELECT PartyId, PartyName FROM bodb_Licensee.dbo.OAS_Party WITH (NOLOCK)
WHERE PartyName IN ('Mega', 'B88bet')
*/

-- 37 rows
UPDATE dbo.rptLicenseeReconciliation WITH (ROWLOCK)
SET OpeningBalance = 0, ClosingBalance = 0
WHERE PartyId IN (239, 614) -- Mega, B88bet
GO
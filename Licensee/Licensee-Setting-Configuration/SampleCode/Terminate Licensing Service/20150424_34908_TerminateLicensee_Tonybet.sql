USE bodb_licensee
GO
/*
	Author: Florent.Nguyen
	Date: 20150424
	Task: terminate licensee
		+ Licensee: 148-Tonybet
	Redmine ID: #34908
*/

DECLARE @LicenseeName	VARCHAR(20)
	, @TerminateDate	DATE
SELECT @LicenseeName = 'Tonybet' 
	, @TerminateDate = '20150501'
UPDATE ci 
SET ToDate = @TerminateDate
FROM dbo.OAS_ChargeInfo ci WITH (ROWLOCK, UPDLOCK)
	INNER JOIN dbo.OAS_Party p WITH (NOLOCK) ON ci.FromParty = p.PartyID
WHERE p.PartyName = @LicenseeName
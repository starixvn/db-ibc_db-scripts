/*<info serverAlias="DBCUST-bodb_Licensee"></info>*/
/*
	Created: 20220118@Percy
	DB: DBCUST-bodb_Licensee
	Task: LA - Add Licensee Status Setting - Date Setting
	https://nexdev.net/issues/166751

	Step 2: Initialize Data
*/
USE bodb_Licensee
GO

DECLARE @CurrentDate DATE = GETDATE()

UPDATE pd
SET pd.LaunchDate = c.LaunchDate, pd.TerminatedDate = CASE WHEN c.TerminatedDate < @CurrentDate THEN c.TerminatedDate ELSE NULL END
FROM dbo.OAS_PartyDetail pd WITH (ROWLOCK, UPDLOCK)
	INNER JOIN (
		SELECT FromParty AS PartyId, MIN(FromDate) AS LaunchDate, MAX(ToDate) AS TerminatedDate
		FROM dbo.OAS_ChargeInfo WITH (NOLOCK)
		WHERE ToParty IN (1, 9, 11, 98) -- licensee to house
			AND ChargeType NOT IN (2, 3) -- Old charge type, not use
		GROUP BY FromParty
	) c ON pd.PartyId = c.PartyId
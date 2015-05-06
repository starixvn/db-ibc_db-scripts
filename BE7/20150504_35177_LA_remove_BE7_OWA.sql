USE bodb_licensee
GO
/*
	Author: Florent
	Date: 20150504
	Task: remove licensee BE7 on OWA system
	Redmine: #35177
*/
DECLARE @ChargeID INT

SELECT @ChargeID = ci.ChargeID
FROM dbo.OAS_ChargeInfo ci WITH (NOLOCK)
	INNER JOIN dbo.OAS_Party p WITH (NOLOCK) ON ci.FromParty = p.PartyID
WHERE p.PartyName = 'BE7'
	AND p.PartyType = 1
	AND ci.ToParty = 11 -- Boping
	AND ci.ProductID = 11 -- GD

SELECT @ChargeID
---543
DELETE dbo.LA_ChargeInfo_SystemMapping WITH (ROWLOCK, UPDLOCK)
WHERE ChargeID = @ChargeID
	AND SystemID = 4 -- OWA
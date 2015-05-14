USE bodb_licensee
GO
/*
	Author :Florent.Nguyen
	Date: 20150407
	Task: Update charge rate of licensee 
		+ ITCbet
		+ Macaubet
		Product : AG Casino, rate from 0.10 to 0.15
*/
--ITCBet
UPDATE ci
SET ci.Rate = 0.15
FROM dbo.OAS_ChargeInfo ci WITH (ROWLOCK, UPDLOCK)
	INNER JOIN dbo.OAS_Party p WITH (NOLOCK) ON ci.FromParty = p.PartyID AND p.PartyType = 1
WHERE p.PartyName = 'ITCBet'
	AND ci.ProductID = 10
	AND ci.ToParty = 11

--Macaubet
UPDATE ci
SET ci.Rate = 0.15 
FROM dbo.OAS_ChargeInfo ci WITH (ROWLOCK, UPDLOCK)
	INNER JOIN dbo.OAS_Party p WITH (NOLOCK) ON ci.FromParty = p.PartyID AND p.PartyType = 1
WHERE p.PartyName = 'Macaubet'
	AND ci.ProductID = 10
	AND ci.ToParty = 11
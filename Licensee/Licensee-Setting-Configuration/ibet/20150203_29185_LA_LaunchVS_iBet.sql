USE bodb_licensee
GO
/*
	Author: Florent.Nguyen
	Date: 20150203
	Task : Launch Virtual Sort , licensee ibet
	RedmineID: #29185
*/

DECLARE @LicenseeName VARCHAR(50), @FromDate DATE
SELECT @LicenseeName = 'iBet'
		, @FromDate = '2015-01-14'

INSERT INTO dbo.OAS_ChargeInfo(ProductID, FromParty, ToParty, ParentChargeID, Rate, ChargeType, FromDate, ToDate, MinAmount, MaxAmount, Remark)
(
	SELECT 5, p.PartyID, 11, 0, 0.15, 1, @FromDate, '2050-01-01', NULL, NULL, NULL
	FROM dbo.OAS_Party p WITH (NOLOCK)
	WHERE p.PartyName = @LicenseeName
)

INSERT INTO dbo.LA_ChargeInfo_SystemMapping(ChargeID, SystemID)
(
	SELECT MAX(c.ChargeID), 2
	FROM dbo.OAS_ChargeInfo c WITH (NOLOCK)
		INNER JOIN dbo.OAS_Party p WITH (NOLOCK) ON c.FromParty = p.PartyID
	WHERE p.PartyName = @LicenseeName
		AND c.ProductID = 5
)
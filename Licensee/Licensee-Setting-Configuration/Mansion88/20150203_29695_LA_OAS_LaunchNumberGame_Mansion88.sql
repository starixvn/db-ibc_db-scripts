USE bodb_licensee
GO
/*
	Date: 20150203
	Task : Launch Number game on licensee Mansion88 (ONEWorks)
*/

DECLARE @LicenseeName VARCHAR(50), @FromDate DATE
SELECT @LicenseeName = 'Mansion88'
		, @FromDate = '2015-01-20'

INSERT INTO dbo.OAS_ChargeInfo(ProductID, FromParty, ToParty, ParentChargeID, Rate, ChargeType, FromDate, ToDate, MinAmount, MaxAmount, Remark)
(
	SELECT 2, p.PartyID, 1, 0, 0.15, 1, @FromDate, '2050-01-01', NULL, NULL, NULL
	FROM dbo.OAS_Party p WITH (NOLOCK)
	WHERE p.PartyName = @LicenseeName
)

SET IDENTITY_INSERT [dbo].[OAS_ChargeInfo_xtest] ON
INSERT INTO dbo.OAS_ChargeInfo_xtest (ChargeID, ProductID, FromParty, ToParty, ParentChargeID, Rate, ChargeType, FromDate, ToDate, MinAmount, MaxAmount)
	(
		SELECT ChargeID, ProductID, FromParty, ToParty, ParentChargeID, Rate, ChargeType, FromDate, ToDate, MinAmount, MaxAmount
		FROM dbo.OAS_ChargeInfo ci WITH (NOLOCK)
			INNER JOIN dbo.OAS_Party p WITH (NOLOCK) ON ci.FromParty = p.PartyID
		WHERE p.PartyName = @LicenseeName
			AND ci.ProductID IN (2)
	)

INSERT INTO dbo.LA_ChargeInfo_SystemMapping(ChargeID, SystemID)
(
	SELECT MAX(c.ChargeID) AS ChargeID, 2
	FROM dbo.OAS_ChargeInfo c WITH (NOLOCK)
		INNER JOIN dbo.OAS_Party p WITH (NOLOCK) ON c.FromParty = p.PartyID
	WHERE p.PartyName = @LicenseeName
		AND c.ProductID IN (2)
	GROUP BY c.ProductID
	UNION
	SELECT MAX(c.ChargeID) AS ChargeID, 4
	FROM dbo.OAS_ChargeInfo c WITH (NOLOCK)
		INNER JOIN dbo.OAS_Party p WITH (NOLOCK) ON c.FromParty = p.PartyID
	WHERE p.PartyName = @LicenseeName
		AND c.ProductID IN (2)
	GROUP BY c.ProductID
)
GO
/*
	Author : Florent.Nguyen
	Date : 2015-01-02
	Task : Laucnh HonorW on OWA, LA site. Sportsbook, Number Game, Virtual Sports and BA.
*/
USE bodb_licensee
GO

DECLARE @ChargeID INT, @LicenseeID INT, @Fromdate DATE, @Todate DATE, @FromPartyID INT, @ToPartyID INT, @ToPartyBAID INT, @Minfee INT, @WaiveMonth INT 

SELECT	@Fromdate		= '2014-12-30'
		, @Todate		= '2050-01-01'
		, @ToPartyID	= 1				-- OW
		, @ToPartyBAID	= 13			-- BA(FDL)
		, @Minfee		= 5000
		, @WaiveMonth	= 3

SELECT @LicenseeID = l.LicenseeID
FROM dbo.Licensees l WITH (NOLOCK)
WHERE l.LicenseeName = 'HonorW'

-- Insert OAS_Party
IF NOT EXISTS ( SELECT TOP 1 1 FROM dbo.OAS_Party p WITH (NOLOCK) INNER JOIN dbo.Licensees l WITH (NOLOCK) ON p.OldRefID = l.LicenseeID WHERE l.LicenseeID = @LicenseeID)
BEGIN
	INSERT INTO dbo.OAS_Party ( PartyName, Description, PartyType, OldRefID)
		(
			SELECT l.LicenseeName, l.Description, 1, @LicenseeID 
			FROM dbo.Licensees l WITH (NOLOCK)
			WHERE l.LicenseeID = @LicenseeID
		)
END

-- Insert OAS_PartyDetail
IF NOT EXISTS ( SELECT TOP 1 1 FROM dbo.OAS_Party p WITH (NOLOCK) INNER JOIN dbo.OAS_PartyDetail pd WITH (NOLOCK) ON p.PartyID = pd.PartyID WHERE p.OldRefID = @LicenseeID)
BEGIN
	INSERT INTO dbo.OAS_PartyDetail( PartyID, IsDeposit, BrandName, CompanyName)
		(
			SELECT p.PartyID, l.IsDeposit, l.BrandName, l.CompanyName 
			FROM dbo.OAS_Party p WITH (NOLOCK)
				INNER JOIN dbo.licensees l WITH (NOLOCK) ON p.OldRefID = l.LicenseeID
			WHERE l.LicenseeID = @LicenseeID AND p.PartyType = 1
		)
END

SELECT @FromPartyID = p.PartyID 
FROM dbo.OAS_Party p WITH (NOLOCK)
WHERE p.OldRefID = @LicenseeID AND p.PartyType = 1

-- Insert INTO OAS_ChargeInfo
--======= Sportbook =========
INSERT INTO dbo.OAS_ChargeInfo ( ProductID, FromParty, ToParty, ParentChargeID, Rate, ChargeType, FromDate, ToDate, MinAmount, MaxAmount)
	(
		SELECT	0 , @FromPartyID, @ToPartyID, 0, 0.15, 1, @Fromdate, @Todate, NULL , NULL
	)

SELECT @ChargeID = MAX(ci.ChargeID) 
FROM dbo.OAS_ChargeInfo ci WITH (NOLOCK)
-- Insert into Minfee
INSERT INTO LA_ChargeInfo_MinFee (ChargeID, MinFee, MinFeeCurrencyID, WaiveFrom, WaiveTo)
	(
		SELECT @ChargeID, @Minfee, 6, @Fromdate, DATEADD(DAY, -1, DATEADD(MONTH, @WaiveMonth, @Fromdate))
	)
--====== Number Game ========
INSERT INTO dbo.OAS_ChargeInfo (ProductID, FromParty, ToParty, ParentChargeID, Rate, ChargeType, FromDate, ToDate, MinAmount, MaxAmount)
	(
		SELECT	2, @FromPartyID, @ToPartyID, 0, 0.15, 1, @Fromdate, @Todate, NULL, NULL
	)
--====== Virtual Sport =======
INSERT INTO dbo.OAS_ChargeInfo (ProductID, FromParty, ToParty, ParentChargeID, Rate, ChargeType, FromDate, ToDate, MinAmount, MaxAmount)
	(
		SELECT	5, @FromPartyID, @ToPartyID, 0, 0.15, 1, @Fromdate, @Todate, NULL , NULL
	)
--===== BA =========
INSERT INTO dbo.OAS_ChargeInfo (ProductID, FromParty, ToParty, ParentChargeID, Rate, ChargeType, FromDate, ToDate, MinAmount, MaxAmount)
	(
		SELECT	3, @FromPartyID, @ToPartyBAID, 0, 1, 1, @Fromdate, @Todate, NULL, NULL
	)
-- Insert Mapping
INSERT INTO LA_ChargeInfo_SystemMapping (ChargeID, SystemID)
SELECT ci.ChargeID, 2
FROM dbo.OAS_ChargeInfo ci WITH (NOLOCK)
WHERE ci.FromParty = @FromPartyID
	AND ci.ProductID IN (0, 2, 3, 5)

SET IDENTITY_INSERT [dbo].[OAS_ChargeInfo_xtest] ON
INSERT INTO dbo.OAS_ChargeInfo_xtest (ChargeID, ProductID, FromParty, ToParty, ParentChargeID, Rate, ChargeType, FromDate, ToDate, MinAmount, MaxAmount)
	(
		SELECT ChargeID, ProductID, FromParty, ToParty, ParentChargeID, Rate, ChargeType, FromDate, ToDate, MinAmount, MaxAmount
		FROM dbo.OAS_ChargeInfo ci WITH (NOLOCK)
		WHERE ci.FromParty = @FromPartyID
			AND ci.ProductID IN (0, 2, 3, 5)
	)
INSERT INTO LA_ChargeInfo_SystemMapping (ChargeID, SystemID)
SELECT ci.ChargeID, 4
FROM dbo.OAS_ChargeInfo_xtest ci WITH (NOLOCK)
WHERE ci.FromParty = @FromPartyID
	AND ci.ProductID IN (0, 2, 3, 5)

-- Insert Permission to User StarIX1
DECLARE @userStarIX INT

SELECT @userStarIX = UserID 
FROM dbo.LA_User WITH (NOLOCK) 
WHERE Username = 'StarIX1'
INSERT INTO LA_UserParty (UserID, PartyID, Modifydate, Modifier, StatusID)
	(
		SELECT @userStarIX, @FromPartyID, GETDATE(), @userStarIX, 1
	)
GO
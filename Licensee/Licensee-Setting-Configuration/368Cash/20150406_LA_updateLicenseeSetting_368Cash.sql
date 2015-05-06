USE bodb_licensee
GO
/*
	Author: Florent.Nguyen
	Date: 20150302
	Task : update date licensee 368Cash
			+ Sportsbook, Number game, Live casino
			+ Launch at : 2014-04-03
	RedmineID: #31276
*/
-- Sportsbook
DECLARE @ChargeId INT
EXEC dbo.OAS_ChargeInfoIns 
	  @ProductName		= 'SB'
	, @FromPartyName	= '368Cash'
	, @ToPartyName		= 'Boping'	
	, @Fromdate			= '2014-04-03'
	, @Todate			= '2014-08-31'
	, @Rate				= 0.15
	, @Minfee			= 4000
	, @MinFeeCurrencyID	= 6
	, @WaiveMonth		= 5
	, @System			= 'OA'
	, @Remark			= 'Launch at 2014-04-03'
	, @ChargeId = @ChargeId	OUTPUT
SELECT @ChargeId
GO
-- NG
DECLARE @ChargeId INT
EXEC dbo.OAS_ChargeInfoIns 
	  @ProductName		= 'NG'
	, @FromPartyName	= '368Cash'
	, @ToPartyName		= 'Boping'	
	, @Fromdate			= '2014-04-03'
	, @Todate			= '2014-08-31'
	, @Rate				= 0.15
	, @System			= 'OA'
	, @Remark			= 'Launch at 2014-04-03'
	, @ChargeId = @ChargeId	OUTPUT
SELECT @ChargeId
GO
--LC
DECLARE @ChargeId INT
EXEC dbo.OAS_ChargeInfoIns 
	  @ProductName		= 'LC'
	, @FromPartyName	= '368Cash'
	, @ToPartyName		= 'Boping'	
	, @Fromdate			= '2014-04-03'
	, @Todate			= '2014-08-31'
	, @Rate				= 0.07
	, @System			= 'OA'
	, @Remark			= 'Launch at 2014-04-03'
	, @ChargeId = @ChargeId	OUTPUT
SELECT @ChargeId
GO


UPDATE cm
SET cm.WaiveTo = '2014-08-31'
FROM
	dbo.LA_ChargeInfo_MinFee cm WITH (NOLOCK)
	INNER JOIN dbo.OAS_ChargeInfo ci WITH (NOLOCK) ON cm.ChargeID = ci.ChargeID
	INNER JOIN dbo.OAS_Party p WITH (NOLOCK) ON ci.FromParty = p.PartyID
WHERE p.PartyName = '368Cash'
	AND ci.ToParty = 11

UPDATE cm
SET cm.WaiveTo = '2014-10-02'	
FROM
	dbo.LA_ChargeInfo_MinFee cm WITH (NOLOCK)
	INNER JOIN dbo.OAS_ChargeInfo ci WITH (NOLOCK) ON cm.ChargeID = ci.ChargeID
	INNER JOIN dbo.OAS_Party p WITH (NOLOCK) ON ci.FromParty = p.PartyID
WHERE p.PartyName = '368Cash'
	AND ci.ToParty = 1
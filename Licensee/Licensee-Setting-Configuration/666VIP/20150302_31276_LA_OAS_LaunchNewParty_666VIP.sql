USE bodb_licensee
GO
/*
	Author: Florent.Nguyen
	Date: 20150302
	Task : Launch of new licensee 666VIP
			+ Sportsbook, Number game, Live casino, RNG casino, Virtual Sports, and BA ( ONEworks's Licensee)
			+ Launch at : 2015-02-24
	RedmineID: #31276
*/
-- Sportsbook
DECLARE @ChargeId INT
EXEC dbo.OAS_ChargeInfoIns 
	  @ProductName		= 'SB'
	, @FromPartyName	= '666VIP'
	, @ToPartyName		= 'ONEWorks'	
	, @Fromdate			= '2015-02-24'
	, @Todate			= '2050-01-01'
	, @Rate				= 0.15
	, @Minfee			= 4000
	, @MinFeeCurrencyID	= 12
	, @WaiveMonth		= 3
	, @System			= 'OA,OAS'
	, @Remark			= 'Launch at 2015-02-24; Redmine: #31276'
	, @ChargeId = @ChargeId	OUTPUT
SELECT @ChargeId
GO
-- NG
DECLARE @ChargeId INT
EXEC dbo.OAS_ChargeInfoIns 
	  @ProductName		= 'NG'
	, @FromPartyName	= '666VIP'
	, @ToPartyName		= 'ONEWorks'	
	, @Fromdate			= '2015-02-24'
	, @Todate			= '2050-01-01'
	, @Rate				= 0.15
	, @System			= 'OA,OAS'
	, @Remark			= 'Launch at 2015-02-24; Redmine: #31276'
	, @ChargeId = @ChargeId	OUTPUT
SELECT @ChargeId
GO
--LC
DECLARE @ChargeId INT
EXEC dbo.OAS_ChargeInfoIns 
	  @ProductName		= 'LC'
	, @FromPartyName	= '666VIP'
	, @ToPartyName		= 'ONEWorks'	
	, @Fromdate			= '2015-02-24'
	, @Todate			= '2050-01-01'
	, @Rate				= 0.07
	, @System			= 'OA,OAS'
	, @Remark			= 'Launch at 2015-02-24; Redmine: #31276'
	, @ChargeId = @ChargeId	OUTPUT
SELECT @ChargeId
GO
--RnG Casino
DECLARE @ChargeId INT
EXEC dbo.OAS_ChargeInfoIns 
	  @ProductName		= 'CS'
	, @FromPartyName	= '666VIP'
	, @ToPartyName		= 'ONEWorks'	
	, @Fromdate			= '2015-02-24'
	, @Todate			= '2050-01-01'
	, @Rate				= 0.07
	, @System			= 'OA,OAS'
	, @Remark			= 'Launch at 2015-02-24; Redmine: #31276'
	, @ChargeId = @ChargeId	OUTPUT
SELECT @ChargeId
GO
--VS
DECLARE @ChargeId INT
EXEC dbo.OAS_ChargeInfoIns 
	  @ProductName		= 'VS'
	, @FromPartyName	= '666VIP'
	, @ToPartyName		= 'ONEWorks'	
	, @Fromdate			= '2015-02-24'
	, @Todate			= '2050-01-01'
	, @Rate				= 0.15
	, @System			= 'OA,OAS'
	, @Remark			= 'Launch at 2015-02-24; Redmine: #31276'
	, @ChargeId = @ChargeId	OUTPUT
SELECT @ChargeId
GO
--BA
DECLARE @ChargeId INT
EXEC dbo.OAS_ChargeInfoIns 
	  @ProductName		= 'BA'
	, @FromPartyName	= '666VIP'
	, @ToPartyName		= 'ONEWorks'	
	, @Fromdate			= '2015-02-24'
	, @Todate			= '2050-01-01'
	, @Rate				= 1
	, @System			= 'OA,OAS'
	, @Remark			= 'Launch at 2015-02-24; Redmine: #31276'
	, @ChargeId = @ChargeId	OUTPUT
SELECT @ChargeId
GO

--Licensee Admin
-- Insert Permission to User StarIX1
EXEC dbo.LA_UserPartyIns 
	  @UserName		= 'StarIX1'
	, @PartyName	= '666VIP'
GO
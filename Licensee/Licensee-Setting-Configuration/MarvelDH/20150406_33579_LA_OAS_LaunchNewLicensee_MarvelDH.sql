USE bodb_licensee
GO
/*
	Author: Florent.Nguyen
	Date: 20150406
	Task : Launch of new licensee MarvelDH	146
			+ Sportsbook, Number Game, Live Casino, RNG Casino, Virtual Sports and BA. ( ONEworks's Licensee)
			+ Launch at : 2015-03-25
	RedmineID: #33579
*/
-- Sportsbook
DECLARE @ChargeId INT
EXEC dbo.OAS_ChargeInfoIns 
	  @ProductName		= 'SB'
	, @FromPartyName	= 'MarvelDH'
	, @ToPartyName		= 'ONEWorks'	
	, @Fromdate			= '2015-03-25'
	, @Todate			= '2050-01-01'
	, @Rate				= 0.15
	, @Minfee			= 4000
	, @MinFeeCurrencyID	= 12
	, @WaiveMonth		= 3
	, @System			= 'OA,OAS'
	, @Remark			= 'Launch at 2015-03-25; Redmine: #33579'
	, @ChargeId = @ChargeId	OUTPUT
SELECT @ChargeId
GO
-- NG
DECLARE @ChargeId INT
EXEC dbo.OAS_ChargeInfoIns 
	  @ProductName		= 'NG'
	, @FromPartyName	= 'MarvelDH'
	, @ToPartyName		= 'ONEWorks'	
	, @Fromdate			= '2015-03-25'
	, @Todate			= '2050-01-01'
	, @Rate				= 0.15
	, @System			= 'OA,OAS'
	, @Remark			= 'Launch at 2015-03-25; Redmine: #33579'
	, @ChargeId = @ChargeId	OUTPUT
SELECT @ChargeId
GO
--LC
DECLARE @ChargeId INT
EXEC dbo.OAS_ChargeInfoIns 
	  @ProductName		= 'LC'
	, @FromPartyName	= 'MarvelDH'
	, @ToPartyName		= 'ONEWorks'	
	, @Fromdate			= '2015-03-25'
	, @Todate			= '2050-01-01'
	, @Rate				= 0.07
	, @System			= 'OA,OAS'
	, @Remark			= 'Launch at 2015-03-25; Redmine: #33579'
	, @ChargeId = @ChargeId	OUTPUT
SELECT @ChargeId
GO
--RnG Casino
DECLARE @ChargeId INT
EXEC dbo.OAS_ChargeInfoIns 
	  @ProductName		= 'CS'
	, @FromPartyName	= 'MarvelDH'
	, @ToPartyName		= 'ONEWorks'	
	, @Fromdate			= '2015-03-25'
	, @Todate			= '2050-01-01'
	, @Rate				= 0.07
	, @System			= 'OA,OAS'
	, @Remark			= 'Launch at 2015-03-25; Redmine: #33579'
	, @ChargeId = @ChargeId	OUTPUT
SELECT @ChargeId
GO
--VS
DECLARE @ChargeId INT
EXEC dbo.OAS_ChargeInfoIns 
	  @ProductName		= 'VS'
	, @FromPartyName	= 'MarvelDH'
	, @ToPartyName		= 'ONEWorks'	
	, @Fromdate			= '2015-03-25'
	, @Todate			= '2050-01-01'
	, @Rate				= 0.15
	, @System			= 'OA,OAS'
	, @Remark			= 'Launch at 2015-03-25; Redmine: #33579'
	, @ChargeId = @ChargeId	OUTPUT
SELECT @ChargeId
GO
--BA
DECLARE @ChargeId INT
EXEC dbo.OAS_ChargeInfoIns 
	  @ProductName		= 'BA'
	, @FromPartyName	= 'MarvelDH'
	, @ToPartyName		= 'ONEWorks'	
	, @Fromdate			= '2015-03-25'
	, @Todate			= '2050-01-01'
	, @Rate				= 1
	, @System			= 'OA,OAS'
	, @Remark			= 'Launch at 2015-03-25; Redmine: #33579'
	, @ChargeId = @ChargeId	OUTPUT
SELECT @ChargeId
GO
-- Insert Permission to User StarIX1
EXEC dbo.LA_UserPartyIns 
	  @UserName		= 'StarIX1'
	, @PartyName	= 'MarvelDH'
GO
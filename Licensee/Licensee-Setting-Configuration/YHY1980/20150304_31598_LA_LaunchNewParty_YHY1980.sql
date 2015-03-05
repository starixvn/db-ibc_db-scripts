USE bodb_licensee
GO
/*
	Author: Florent.Nguyen
	Date: 20150304
	Task : Launch of new licensee YHY1980
			+ Sportsbook, Number game, Live casino, RNG casino, and Virtual Sports. ( Boping's Licensee)
			+ Launch at : 2015-03-02
	RedmineID: #31598
*/
-- Sportsbook
DECLARE @ChargeId INT
EXEC dbo.OAS_ChargeInfoIns 
	  @ProductName		= 'SB'
	, @FromPartyName	= 'YHY1980'
	, @ToPartyName		= 'Boping'	
	, @Fromdate			= '2015-03-02'
	, @Todate			= '2050-01-01'
	, @Rate				= 0.15
	, @Minfee			= 3000
	, @MinFeeCurrencyID	= 12
	, @WaiveMonth		= 1
	, @System			= 'OA'
	, @Remark			= 'Launch at 2015-03-02; Redmine: #31598'
	, @ChargeId = @ChargeId	OUTPUT
SELECT @ChargeId
GO
-- NG
DECLARE @ChargeId INT
EXEC dbo.OAS_ChargeInfoIns 
	  @ProductName		= 'NG'
	, @FromPartyName	= 'YHY1980'
	, @ToPartyName		= 'Boping'	
	, @Fromdate			= '2015-03-02'
	, @Todate			= '2050-01-01'
	, @Rate				= 0.15
	, @System			= 'OA'
	, @Remark			= 'Launch at 2015-03-02; Redmine: #31598'
	, @ChargeId = @ChargeId	OUTPUT
SELECT @ChargeId
GO
--LC
DECLARE @ChargeId INT
EXEC dbo.OAS_ChargeInfoIns 
	  @ProductName		= 'LC'
	, @FromPartyName	= 'YHY1980'
	, @ToPartyName		= 'Boping'	
	, @Fromdate			= '2015-03-02'
	, @Todate			= '2050-01-01'
	, @Rate				= 0.07
	, @System			= 'OA'
	, @Remark			= 'Launch at 2015-03-02; Redmine: #31598'
	, @ChargeId = @ChargeId	OUTPUT
SELECT @ChargeId
GO
--RnG Casino
DECLARE @ChargeId INT
EXEC dbo.OAS_ChargeInfoIns 
	  @ProductName		= 'CS'
	, @FromPartyName	= 'YHY1980'
	, @ToPartyName		= 'Boping'	
	, @Fromdate			= '2015-03-02'
	, @Todate			= '2050-01-01'
	, @Rate				= 0.07
	, @System			= 'OA'
	, @Remark			= 'Launch at 2015-03-02; Redmine: #31598'
	, @ChargeId = @ChargeId	OUTPUT
SELECT @ChargeId
GO
--VS
DECLARE @ChargeId INT
EXEC dbo.OAS_ChargeInfoIns 
	  @ProductName		= 'VS'
	, @FromPartyName	= 'YHY1980'
	, @ToPartyName		= 'Boping'	
	, @Fromdate			= '2015-03-02'
	, @Todate			= '2050-01-01'
	, @Rate				= 0.15
	, @System			= 'OA'
	, @Remark			= 'Launch at 2015-03-02; Redmine: #31598'
	, @ChargeId = @ChargeId	OUTPUT
SELECT @ChargeId
GO

--Licensee Admin
-- Insert Permission to User StarIX1
EXEC dbo.LA_UserPartyIns 
	  @UserName		= 'StarIX1'
	, @PartyName	= 'YHY1980'
GO
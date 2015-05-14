USE bodb_licensee
GO
/*
	Author: Jim.Tran
	Date: 20150429
	Task : Launch new product 
			+ Licensee: BE7
			+ AG Casino ( Boping Athena's Licensee)
			+ GD ( Boping Athena's Licensee)
			+ Launch at : 2015-04-28
	RedmineID: #35121
*/

--AG Casino
DECLARE @ChargeId_AGC INT
EXEC dbo.OAS_ChargeInfoIns 
	  @ProductName		= 'AGC'
	, @FromPartyName	= 'BE7'
	, @ToPartyName		= 'Boping'	
	, @Fromdate			= '2015-04-28'
	, @Todate			= '2050-01-01'
	, @Rate				= 0.15
	, @System			= 'OA,OAS'
	, @Remark			= 'Licensee Site ID 144 - Launch AG & GD Casino; Redmine: #35121'
	, @ChargeId = @ChargeId_AGC	OUTPUT
SELECT @ChargeId_AGC
GO
-- Gold Deluxe
DECLARE @ChargeId_GD INT
EXEC dbo.OAS_ChargeInfoIns 
	  @ProductName		= 'GD'
	, @FromPartyName	= 'BE7'
	, @ToPartyName		= 'Boping'	
	, @Fromdate			= '2015-04-28'
	, @Todate			= '2050-01-01'
	, @Rate				= 0.15
	, @System			= 'OA,OAS'
	, @Remark			= 'Licensee Site ID 144 - Launch AG & GD Casino; Redmine: #35121'
	, @ChargeId = @ChargeId_GD	OUTPUT
SELECT @ChargeId_GD

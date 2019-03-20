USE bodb_licensee
GO 

/*
Create: 20190320@Sophia
Task: Insert data trial of Mbet for AGC/GD in to OAS_ChargeInfo table:
Redmine:  #110567
*/

DECLARE @ChargeId INT
EXEC dbo.OAS_ChargeInfoIns 
	  @ProductName		= 'GD'
	, @FromPartyName	= 'MBet'
	, @ToPartyName		= 'Boping'	
	, @Fromdate			= NULL
	, @Todate			= '2050-01-01'
	, @Rate				= 0.08		
	, @BaseCurrencyId	= 6		
	, @System			= 'OA'
	, @Remark			= 'Trial'
	, @ChargeId			= @ChargeId	OUTPUT
SELECT @ChargeId
GO


DECLARE @ChargeId INT
EXEC dbo.OAS_ChargeInfoIns 
	  @ProductName		= 'AGC'
	, @FromPartyName	= 'MBet'
	, @ToPartyName		= 'Boping'	
	, @Fromdate			= NULL
	, @Todate			= '2050-01-01'
	, @Rate				= 0.11		
	, @BaseCurrencyId	= 6		
	, @System			= 'OA'
	, @Remark			= 'Trial'
	, @ChargeId			= @ChargeId	OUTPUT
SELECT @ChargeId
GO




 
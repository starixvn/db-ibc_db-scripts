USE bodb_licensee
GO
/*
	Author: Florent.Nguyen
	Date: 20150410
	Task : Launch of product
			+ Licensee: Q8bola
			+ BA ( Boping's Licensee)
			+ Launch at : 2014-09-01
	RedmineID: #34153
*/
--BA
DECLARE @ChargeId INT
EXEC dbo.OAS_ChargeInfoIns 
	  @ProductName		= 'BA'
	, @FromPartyName	= 'Q8bola'
	, @ToPartyName		= 'Boping'	
	, @Fromdate			= '2014-09-01'
	, @Todate			= '2050-01-01'
	, @Rate				= 1
	, @System			= 'OA'
	, @Remark			= 'Launch at 2014-09-01; Redmine: #34153'
	, @ChargeId = @ChargeId	OUTPUT
SELECT @ChargeId
GO

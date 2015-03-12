USE bodb_licensee
GO
/*
	Author: Florent.Nguyen
	Date: 20150312
	Task : Offer AG Casino to licensee Aoncash		
			+ Launch at : 2015-03-10
	RedmineID: #31276
*/
DECLARE @ChargeId INT
EXEC dbo.OAS_ChargeInfoIns 
	  @ProductName		= 'AGC'
	, @FromPartyName	= 'Aoncash'
	, @ToPartyName		= 'Boping'	
	, @Fromdate			= '2015-03-10'
	, @Todate			= '2050-01-01'
	, @Rate				= 0.15
	, @System			= 'OA'
	, @Remark			= 'Launch at 2015-03-10; Redmine: #32078'
	, @ChargeId = @ChargeId	OUTPUT
SELECT @ChargeId
USE bodb_licensee
GO
/*
	Author: Florent.Nguyen
	Date: 20150212
	Task : Launch Virtual Sort , licensee Aoncash, M8Bola, Q8Bola ( Boping's Licensee)
			+ Launch at : 2015-02-10
	RedmineID: #30936
*/
--Q8Bola
DECLARE @ChargeId INT
EXEC dbo.OAS_ChargeInfoIns 
	  @ProductName		= 'VS'
	, @FromPartyName	= 'Q8Bola'
	, @ToPartyName		= 'Boping'	
	, @Fromdate			= '2015-02-10'
	, @Todate			= '2050-01-01'
	, @Rate				= 0.15
	, @System			= 'OA'
	, @Remark			= 'Launch at 2015-02-10; Redmine: #30936'
	, @ChargeId = @ChargeId	OUTPUT
SELECT @ChargeId
USE bodb_licensee
GO
/*
	Author: Florent.Nguyen
	Date: 20150226 
	Task : Launch Virtual Sort , licensee Bwinning ( Boping's Licensee)
			+ Launch at : 2015-02-26
	RedmineID: #31389
*/
-- Bwinning
DECLARE @ChargeId INT
EXEC dbo.OAS_ChargeInfoIns 
	  @ProductName		= 'VS'
	, @FromPartyName	= 'Bwinning'
	, @ToPartyName		= 'Boping'	
	, @Fromdate			= '2015-02-13'
	, @Todate			= '2050-01-01'
	, @Rate				= 0.15
	, @System			= 'OA'
	, @Remark			= 'Launch at 2015-02-13; Redmine: #31389'
	, @ChargeId = @ChargeId	OUTPUT
SELECT @ChargeId
GO
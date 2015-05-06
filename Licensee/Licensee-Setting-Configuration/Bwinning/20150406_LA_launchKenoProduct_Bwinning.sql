USE bodb_licensee
GO
/*
	Author: Florent.Nguyen
	Date: 201500406
	Task : launch Bwinning	57	L057
		+ Product: Keno
	RedmineID: #33495
*/
--Keno
DECLARE @ChargeId INT
EXEC dbo.OAS_ChargeInfoIns 
	  @ProductName		= 'KN'
	, @FromPartyName	= 'Bwinning'
	, @ToPartyName		= 'Boping'	
	, @Fromdate			= '2015-04-01'
	, @Todate			= '2050-01-01'
	, @Rate				= 0.10
	, @System			= 'OA'
	, @Remark			= 'Launch at 2015-04-01; RedmineID #33495'
	, @ChargeId = @ChargeId	OUTPUT
SELECT @ChargeId
GO

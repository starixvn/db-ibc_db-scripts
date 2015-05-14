USE bodb_licensee
GO
/*
	Author: Florent.Nguyen
	Date: 20150409
	Task : Launch new product 
			+ Licensee: M8bola
			+ AG Casino ( Boping Athena's Licensee)
			+ Launch at : 2015-04-07
	RedmineID: #33973
*/

--AG Casino
DECLARE @ChargeId INT
EXEC dbo.OAS_ChargeInfoIns 
	  @ProductName		= 'AGC'
	, @FromPartyName	= 'M8bola'
	, @ToPartyName		= 'Boping'	
	, @Fromdate			= '2015-04-07'
	, @Todate			= '2050-01-01'
	, @Rate				= 0.15
	, @System			= 'OA'
	, @Remark			= 'Launch at 2015-04-07; Redmine: #33973'
	, @ChargeId = @ChargeId	OUTPUT
SELECT @ChargeId
GO
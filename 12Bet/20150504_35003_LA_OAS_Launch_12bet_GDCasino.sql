USE bodb_licensee
GO
/*
	Author: Florent.Nguyen
	Date: 20150504
	Task : Launch of licensee 12Bet
			+ Gold Deluxe ( ONEworks's Licensee)
			+ Launch at : 2015-04-21
	RedmineID: #35003
*/

DECLARE @NewLicenseeName VARCHAR(20)
	, @Company	VARCHAR(20)
	, @Fromdate	DATE
	, @ToDate	DATE
	, @System	VARCHAR(10)
	, @Remarks	VARCHAR(50)
	, @ChargeId INT

SELECT @NewLicenseeName = '12Bet'
	   , @Company		= 'ONEWorks'
	   , @Fromdate		= '2015-04-21'
	   , @ToDate		= '2050-01-01'
	   , @System		= 'OAS,OA'
	   , @Remarks		= 'Launch at 2015-04-21; Redmine: #35003'

--GD Casino
EXEC dbo.OAS_ChargeInfoIns 
	  @ProductName		= 'GD'
	, @FromPartyName	= @NewLicenseeName
	, @ToPartyName		= @Company
	, @Fromdate			= @Fromdate
	, @Todate			= @ToDate
	, @Rate				= 0.15
	, @System			= @System
	, @Remark			= @Remarks
	, @ChargeId			= @ChargeId	OUTPUT
SELECT @ChargeId

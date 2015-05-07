

USE bodb_licensee
GO
/*
	Author: Florent.Nguyen
	Date: 20150420
	Task : Launch of new licensee 
			+ Licensee: 167 - Doctorgame
			+ Products: Live Casino, RnG Casino ( Boping API's Licensee)
			+ Launch at : 2015-04-15
	RedmineID: #34393
	Remark: 
*/

DECLARE @NewLicenseeName VARCHAR(20)
	, @Company	VARCHAR(20)
	, @Fromdate	DATE
	, @ToDate	DATE
	, @System	VARCHAR(10)
	, @Remarks	VARCHAR(50)
	, @ChargeId INT

SELECT @NewLicenseeName = 'Doctorgame'
	   , @Company		= 'Boping'
	   , @Fromdate		= '2015-04-15'
	   , @ToDate		= '2050-01-01'
	   , @System		= 'OA'
	   , @Remarks		= 'Launch at 2015-04-15; Redmine: #34393'
--LC
EXEC dbo.OAS_ChargeInfoIns 
	  @ProductName		= 'LC'
	, @FromPartyName	= @NewLicenseeName
	, @ToPartyName		= @Company
	, @Fromdate			= @Fromdate
	, @Todate			= @ToDate
	, @Rate				= 0.07
	, @System			= @System
	, @Remark			= @Remarks
	, @ChargeId = @ChargeId	OUTPUT
SELECT @ChargeId

--RnG Casino
EXEC dbo.OAS_ChargeInfoIns 
	  @ProductName		= 'CS'
	, @FromPartyName	= @NewLicenseeName
	, @ToPartyName		= @Company
	, @Fromdate			= @Fromdate
	, @Todate			= @ToDate
	, @Rate				= 0.07
	, @System			= @System
	, @Remark			= @Remarks
	, @ChargeId = @ChargeId	OUTPUT
SELECT @ChargeId

-- Insert Permission to User StarIX1
EXEC dbo.LA_UserPartyIns 
	  @UserName		= 'StarIX1'
	, @PartyName	= @NewLicenseeName
GO	
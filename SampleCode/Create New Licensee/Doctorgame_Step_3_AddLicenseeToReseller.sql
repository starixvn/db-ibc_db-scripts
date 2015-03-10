USE [bodb_Licensee]
GO

/* Optional: */
-- Create new reseller (direct)
DECLARE @ResellerName VARCHAR(50)
		,@ResellerType TINYINT
		,@Site VARCHAR(10)
		,@LicenseeID INT
		,@ResellerID INT
		
SELECT @ResellerName = 'Boping'
		,@ResellerType = 2
		,@Site = 'Doctorgame'

/* Create New Reseller */		
IF NOT EXISTS (SELECT 1 FROM dbo.Resellers WITH (NOLOCK) WHERE ResellerName = @ResellerName)
BEGIN 
	INSERT INTO dbo.Resellers(ResellerName,Description,ResellerType)
	SELECT @ResellerName, NULL, @ResellerType
END

 
/* Add licensee to reseller */

SELECT @LicenseeID = LicenseeID FROM dbo.Licensees (NOLOCK) WHERE LicenseeName = @Site
SELECT @ResellerID = ResellerID FROM dbo.Resellers (NOLOCK) WHERE ResellerName = @ResellerName

IF (ISNULL(@LicenseeID,0) = 0 OR ISNULL(@ResellerID,0) = 0)
BEGIN

	PRINT '@LicenseeID or @ResellerID are invalid.'
	RETURN

END

IF NOT EXISTS (SELECT 1 FROM dbo.LicenseeReseller WITH (NOLOCK) WHERE LicenseeId = @LicenseeID  AND ResellerId = @resellerid)
BEGIN 
	INSERT INTO LicenseeReseller (ResellerID,LicenseeID,TnxRate)
	SELECT @resellerid AS ResellerID, @LicenseeID AS LicenseeID,0.13 AS TnxRate
END

IF NOT EXISTS (SELECT 1 FROM dbo.OA_FunctionLicensees WITH (NOLOCK)
						WHERE resellerid=@resellerid 
						AND LicenseeID=@LicenseeID
				)
BEGIN 
	INSERT INTO OA_FunctionLicensees
	SELECT functionid, @resellerid, @LicenseeID
	FROM OA_Functions (NOLOCK)
	WHERE FunctionID IN 
		(
			4, --Total Transaction
			5, --Win Loss Report
			11,--Currency Win Loss Report
			16,--Virtual Sport
			17,--Live Casino Win Loss
			20,--Licensee Win Loss
			21,--RNG Casino Win Loss
			23,--Performance
			24,--Performance
			25,--Performance by Turnover
			26 --Performance by Licensing Fee
		)
END

IF NOT EXISTS (SELECT 1 FROM OA_GroupLicensees WITH (NOLOCK)
						WHERE ResellerID=@ResellerID 
						AND   LicenseeID=@LicenseeID
				)
BEGIN 
	INSERT INTO OA_GroupLicensees
	SELECT Groupid, @resellerid, @LicenseeID 
	FROM OA_GroupLicensees
	WHERE licenseeid=9 AND resellerid = 2
END

IF NOT EXISTS (SELECT 1 FROM OA_UserLicensees WITH (NOLOCK)
						WHERE ResellerID=@ResellerID 
						AND LicenseeID=@LicenseeID
				)
BEGIN
	INSERT INTO OA_UserLicensees
	SELECT Userid, @resellerid, @LicenseeID
	FROM OA_UserLicensees
	WHERE licenseeid = 9 AND resellerid = 2
END

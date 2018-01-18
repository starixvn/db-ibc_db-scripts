USE bodb_licensee
GO

/*
	Created:	20171214@Harper
	Support:	Launch Exchange product for list licensees: 'spondemo', '12bet', 'Alog'
*/

DECLARE @LicenseeName VARCHAR(50),		
		@n INT,@m INT

-------------------------------------- ONEWorks Licensee-----------------------------------

DECLARE @tmpLicensee AS TABLE (ID INT IDENTITY(1,1), LicenseeID INT, LicenseeName VARCHAR(50))
INSERT INTO @tmpLicensee (LicenseeID, LicenseeName)
SELECT LicenseeID, LicenseeName
FROM dbo.Licensees (NOLOCK)
WHERE LicenseeName IN ('spondemo','12bet','Alog')
	
SELECT @n = 1
	  ,@m = MAX(ID) FROM @tmpLicensee
WHILE (@n <= @m)	  
BEGIN
	SELECT @LicenseeName = LicenseeName FROM @tmpLicensee WHERE ID = @n		

	DECLARE @ChargeID INT

	EXEC dbo.OAS_ChargeInfoIns 
		@ProductName = 'BX',
		@FromPartyName = @LicenseeName, 
		@ToPartyName = 'ONEWorks', 
		@FromDate = NULL,  ---- due to trial, so this field will have NULL data 
		@ToDate = '2050-01-01', 
		@ChargeType = 1, 
		@Rate = 0.4, 
		@System = 'OA,OAS', 
		@Remark	= 'Trial at 2017-12-01; Redmine: #84208',
		@ChargeId = @ChargeID OUTPUT 	
	SELECT @ChargeID
	
	EXEC dbo.OAS_ChargeInfoIns 
		@ProductName = 'BX',
		@FromPartyName = @LicenseeName,
		@ToPartyName = 'ONEWorks', 
		@FromDate = NULL,  ---- due to trial, so this field will have NULL data 
		@ToDate = '2050-01-01', 
		@ChargeType = 12, 
		@Rate = 0.02, 
		@System = 'OA,OAS', 
		@Remark	= 'Trial at 2017-12-01; Redmine: #84208',
		@ChargeId = @ChargeID OUTPUT 	

	SELECT @ChargeID

	SET @n = @n + 1 	
END

---- Boma365
USE bodb_licensee
GO
--- step 1: delete redundancy data
DECLARE @LicenseeID INT

SELECT @LicenseeID = LicenseeID
FROM dbo.Licensees WITH (NOLOCK) 
WHERE LicenseeName='Boma365'

SELECT *
	INTO #Boma365_bak
FROM dbo.CurrencyUser 
WHERE LicenseeID = @LicenseeID
	 AND  CurrencyID NOT IN (13,20) -- CNY,UUS
	 
DELETE dbo.CurrencyUser 
WHERE LicenseeID = @LicenseeID
	 AND  CurrencyID NOT IN (13,20) -- CNY,UUS
-- DROP TABLE #Boma365_bak	 

--- step 2: correct currency permision	 
USE bodb_Licensee
GO
EXEC [dbo].[DBA_CreateLicenseeAgent]
@LicenseeName = 'Boma365',
@SuperWildCard = 'Boma365Super%'
	 



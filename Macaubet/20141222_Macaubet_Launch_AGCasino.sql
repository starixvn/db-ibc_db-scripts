-- AG Casino
USE [bodb_licensee]
GO
/*
	Created by:  20141222@Jim
	Task: Macaubet - Launch of AG Casino (#27859)
	DB: DBLIC.bodb_licensee
	Revisions:
		
*/
DECLARE @LicenseeID INT
		,@EffectiveDate DATETIME
		,@ProductId INT 
DECLARE @tblsystem AS TABLE (systemid INT )

SELECT @LicenseeID = l.LicenseeID
		,@EffectiveDate = '2014-12-18'
FROM   dbo.Licensees l WITH (NOLOCK)
WHERE licenseename = 'Macaubet'

SELECT @ProductID = Productid
FROM dbo.Product3rd WITH (NOLOCK) 
WHERE ProductName = 'AG Casino'

--LicenseeProduct3rd
UPDATE  dbo.LicenseeProduct3rd 
SET EffectiveDate = @EffectiveDate
WHERE LicenseeId  = @LicenseeID
	AND ProductID = @ProductId

INSERT INTO @tblsystem(systemid)  
SELECT id AS systemid 
FROM dbo.systems WITH (NOLOCK)
WHERE systemname IN ('Accounting','OA')

-- SET active IN relevant system 
UPDATE 	dbo.systemlicensee
SET isactive=1 
WHERE licenseeid = @licenseeid
	AND systemid IN (SELECT systemid FROM @tblsystem)	


-- Casino
USE [bodb_licensee]
GO
/*
	Created by:  20141222@Jim
	Task: SLC88 - Launch of RnG Casino (#27774)
	DB: DBLIC.bodb_licensee
	Revisions:
		
*/
DECLARE @LicenseeID INT
		,@EffectiveDate DATETIME
DECLARE @tblsystem AS TABLE (systemid INT )

 
SELECT @LicenseeID = l.LicenseeID
		,@EffectiveDate = '2014-12-17'
FROM   dbo.Licensees l WITH (NOLOCK)
WHERE licenseename = 'SLC88'

--LicenseeProduct3rd
IF NOT EXISTS(SELECT 1 FROM dbo.LicenseeProduct3rd WITH (NOLOCK) WHERE ProductID=6 and LicenseeID=@LicenseeID )
	BEGIN
		INSERT INTO dbo.LicenseeProduct3rd (LicenseeID,ProductID,Comm,Winloss,EffectiveDate)
		SELECT @LicenseeID AS LicenseeID,6 AS ProductID,0 AS Comm,1 AS Winloss,@EffectiveDate AS EffectiveDate
	END
ELSE 
	BEGIN 
		UPDATE  dbo.LicenseeProduct3rd
		SET EffectiveDate = @EffectiveDate
		WHERE LicenseeId = @LicenseeID
			AND ProductID = 6  
	END

INSERT INTO @tblsystem(systemid)  
SELECT id AS systemid 
FROM dbo.systems WITH (NOLOCK)
WHERE systemname IN ('Accounting','OA')

-- SET active IN relevant system 
UPDATE 	dbo.systemlicensee
SET isactive=1 
WHERE licenseeid = @licenseeid
	AND systemid IN (SELECT systemid FROM @tblsystem)	

USE bodb_licensee

GO
/*
	Created: Jim  
	Date: 2015-01-02
    Task : HonorW - Launch of new licensee
    DB: dblic.bodb_licensee 
	
*/
-- DECLARE variable
DECLARE @licenseeid INT
DECLARE @AffectedDate datetime 
DECLARE @system AS TABLE (systemid INT )
DECLARE @product AS TABLE (productid INT )


-- init variable
SET @AffectedDate='2014-12-30'

SELECT @licenseeid = licenseeid
FROM dbo.licensees WITH (NOLOCK)
WHERE licenseename = 'HonorW'

INSERT INTO @system(systemid)  
SELECT id AS systemid 
FROM dbo.systems WITH (NOLOCK)
WHERE systemname IN ('Accounting')

----HonorW:Sportsbook, Number Game,Virtual Sports,BA
INSERT INTO  @product (productid)
SELECT productid
FROM dbo.Product3rd WITH (NOLOCK)
WHERE productname IN ('Number Game','Virtual Sports','BA')

----- SET Official launch date
UPDATE dbo.licensees
SET AffectedDate = @AffectedDate
WHERE licenseeid = @licenseeid

--- SET EffectiveDate
UPDATE dbo.licenseeproduct3rd
SET EffectiveDate = @AffectedDate
WHERE licenseeid = @licenseeid
	AND productid IN (SELECT productid FROM @product)
-- SET active IN relevant system 
UPDATE 	dbo.systemlicensee
SET isactive = 1 
WHERE licenseeid = @licenseeid
	and systemid IN (SELECT systemid FROM @system)	
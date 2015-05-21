USE bodb_licensee
GO
/*
Redmine #35084 : Licensee Site ID 159 - Support to change brandname
*/
UPDATE dbo.Licensees
SET BrandName='Kingmaker'
WHERE LicenseeName = '666VIP'
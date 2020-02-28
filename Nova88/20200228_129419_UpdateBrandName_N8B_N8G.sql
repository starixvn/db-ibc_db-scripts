use bodb_Licensee
GO 
 /*
 Created: 20200228@Sophia
 Task: Update brandName [Redmine: #129419]
 DB: DBCUST.bodb_Licensee
 */
 
UPDATE Licensees 
SET	   BrandName = 'Bwing'
WHERE  LicenseeName = 'N8B'

UPDATE Licensees 
SET	   BrandName = 'Goal123'
WHERE  LicenseeName = 'N8G '

 
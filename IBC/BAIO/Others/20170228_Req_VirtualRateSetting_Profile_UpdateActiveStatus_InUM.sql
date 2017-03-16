 /*
	Created: 2017@Helen
	Task : BAIO - [Redmine: 71609]
	DB: DBCust/CustDB		
*/
USE CustDB
GO
UPDATE ProfileVirtualSetting  WITH (ROWLOCK,UPDLOCK) 
SET isActive=1
WHERE sporttype = 2 AND bettype IN (20,21)
GO


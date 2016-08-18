  /*
	Created: 20160808Winnie
	Task : Esport Virtual Rate
	DB: DBCust/CustDB		
*/
USE CustDB
GO

UPDATE ProfileVirtualSetting  WITH (ROWLOCK,UPDLOCK) 
SET isActive=1
WHERE sporttype=43
GO



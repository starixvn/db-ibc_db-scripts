 /*
	Created: 20170316@Helen
	Task : BAIO - [Redmine: 71609]
	DB: DBCust/CustDB		
*/
USE CustDB
GO

INSERT INTO [CustDB].[dbo].[ProfileVirtualSetting]
           ([sporttype]
           ,[bettype]
           ,[islive]
           ,[isActive])
SELECT 2,20,1,0
UNION ALL
SELECT 2,20,0,0
UNION ALL
SELECT 2,21,1,0
UNION ALL
SELECT 2,21,0,0


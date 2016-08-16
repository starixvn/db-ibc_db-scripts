  /*
	Created: 20160808Winnie
	Task : Esport Virtual Rate
	DB: DBCust/CustDB		
*/
USE CustDB
GO

INSERT INTO [CustDB].[dbo].[ProfileVirtualSetting]
           ([sporttype]
           ,[bettype]
           ,[islive]
           ,[isActive])
SELECT 43,1,1,0
UNION
SELECT 43,1,0,0
UNION
SELECT 43,2,1,0
UNION
SELECT 43,2,0,0
UNION
SELECT 43,3,1,0
UNION
SELECT 43,3,0,0
UNION
SELECT 43,20,1,0
UNION
SELECT 43,20,0,0
GO


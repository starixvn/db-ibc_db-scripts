/*
	Created: Winnie
	Date: 2016-11-17
	Task: Insert ProfileVirtualSetting for UAT Cricket RedmineID:#66713
	DB: DBCUST/CustDB
*/ 

INSERT INTO [CustDB].[dbo].[ProfileVirtualSetting]
           ([sporttype]
           ,[bettype]
           ,[islive]
           ,[isActive])
     VALUES
           (27
           ,5
           ,1
           ,0)
GO
INSERT INTO [CustDB].[dbo].[ProfileVirtualSetting]
           ([sporttype]
           ,[bettype]
           ,[islive]
           ,[isActive])
     VALUES
           (27
           ,5
           ,0
           ,0)
GO


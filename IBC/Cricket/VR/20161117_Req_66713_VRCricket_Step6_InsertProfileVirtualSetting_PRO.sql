
/*
	Created: Winnie
	Date: 2016-11-17
	Task: Insert ProfileVirtualSetting for PRO Cricket RedmineID:#66713
	DB: DBCUST/CustDB
*/ 
SET IDENTITY_INSERT [CustDB].[dbo].[ProfileVirtualSetting] ON
INSERT INTO [CustDB].[dbo].[ProfileVirtualSetting]
           (profileID,
            [sporttype]
           ,[bettype]
           ,[islive]
           ,[isActive])
     VALUES
           (129
           ,27
           ,5
           ,1
           ,1)
GO
INSERT INTO [CustDB].[dbo].[ProfileVirtualSetting]
           (profileID,
			[sporttype]
           ,[bettype]
           ,[islive]
           ,[isActive])
     VALUES
           (130
           ,27
           ,5
           ,0
           ,1)
GO

SET IDENTITY_INSERT [CustDB].[dbo].[ProfileVirtualSetting] ON


/*
	Created: Winnie
	Date: 2016-09-05
	Task: insert MaxLimit_Cash
	DB: DBCUST/CustDB
*/ 

INSERT INTO [CustDB].[dbo].[VendorGlobalSetting]
           ([VendorId]
           ,[VName]
           ,[NumberValue])
     VALUES
           (4
           ,'MaxLimit_Cash'
           ,30000)
GO

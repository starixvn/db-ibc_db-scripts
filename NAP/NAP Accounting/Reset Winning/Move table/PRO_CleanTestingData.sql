USE [CustDB]
GO

/*
	Created by Percy
	Date: 2017-10-03
	DB: DBCUST.CustDB
	Task: Extra PT Setting - Clean testing data
*/

TRUNCATE TABLE dbo.Acc_GroupExtraPT_Product

DELETE dbo.Acc_GroupExtraPTSetting WITH (TABLOCK)
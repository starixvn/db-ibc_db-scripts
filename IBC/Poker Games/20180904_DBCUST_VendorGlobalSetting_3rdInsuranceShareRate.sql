USE [CustDB]
GO

/*
	Created: 20180904@Percy
	DB: DBCUST.CustDB
	Task: Insert new vendor setting - 3rdInsuranceShareRate - Poker Games
*/

INSERT INTO dbo.VendorGlobalSetting (VendorId, VName, NumberValue)
VALUES (33, '3rdInsuranceShareRate', 0.04)
USE CustDB
GO

/*
	Created: 20190423@Percy
	DB: DBCUST.CustDB
	Task: Pragmatic - Insert WL share setting into VendorGlobalSetting
*/

INSERT INTO dbo.VendorGlobalSetting (VendorId, VName, NumberValue)
VALUES (32, '3rdCashWLShareRate', 0.05)
		,(32, '3rdCreditWLShareRate', 0.035)
GO
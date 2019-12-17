USE CustDB
GO

/*
	Created: 20191211@Percy
	DB: DBCUST.CustDB
	Task: Remove Bettrade from ExtraPT Setting
*/

DELETE FROM dbo.Acc_GroupExtraPT_Product WITH (ROWLOCK, UPDLOCK)
WHERE ProductID = 1 AND Sporttype = 0 AND SubProduct IN ('BT-Bought', 'BT-Comm', 'BT-Sold', 'BT-Winloss')

DELETE FROM dbo.Acc_GroupExtraPTSetting WITH (ROWLOCK, UPDLOCK)
WHERE ProductID = 1 AND Sporttype = 0 AND SubProduct IN ('BT-Bought', 'BT-Comm', 'BT-Sold', 'BT-Winloss')
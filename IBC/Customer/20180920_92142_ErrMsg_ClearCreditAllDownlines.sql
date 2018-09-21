USE [CustDB]
GO

/*
	Created: 20180920@Percy
	DB: DBCUST.CustDB
	Task: New error message for clear credit all downlines
*/

INSERT INTO dbo.MsgError (MsgID,MsgGroupID,MsgNameEN,MsgNameCT,MsgNameCS,MsgNameJP,MsgNameTH,MsgNameKO,MsgNameES,MsgNameVI,IsActive,MsgNameCN)
VALUES (40036,5,'The selected customer has no credit to be cleared.', N'所選客戶無信用額度可清除', N'所选客户无信用额度可清除',
	'The selected customer has no credit to be cleared.','The selected customer has no credit to be cleared.',
	'The selected customer has no credit to be cleared.','The selected customer has no credit to be cleared.',
	'The selected customer has no credit to be cleared.',1,'The selected customer has no credit to be cleared.')
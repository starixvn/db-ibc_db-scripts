USE CustDB
GO

/*
	Created: 20190328@Percy
	DB: DBCUST.CustDB
	Task: CN88 - Add new error message for Update Credit
*/

INSERT INTO dbo.MsgError (MsgID,MsgGroupID,IsActive,MsgNameEN,MsgNameCT,MsgNameCN)
	VALUES(70026, 8, 1, N'New Credit is out of range, please refresh the form and try again.', N'新的信用額度超出範圍，請更新表單後重試。', N'新的信用额度超出范围，请刷新表单并重试。')

UPDATE dbo.MsgError WITH (ROWLOCK, UPDLOCK)
SET	MsgNameCS = MsgNameEN,
	MsgNameJP = MsgNameEN,
	MsgNameTH = MsgNameEN,
	MsgNameKO = MsgNameEN,
	MsgNameES = MsgNameEN,
	MsgNameVI = MsgNameEN
WHERE MsgID = 70026
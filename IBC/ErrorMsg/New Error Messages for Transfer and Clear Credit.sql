/*
	Created: 20181003@Percy
	DB: DBCUST.CustDB, DBTXN.bodb02, DBAGE.bodb02, DBEXT.bodb02
	Task: Import new error messages
*/

INSERT INTO dbo.MsgError (MsgID,MsgGroupID,MsgNameEN,IsActive)
SELECT 40037, 5, 'There are downline(s) with negative given credit.', 1
UNION ALL
SELECT 50012, 6, 'Transfer all will create negative bet credit on member(s). Please use the Transfer function to transfer for those members before transfer all by this function.', 1
UNION ALL
SELECT 50013, 6, 'There are member(s) who have been transferred today. Please try again tomorrow.', 1
UNION ALL
SELECT 50014, 6, 'You can only transfer on: ', 1
GO

UPDATE dbo.MsgError WITH (ROWLOCK, UPDLOCK)
SET MsgNameCT = MsgNameEN,
	MsgNameCS = MsgNameEN,
	MsgNameJP = MsgNameEN,
	MsgNameTH = MsgNameEN,
	MsgNameKO = MsgNameEN,
	MsgNameES = MsgNameEN,
	MsgNameVI = MsgNameEN,
	MsgNameCN = MsgNameEN
WHERE MsgID IN (40037, 50012, 50013, 50014)
GO
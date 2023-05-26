/*<info serverAlias="DBCUST-CustDB"></info>*/

/*
	Created by: Danny
	Date: 2023-05-26
	Task: Add message
	DB: DDBCUST-CustDB
	
*/
USE CustDB

GO

IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.MsgError WITH(NOLOCK) WHERE MsgID = 50010)
	INSERT INTO dbo.MsgError(MsgID, MsgGroupID, MsgNameEN, MsgNameCT, MsgNameCS, MsgNameJP, MsgNameTH, MsgNameKO, MsgNameES, MsgNameVI, IsActive, MsgNameCN)
	SELECT MsgID, MsgGroupID, MsgNameEN, MsgNameCT, MsgNameCS, MsgNameJP, MsgNameTH, MsgNameKO, MsgNameES, MsgNameVI, IsActive, MsgNameCN
	FROM DBTXN.bodb02.dbo.MsgError WITH(NOLOCK) WHERE MsgID = 50010

-- Recheck
-- SELECT * FROM dbo.MsgError WITH(NOLOCK) WHERE MsgID = 50010
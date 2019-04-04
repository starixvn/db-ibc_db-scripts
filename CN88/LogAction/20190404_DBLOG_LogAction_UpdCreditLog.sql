USE [bodb_CustomerLog]
GO

/*
	Created: 20190404@Percy
	DB: DBLOG.bodb_CustomerLog
	Task: CN88 - New update credit's log
*/

INSERT INTO dbo.LogAction (ActionID, SPName, ActionNameEN, IsInternal)
SELECT 1217, 'CS_Customer_Credit_Upd', 'Update Member''s Credit', 0 UNION ALL
SELECT 1218, 'CS_Customer_Credit_Upd', 'Update Agent''s Credit', 0 UNION ALL
SELECT 1219, 'CS_Customer_Credit_Upd', 'Update Master Agent''s Credit', 0 UNION ALL
SELECT 1220, 'CS_Customer_Credit_Upd', 'Update SMA''s Credit', 0

GO

UPDATE dbo.LogAction WITH (ROWLOCK, UPDLOCK)
SET ActionNameCH = ActionNameEN,
	ActionNameCS = ActionNameEN,
	ActionNameJP = ActionNameEN,
	ActionNameIT = ActionNameEN,
	ActionNameTH = ActionNameEN,
	ActionNameKO = ActionNameEN,
	ActionNameVI = ActionNameEN
WHERE ActionID BETWEEN 1217 AND 1220

GO
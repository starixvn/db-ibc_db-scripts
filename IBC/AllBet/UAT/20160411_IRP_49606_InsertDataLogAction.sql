/*
	Created by: Elodie
	Date: 20160411
	Task: Insert LogAction for sync status update
	DB: DBLOG / bodb_CustomerLog
*/

DELETE FROM LogAction WHERE ActionID = 1153
GO

INSERT INTO dbo.LogAction (ActionID,SPName,ActionNameEN,ActionNameCH,ActionNameCS,ActionNameJP,ActionNameTH,ActionNameKO,IsInternal,ActionNameVI)
VALUES (1153,'Acc_CustSetting_SyncStatusUpd'
		,'Update synchronized Other Products status'
		,'Update synchronized Other Products status'
		,'Update synchronized Other Products status'
		,'Update synchronized Other Products status'
		,'Update synchronized Other Products status'
		,'Update synchronized Other Products status'
		,0
		,'Update synchronized Other Products status'
		)

SELECT * FROM LogAction WITH (NOLOCK) WHERE ActionID = 1153
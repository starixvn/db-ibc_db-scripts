/*
	Created: 20170419@Helen
	Task: Add Extra information for Direct Accounts, for NAP only - [Redmine:72339]
	DB: DBLOG / bodb_CustomerLog
*/
USE bodb_CustomerLog
GO

INSERT INTO dbo.LogAction (ActionID,SPName,ActionNameEN,ActionNameCH,ActionNameCS,ActionNameJP,ActionNameTH,ActionNameKO,IsInternal,ActionNameVI)
VALUES (672,'Acc_CustDirectUpd'
		,'Update Extra Information'
		,'Update Extra Information'
		,'Update Extra Information'
		,'Update Extra Information'
		,'Update Extra Information'
		,'Update Extra Information'
		,1
		,'Update Extra Information'
		)

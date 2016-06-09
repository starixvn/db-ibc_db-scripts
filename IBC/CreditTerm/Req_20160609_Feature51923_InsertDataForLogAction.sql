/*
	Created by: Elodie
	Date: 2016-06-09
	Task: Add headline type and owner for group headline - [Redmine: #51923]
	DB: DBLOG/bodb_CustomerLog
*/
USE bodb_CustomerLog
GO

INSERT INTO dbo.LogAction (ActionID,SPName,ActionNameEN,ActionNameCH,ActionNameCS,ActionNameJP,ActionNameTH,ActionNameKO,IsInternal,ActionNameVI)
VALUES (660,'Acc_CustomerUpdGroupHeadlineType'
		,'Update Headline Type'
		,'Update Headline Type'
		,'Update Headline Type'
		,'Update Headline Type'
		,'Update Headline Type'
		,'Update Headline Type'
		,0
		,'Update Headline Type'
		)

GO
INSERT INTO dbo.LogAction (ActionID,SPName,ActionNameEN,ActionNameCH,ActionNameCS,ActionNameJP,ActionNameTH,ActionNameKO,IsInternal,ActionNameVI)
VALUES (661,'Acc_CustomerUpdGroupHeadlineOwner'
		,'Update Owner'
		,'Update Owner'
		,'Update Owner'
		,'Update Owner'
		,'Update Owner'
		,'Update Owner'
		,0
		,'Update Owner'
		)

/*
	Created: 20200212@Helen
	Task:[TVS] Auto Void Winning Bets [Redmine: #128836]
	DB: dblog/bodb_CustomerLog
*/
USE bodb_CustomerLog
GO

INSERT INTO dbo.LogAction (ActionID,SPName,ActionNameEN,ActionNameCH,ActionNameCS,ActionNameJP,ActionNameTH,ActionNameKO,IsInternal,ActionNameVI)
VALUES 
(90505,'TicketVoiding_AutoMarkProblemAccount_Job'
		,'Error Log For Auto Mark/UnMark Problem Account'
		,'Error Log For Auto Mark/UnMark Problem Account'
		,'Error Log For Auto Mark/UnMark Problem Account'
		,'Error Log For Auto Mark/UnMark Problem Account'
		,'Error Log For Auto Mark/UnMark Problem Account'
		,'Error Log For Auto Mark/UnMark Problem Account'
		,0
		,'Error Log For Auto Mark/UnMark Problem Account'
		)

